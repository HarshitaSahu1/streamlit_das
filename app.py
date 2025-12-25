import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import plotly.express as px
import seaborn as sns
import datetime as dt


# Step 3a: Set login state if not already
if "logged_in" not in st.session_state:
    st.session_state.logged_in = False

# Step 3b: Login UI
if not st.session_state.logged_in:
    st.title("Login Page")
    username = st.text_input("Username")
    password = st.text_input("Password", type="password")
    
    if st.button("Login"):
        if username == "admin" and password == "123":
            st.session_state.logged_in = True
            st.success("Login successful!")
            st.rerun()  # This refreshes the app to show dashboard
        else:
            st.error("Invalid username or password")

# Step 3c: Show dashboard only if logged in



def show_dashboard():
  # Set up the Streamlit app layout 
    st.set_page_config(layout="wide")
    st.title("Banking Data Analysis Dashboard")

    ## Load data 
    account = pd.read_csv("account_clean_22.csv")
    card = pd.read_csv("card_clean.csv")
    client = pd.read_csv("client_clean.csv")
    disp = pd.read_csv("disp_clean.csv")
    trans = pd.read_csv("trans_github_2.csv",sep = ',')
    loan = pd.read_csv("loan_clean.csv")
    orders = pd.read_csv("Orders_clean.csv")
    district = pd.read_csv("district_clean.csv")

    tab1,tab2,tab3,tab4,tab5 = st.tabs(["Transactional_Analysis","Loan_Analysis","Customer_Analysis","Location_Analysis","Time_Analysis"])

    with tab1:

        st.header("Transactional_Analysis")
        st.subheader("Transaction Data Overview")
        ### data overview

        st.dataframe(trans.head())

        ## KPIS for transaction data
        st.subheader("Key Performance Indicators (KPIs)")
        ## kpis calculation
        trans['date'] = pd.to_datetime(trans['date'],format = 'mixed')

        trans['year'] = pd.to_datetime(trans['date']).dt.year

        selected_transaction_type = st.multiselect("Select Transaction Type :",options = trans['type'].unique(),default = trans['type'].unique())

        selected_operation_type = st.multiselect("Select Operation Type :",options = trans['operation'].unique(),default = trans['operation'].unique())

        selected_year = st.multiselect("Selected_years :",options = trans['year'].unique(),default = trans['year'].unique())
        selected_options = trans[trans['operation'].isin(selected_operation_type)&
        trans['type'].isin(selected_transaction_type) & 
        trans['year'].isin(selected_year)]



        Total_Transactions = selected_options['trans_id'].shape[0]
        
        Avg_Transaction_Amount = round(selected_options['amount'].mean(),2)

        Unique_Accounts = selected_options['account_id'].nunique()

        Types_Transactions_operations = selected_options['operation'].nunique()

        most_trans_type =  selected_options.groupby('type')['trans_id'].count().sort_values(ascending = False).head(1).reset_index(name = 'Max_Amt')
        most_trans_type = most_trans_type['type'][0]

        most_trans_operation= selected_options.groupby('operation')['trans_id'].count().sort_values(ascending = False).head(1).reset_index(name = 'Max_Amt')
        most_trans_operation = most_trans_operation['operation'][0]

        Max_Amount_Transaction = selected_options['amount'].max()

        

        col1,col2 = st.columns(2)
        col3,col4 = st.columns(2)
        col5,col6 = st.columns(2)
        col7,= st.columns(1)

        with col1 :
            st.metric("Total Transactions", f"{Total_Transactions:,}")

        with col2:
            st.metric("Average Transaction Amount", f"{Avg_Transaction_Amount:,}")

        with col3:
            st.metric("Unique Accounts", f"{Unique_Accounts:,}")

        with col4:
            st.metric("Types of Transaction Operations",f"{Types_Transactions_operations:,}")

        with col5:
            st.metric("Most Frequent Transaction Type", most_trans_type)
        
        with col6:
            st.metric("Most Frequent Transaction Operations",most_trans_operation)

        with col7:
            st.metric("Most Amount Transaction Operations", f"{Max_Amount_Transaction:,}")

    

        st.markdown(" ")

        st.divider()

        st.markdown(" ")

        col1,spacer,col2= st.columns([1,0.05,1])

       

     
        with col1:
            st.subheader("Transaction Type Distribution")
            trans_type_distribute = selected_options.groupby('type')['trans_id'].count()
            fig,ax = plt.subplots(figsize = (2,2))
            ax.pie(trans_type_distribute.values ,
            labels = trans_type_distribute.index, wedgeprops={'width':0.4},autopct='%1.1f%%')
            st.pyplot(fig,width = "content")

        with spacer:
            st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )
            
        with col2:
            st.subheader("Transaction Operations Distributions")
            trans_operation_distribute = selected_options.groupby('operation')['trans_id'].count()
            fig, ax = plt.subplots(figsize = (5,3))
            bar = ax.bar(trans_operation_distribute.index,trans_operation_distribute.values)
            ax.bar_label(bar)
            ax.set_xticklabels(trans_operation_distribute.index,rotation = 90)
            ##ax.set_title('Transactions Distribution based on Operations')
            st.pyplot(fig,use_container_width=False)
        

        st.markdown(" ")
        st.divider()

        col3,spacer,col4= st.columns([1,0.05,1])

        with col3:
            st.subheader("Relationship between Age_Grps & Operations")
            operations_age_grps = (client.merge(disp,left_on = 'client_id' , right_on = 'client_id',how = 'left')
            .merge(account,left_on = 'account_id',right_on = 'account_id', how = 'left')
            .merge(selected_options,left_on = 'account_id',right_on = 'account_id', how = 'left'))

            operations_age_grps = operations_age_grps.groupby(['operation','Age_grps'])['trans_id'].count()

            operations_age_grps = pd.DataFrame(operations_age_grps)

            operations_age_grps = operations_age_grps.reset_index().pivot(index = 'operation',columns = 'Age_grps' , values = 'trans_id')

            fig,ax = plt.subplots(figsize= (4,3))
            sns.heatmap(operations_age_grps,cmap='YlGnBu',annot=True,fmt='g')
            st.pyplot(fig,use_container_width=False)

    

            st.markdown(" ")
            
        with spacer:
            st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )


        with col4:
            st.subheader("Yearly_trend Transactions counts")
            selected_options['date'] = pd.to_datetime(selected_options['date'],format = '%Y-%m-%d')
            selected_options['Year'] = selected_options['date'].dt.year
            yearly_trans = selected_options.groupby('Year')['trans_id'].count()

            fig,ax = plt.subplots(figsize = (4,3))
            ax.plot(yearly_trans.index.astype('int'),yearly_trans.values,marker = 'D')
            ax.set_xticklabels(yearly_trans.index.astype('int'))
            st.pyplot(fig,width = "content")

    with tab2:
        st.header("Loan_Analysis")
        st.subheader("Loan Data Overview")
        ### data overview

        st.dataframe(loan.head())

        
        ## KPIS for loan data   

        st.subheader("Key Performance Indicators (KPIs)")
        
        loan['duration_type'] = np.where(loan['duration'].isin([12,24]),'Short_Term_Loan',
        np.where (loan['duration'].isin([36,48]),'Medium_Term_Loan',
        np.where (loan['duration']==60,'Long_Term_Loan','other')))  

        selected_loan_type = st.multiselect("Select Loans Type :",options = loan['duration_type'].unique(),default = loan['duration_type'].unique())
        selected_loan_status = st.multiselect("Select Loan Status :",options = loan['status'].unique(),default = loan['status'].unique())
        loan['date'] = pd.to_datetime(loan['date'],format = '%Y-%m-%d')

        loan['year'] = loan['date'].dt.year

        selected_year = st.multiselect("Selected_Years :",options  = loan['year'].unique(),default = loan['year'].unique())

        loan['months'] = loan['date'].dt.month

        selected_months = st.multiselect("Selected_Months :",options = loan['months'].unique(),default = loan['months'].unique())

        selected_options = loan[loan['duration_type'].isin(selected_loan_type)&
        loan['status'].isin(selected_loan_status) & loan['year'].isin(selected_year) & loan['months'].isin(selected_months)]



        ## kpis calculation
        Total_Loan = selected_options['loan_id'].shape[0]
        Average_Loan_Amount = round(selected_options['amount'].mean(),2)
        client_loan_prct = (client.merge(disp,left_on = 'client_id' , right_on = 'client_id',how = 'left')
        .merge(account,left_on = 'account_id',right_on = 'account_id', how = 'left')
        .merge(selected_options,left_on = 'account_id',right_on = 'account_id', how = 'left'))
        loan_taken = client_loan_prct[client_loan_prct['loan_id'].notna()]['client_id'].nunique()
        total_cust = client['client_id'].count()
        clients_loan_taken_pct = loan_taken/total_cust
        Unique_Loan_Accounts = selected_options['account_id'].nunique()

        Top_1_loan_type = selected_options.groupby('duration_type')['loan_id'].count().sort_values(ascending = False).head(1).reset_index(name = 'Max_count')
        Top_1_loan_type = Top_1_loan_type['duration_type'][0]

        Top_1_loan_status =  selected_options.groupby('status')['loan_id'].count().sort_values(ascending = False).head(1).reset_index(name = 'Max_count')
        Top_1_loan_status =Top_1_loan_status['status'][0]
        
        col1,col2 = st.columns(2)
        col3,col4 = st.columns(2)
        col5,col6 = st.columns(2)

        with col1:
            st.metric("Total_Loans",f"{Total_Loan:,}")
        
        with col2:
            st.metric("Average Loan Amount",f"{Average_Loan_Amount:,}")

        with col3:
            st.metric("Clients with Loans (%)",f"{clients_loan_taken_pct:.2%}")

        with col4:
            st.metric("Unique Loan Accounts",f"{Unique_Loan_Accounts:,}")

        with col5:
            st.metric("Top_Loan_Type",Top_1_loan_type)

        with col6:
            st.metric("Top_Loan_Status",Top_1_loan_status)

        st.markdown(" ")

        st.divider()

        st.markdown(" ")

        col1,spacer,col2= st.columns([1,0.05,1])  

     



        with col1:
                st.subheader("Loan Type Distribution")
               

                loans_distribute = selected_options['duration_type'].value_counts()

                fig,ax = plt.subplots(figsize = (4,3))
                ax.pie(loans_distribute.values,labels=loans_distribute.index,autopct = '%1.1f%%')
                st.pyplot(fig,width = 'content')

        with spacer:
            st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )

        with col2:
                st.subheader("Age_Grps V/S Loan Type")
                disp_new = disp.loc[disp['type'] == 'OWNER',:]
                loan_age_grp = (client.merge(disp_new,left_on = 'client_id' , right_on = 'client_id',how = 'left')
                .merge(account,left_on = 'account_id',right_on = 'account_id', how = 'left')
                .merge(selected_options,left_on = 'account_id',right_on = 'account_id', how = 'left'))
                loan_age_grp = loan_age_grp.groupby('Age_grps')['loan_id'].count()
                fig,ax = plt.subplots(figsize = (4,3))
                barh = ax.barh(loan_age_grp.index,loan_age_grp.values)
                ax.bar_label(barh)
                ax.set_title('Age_Grps distribution by Loan')
                ax.set_ylabel('Age_Grps')
                ax.set_xlabel('loan_count')
                st.pyplot(fig,width = 'content')

        st.markdown(" ")

        st.divider()

        st.markdown(" ")

        col3,spacer,col4= st.columns([1,0.05,1])   

        with col3:
                st.subheader("Top 5 Districts based on Loan Amount")
                district_loan = (district.merge(account,left_on = 'District_Ids' , right_on = 'district_id',how = 'left')
                .merge(selected_options,left_on = 'account_id',right_on = 'account_id', how = 'left'))
                district_loan =(district_loan[district_loan['loan_id'].notna()]
                .groupby('District_Name')['amount']
                .sum()
                .sort_values(ascending = False)
                .head())

                fig,ax = plt.subplots(figsize = (4,3))
                bar = ax.bar(district_loan.index,district_loan.values)
                ax.tick_params(axis = "x",rotation = 90)
                st.pyplot(fig,width = 'content')

        with spacer:
            st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )

        with col4:
            st.subheader("Relationship between loan payment status and duration type")
            relation = selected_options.groupby(['status','duration_type'])['loan_id'].count().unstack()
            fig,ax = plt.subplots(figsize = (4,3))
            sns.heatmap(relation,cmap='YlGnBu',annot=True,fmt='d')
            st.pyplot(fig,width = 'content')



    with tab3:
        st.header("Customer_Analysis")
        st.subheader("Customer Data Overview")
        ### data overview

        st.dataframe(client.head())
        ## KPIS for customer data   
        st.subheader("Key Performance Indicators (KPIs)")

        selected_gender = st.multiselect("Selected_Gender: ",options = client['gender'].unique(),default = client['gender'].unique())
        selected_age_grps = st.multiselect("Selected_Age_Groups: ",options = client['Age_grps'].unique(),default = client['Age_grps'].unique())

        selected_options = client[client['gender'].isin(selected_gender)&client['Age_grps'].isin(selected_age_grps)]


        ## kpis calculation
        Total_Customers = selected_options['client_id'].shape[0]
        Avg_Client_Age = round(selected_options['Age'].mean(),0)
        trans_cust = (selected_options.merge(disp,how = 'left' , left_on = 'client_id',right_on = 'client_id')
        .merge(account,how = 'left',left_on = 'account_id',right_on = 'account_id')
        .merge(trans , how = 'left' , left_on = 'account_id',right_on = 'account_id'))
        Average_Transactions_per_Customer = trans_cust['trans_id'].nunique()/trans_cust['client_id'].nunique()
        Top_Age_grp = selected_options.groupby('Age_grps')['client_id'].count().sort_values(ascending = False).reset_index(name = 'Clients_Count').head(1)
        Top_Age_grp = Top_Age_grp['Age_grps'][0]
        Top_Operation_Type =  (selected_options.merge(disp,how = 'left' , left_on = 'client_id',right_on = 'client_id')
        .merge(account,how = 'left',left_on = 'account_id',right_on = 'account_id')
        .merge(trans , how = 'left' , left_on = 'account_id',right_on = 'account_id'))
        Top_Operation_Type = Top_Operation_Type.groupby('operation')['client_id'].count().sort_values(ascending = False).reset_index(name = 'operation_types').head(1)['operation'][0]
        Top_client_location = selected_options.merge(district,how = 'left' , left_on = 'district_id',right_on = 'District_Ids')
        Top_client_location = Top_client_location.groupby('Region')['client_id'].count().sort_values(ascending = False).reset_index(name = 'Region_counts').head(1)['Region'][0]

        col1,col2 = st.columns(2)
        col3,col4 = st.columns(2)
        col5,col6 = st.columns(2)

        with col1:
            st.metric("Total Customers",f"{Total_Customers:,}")
        
        with col2:     
            st.metric("Average Client Age",f"{Avg_Client_Age:,}")

        with col3:
            st.metric("Average Transactions per Customer",f"{Average_Transactions_per_Customer:.2f}")

        with col4:
            st.metric("Top_Age_grp",Top_Age_grp)

        with col5:
            st.metric("Top_Operation_Type",Top_Operation_Type)

        with col6:
            st.metric("Top_client_location",Top_client_location)
        

        st.markdown(" ")

        st.divider()

        st.markdown(" ")


        col1,spacer,col2= st.columns([1,0.05,1])
        with col1:
            gender_distributions = selected_options['gender'].value_counts()
            st.subheader("Customer Customer By Gender")
            fig,ax = plt.subplots(figsize= (4,3))
            ax.pie(x = gender_distributions.values , labels= gender_distributions.index,autopct='%1.1f%%')
            st.pyplot(fig,width = 'content')

        with spacer:
             st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )

        with col2:
            st.subheader("Customer Distribution by Age Groups")
            age_grp_distributions = selected_options['Age_grps'].value_counts()
            fig,ax = plt.subplots(figsize= (4,4))
            bar = ax.bar(age_grp_distributions.index,age_grp_distributions.values)
            ax.bar_label(bar)
            ax.set_xticklabels(age_grp_distributions.index,rotation = 90)
            st.pyplot(fig,width = 'content')

        
        st.markdown(" ")
        st.divider()
        st.markdown(" ")

        col3,spacer,col4= st.columns([1,0.05,1])

        with col3:
            st.subheader("Relationship between loan status and customer age groups")
            loan_cust = (selected_options.merge(disp,how = 'left' , left_on = 'client_id',right_on = 'client_id')
            .merge(account,how = 'left',left_on = 'account_id',right_on = 'account_id')
            .merge(loan , how = 'left' , left_on = 'account_id',right_on = 'account_id'))
            realtion_cust_loan = loan_cust.groupby(['Age_grps','status'])['client_id'].count().unstack()

            fig,ax = plt.subplots(figsize = (4,3))
            sns.heatmap(realtion_cust_loan,cmap ='YlGnBu',annot = True,fmt='g')
            st.pyplot(fig,width = 'content')

        with spacer:
             st.markdown("<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )

        with col4:
            st.subheader("Relationship between account_holder and age groups")
            account_holder = loan_cust.groupby(['type','Age_grps'])['client_id'].count().reset_index(name = 'client_count')
            account_pivot = account_holder.pivot(index = 'Age_grps',columns = 'type',values = 'client_count')
            fig,ax = plt.subplots(figsize = (4,3))
            account_pivot.plot(kind = 'bar',ax = ax)
            for container in ax.containers:
                ax.bar_label(container)
            st.pyplot(fig,width = 'content',use_container_width = True)


    with tab4:
        st.subheader("Location Data Overview")
        ### data overview

        st.dataframe(district.head())

        ## KPIS for location data
        st.subheader("Key Performance Indicators (KPIs)")

        selected_region = st.multiselect("Selected_Regions: ",options = district['Region'].unique(),default = district['Region'].unique())
        selected_District = st.multiselect("Selected_Districts: ",options = district['District_Name'].unique(),default = district['District_Name'].unique())

        selected_options = district[district['Region'].isin(selected_region)& district['District_Name'].isin(selected_District)]


        ## kpis calculation
        Total_Districts = selected_options['District_Ids'].shape[0]
        Avg_District_Population = round(selected_options['Population'].mean(),0)
        Avg_Number_District_Region = round(selected_options.groupby('Region')['District_Name'].nunique().mean(),0)
        Avg_Salary = round(selected_options['Avg_Salary'].mean(),2)

        col1,col2 = st.columns(2)
        col3,col4 = st.columns(2)

        with col1:
            st.metric("Total Districts",f"{Total_Districts:,}")

        with col2:
            st.metric("Average District Population",f"{Avg_District_Population:,}")

        with col3:
            st.metric("Avg Number of Districts per Region",f"{Avg_Number_District_Region:,}")

        with col4:
            st.metric("Average Salary",f"{Avg_Salary:,}")

        st.markdown(" ")

        st.divider()

        st.markdown(" ")

        col1,spacer,col2 = st.columns([1,0.05,1])
        

        with col1:
            st.subheader("Top 5 District by Customer Count")
            client_districts = (client.merge(selected_options , left_on = 'district_id',right_on = 'District_Ids' , how = 'left' ))
            client_districts = client_districts.groupby('District_Name')['client_id'].count()
            client_districts = client_districts.sort_values(ascending= False).head()

            fig,ax = plt.subplots(figsize = (4,3))
            ax.bar(x = client_districts.index,height = client_districts.values)
            ax.set_xticklabels(client_districts.index,rotation = 90)
            for i,val in enumerate(client_districts.values):
                ax.text(i,val,val,ha = 'center' , va = 'bottom')
            st.pyplot(fig,width = 'content')
            st.write(" ")
            st.write(" ")
            st.divider()
            st.write(" ")

        with spacer:
            st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )

        with col2:
            st.subheader("Relationship between Population & Transactions & Salary ")
            district_trans = (selected_options.merge(account,left_on = 'District_Ids' , right_on = 'district_id',how = 'left')
            .merge(trans,left_on = 'account_id',right_on = 'account_id', how = 'left'))
            district_trans = district_trans.groupby('District_Name').agg({'Population':'mean','trans_id':'count','Avg_Salary':'mean'})
            district_trans.rename(columns = {'trans_id':'Transaction_Counts'},inplace = True)
            district_trans_corr = district_trans.corr()

            fig,ax = plt.subplots(figsize = (4,3))
            sns.heatmap(data = district_trans_corr ,cmap='YlGnBu')

            for i in range(district_trans_corr.shape[0]):
                for j in range(district_trans_corr.shape[1]):
                    ax.text(j+0.5,i+0.5,round(district_trans_corr.iloc[i,j],2),ha ='center' , va = 'center')
            st.pyplot(fig,width = 'content')
            st.write(" ")
            st.write(" ")
            st.divider()
            st.write(" ")

        col3,spacer,col4 = st.columns([1,0.05,1])

        with col3:
            st.subheader("Region-wise District Counts")
            region_district_count = selected_options.groupby('Region')['District_Name'].count().reset_index(name = 'District_counts')

            fig,ax = plt.subplots(figsize = (4,3))
            fig = px.treemap(region_district_count,path = ['Region'],values = 'District_counts')
            fig.update_traces(textinfo = 'label+value')
            st.plotly_chart(fig,width = 'content')

        with spacer:
             st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )
            

        with col4:

            st.subheader("Do more districts in a region have more transactions?")
            district_trans = (selected_options.merge(account,left_on = 'District_Ids',right_on = 'district_id',how= 'left')
            .merge(trans ,left_on = 'account_id',right_on = 'account_id',how= 'left',suffixes = ('_account','_trans')))
            region_district_counts = district_trans.groupby('Region').agg({'trans_id':'count','District_Ids':'nunique'}).reset_index()
            region_district_counts.rename(columns = {"trans_id":'transaction_counts',"District_Ids":'District_counts'},inplace = True)

            fig,ax = plt.subplots(figsize = (4,3))
            ax.scatter(region_district_counts['transaction_counts'],region_district_counts['District_counts'],s= 100)
            ax.set_xlabel('Transaction_counts')
            ax.set_xticklabels(region_district_counts['transaction_counts'],rotation = 90)
            ax.set_ylabel('District_Counts')
            st.pyplot(fig,width = 'content')
        



        st.subheader("Yearly trend of trans_counts accross Regions")
        district_trans = (selected_options.merge(account,left_on = 'District_Ids',right_on = 'district_id',how= 'left')
        .merge(trans ,left_on = 'account_id',right_on = 'account_id',how= 'left',suffixes = ('_account','_trans')))
        district_trans['date_trans'] = pd.to_datetime(district_trans['date_trans'])
        district_trans['Years'] = district_trans['date_trans'].dt.year
        district_trans_counts = district_trans.groupby(['Years','Region'])['trans_id'].count().reset_index(name = 'trans_counts')
        district_trans_counts = district_trans_counts.pivot(index = 'Years',columns = 'Region',values='trans_counts')

        fig,ax = plt.subplots(figsize = (4,4))
        district_trans_counts.plot(kind = 'bar',ax = ax)
        plt.legend(loc = 'upper left')
        st.pyplot(fig,width = 'content')

    with tab5:
        st.header("Time_Analysis")
        trans['date'] = pd.to_datetime(trans['date'])
        trans['Year'] = pd.to_datetime(trans['date']).dt.year
        selected_year = st.multiselect("Select_Year",options = trans['Year'].unique(),default = trans['Year'].unique())
      
        trans['Months'] = trans['date'].dt.month
        selected_months = st.multiselect("Select_Months",options = trans['Months'].unique(),default = trans['Months'].unique())
        trans['Day'] = trans['date'].dt.day_name()
        select_day = st.multiselect("Selet_Days",options = trans['Day'].unique(),default = trans['Day'].unique())
       

        selected_options = trans[trans['Year'].isin(selected_year)& trans['Months'].isin(selected_months) & 
        trans['Day'].isin(select_day)]
       

        


        yearly_trans = selected_options.groupby('Year')['trans_id'].count()
        
        col1,spacer,col2 = st.columns([1,0.05,1])

        
        

        with col1:
            st.subheader("Yearly Trend of Transaction Amounts")
            yearly_amount = selected_options.groupby('Year')['amount'].sum()
            fig,ax = plt.subplots(figsize = (3,4))
            ax.plot(yearly_amount.index.astype('int'),yearly_amount.values,marker = 'D',color = 'orange')
            ax.set_xticklabels(yearly_amount.index.astype('int'))
            st.pyplot(fig,width = 'content')

            st.write(" ")
            st.write(" ")
            st.divider()

        
        
        months_trans = selected_options.groupby('Months')['trans_id'].count()

        with spacer:
             st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )

            

        with col2:
            st.subheader("Monthly Trend of Transaction Counts")
            fig,ax = plt.subplots(figsize = (3,4))

            ax.plot(months_trans.index.astype('int'),months_trans.values,marker = 'D')
            ax.set_xticklabels(months_trans.index.astype('int'))
            st.pyplot(fig,width = 'content')
            st.write(" ")
            st.write(" ")
            st.write(" ")

            st.divider()

            st.write(" ")
        
        col3,spacer,col4 = st.columns([1,0.05,1])

        with col3:
            

            day_trans = selected_options.groupby('Day')['trans_id'].count()

            st.subheader("Daily Trend of Transaction Counts")

            fig,ax = plt.subplots(figsize = (3,4))

            ax.plot(day_trans.index,day_trans.values,marker = 'o')
            for i,val in enumerate(day_trans.values):
                ax.text(i,val,val,ha = 'center' ,va = 'bottom')
                ax.set_xlabel('Days')
                ax.set_xticklabels(day_trans.index,rotation = 90)
                ax.set_ylabel('trans_counts')
            st.pyplot(fig,width = 'content')

        with spacer:
             st.markdown(
            "<div style='border-left:2px solid #aaa; height:600px;'></div>",
            unsafe_allow_html=True
            )

        with col4:
             st.subheader("Monthly Trends of Transaction Counts Across Regions")
             district_trans = (district.merge(account,left_on = 'District_Ids',right_on = 'district_id',how= 'left')
             .merge(selected_options ,left_on = 'account_id',right_on = 'account_id',how= 'left',suffixes = ('_account','_trans')))
             district_trans['Months'] = district_trans['date_trans'].dt.month
             district_trans_month_counts = district_trans.groupby(['Months','Region'])['trans_id'].count().reset_index(name = 'trans_counts')
             district_trans_month_counts = district_trans_month_counts.pivot(index = 'Months',columns = 'Region',values = 'trans_counts')

             fig,ax = plt.subplots(figsize =(3,4))
             district_trans_month_counts.plot(kind = 'line',marker = 'o',ax = ax)
             plt.legend(loc = 'upper left')
             st.pyplot(fig,width = 'content')
             
    
if st.session_state.logged_in:
    show_dashboard()

        

     


  


 


    



    










   

    
        
        








