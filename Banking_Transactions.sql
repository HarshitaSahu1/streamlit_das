select top 5* from district
select top 5* from [card]
select top 5* from disp
select top 5* from account
select top 5* from trans
select top 5* from [order]
select top 5* from client
select top 5* from loan

select distinct frequency from account 
select distinct [type] from [card]

select distinct frequency from account

select account_id from [order]
where account_id not between -32768 AND 32767

alter table [order]
alter column account_id smallint


select distinct [status] from loan 
select distinct k_symbol from [order]
select distinct [type] from trans
select distinct operation from trans


update account
set frequency = 'Monthly Fee'
where frequency = 'POPLATEK MESICNE'


update account
set frequency = 'Weekly Fee'
where frequency = 'POPLATEK TYDNE'

update account
set frequency = 'Fee Per Transactions'
where frequency = 'POPLATEK PO OBRATU'

select distinct frequency from account

select * from [card] 
order by issued desc

update card 
set issued = left(issued,6)

update card 
set issued = '19' + substring(issued,1,2) +'-' +
SUBSTRING(issued,3,2)+'-'+SUBSTRING(issued,5,2)

alter table card 
alter column
issued date 

update client
set birth_number = SUBSTRING(birth_number,1,2)+'-'+ SUBSTRING(birth_number,3,2) +'-'+SUBSTRING(birth_number,5,2)

EXEC sp_rename 'District.A1', 'District_Ids', 'COLUMN';
EXEC sp_rename 'District.A2', 'District_Name', 'COLUMN';
EXEC sp_rename 'District.A3', 'Region', 'COLUMN';
EXEC sp_rename 'District.A4', 'Population', 'COLUMN';
EXEC sp_rename 'District.A5', 'Villages', 'COLUMN';
EXEC sp_rename 'District.A6', 'Small_Town', 'COLUMN';
EXEC sp_rename 'District.A7', 'Medium_Town', 'COLUMN';
EXEC sp_rename 'District.A8', 'Large_Town', 'COLUMN';
EXEC sp_rename 'District.A9', 'No_Of_Cities', 'COLUMN';
EXEC sp_rename 'District.A10', 'Ratio_Of_Urban_Populations', 'COLUMN';
EXEC sp_rename 'District.A11', 'Avg_Salary', 'COLUMN';
EXEC sp_rename 'District.A12', 'Unemploment_Rate_1995', 'COLUMN';
EXEC sp_rename 'District.A13', 'Unemploment_Rate_1996', 'COLUMN';
EXEC sp_rename 'District.A14', 'No_of_Enterprenuers_per_1000', 'COLUMN';
EXEC sp_rename 'District.A15', 'No_of_Crimes_Commited_1995', 'COLUMN';
EXEC sp_rename 'District.A16', 'No_of_Crimes_Commited_1996', 'COLUMN';

Update [order]
set k_symbol = case when k_symbol = 'UVER' then 'Loan'
when k_symbol = 'SIPO' then 'SIPO_Payments'
when k_symbol = 'LEASING' then 'Leasing'
when k_symbol = 'POJISTNE' then 'Insurance'
when k_symbol Is Null then 'None'

update trans 
set [type] = case when [type] ='VYBER' then 'Withdrawal'
when [type]= 'VYDAJ' then 'Expense'
when [type]= 'PRIJEM' then 'Income' end

update trans 
set operation = case when operation = 'PREVOD Z UCTU' then 'Transfer from account'
when operation = 'VYBER' then 'Withdrawal'
when operation = 'PREVOD NA UCET' then 'Transfer to account'
when operation = 'VKLAD' then 'Deposit'
when operation = 'VYBER KARTOU' then 'Card Withdrawal' 
when operation is null then 'None' end

select * from trans 

update trans 
set k_symbol = case when k_symbol ='UVER' then 'Loan'
when k_symbol ='SIPO' then 'Household_Bills'
when k_symbol ='DUCHOD' then 'Pension'
when k_symbol ='SLUZBY' then 'Services payment'
when k_symbol ='SANKC. UROK' then 'Penalty interest'
when k_symbol ='POJISTNE' then 'Insurance payment'
when k_symbol ='UROK' then 'Interest payment'
when k_symbol ='' then 'None'
when k_symbol Is NULL then 'None' End

Update trans 
set bank = case when bank is null then 'None' else bank end

Update trans 
set account = case when account is null then 0 else account end


select top 5 * from account
select top 5 * from [card]
select top 5 * from client
select top 5 * from disp
select top 5 * from district
select top 5 * from loan
select top 5 * from [order]
select top 5 * from trans

select distinct account_id,* from account
select distinct card_id,* from [card]
select distinct client_id, * from client
select distinct disp_id, * from disp
select distinct district_Ids, * from district
select distinct loan_id,* from loan
select distinct order_id, * from [order]
select distinct trans_id , * from trans

select min(date) from trans
select max(date) from trans

--- Customer
--- Loan 
--- Transactions 

select distinct account_id from account

select distinct loan_id,* from account 
right join loan
on account.account_id = loan.account_id

select distinct loan_id,account_id, from loan

with distinct_trans_type  as(
select distinct [type] as trans_types,account_id from trans)


select trans.account_id,string_agg(cast(distinct_trans_type.trans_types as varchar(max)),',') as trans_types ,
string_agg(cast([operation] as varchar(max)),',') as trans_operation,sum(amount) as trans_amt,sum(balance) as trans_balance
,string_agg(cast(k_symbol as varchar(max)),',') as trans_k_symbols
from trans 
left join distinct_trans_type
on trans.account_id = distinct_trans_type.account_id
group by trans.account_id

select distinct loan_id,*
from loan 
left join account 
on loan.account_id = account.account_id
left join district 
on account.district_id = district.District_Ids
left join [order]
on account.account_id = [order].account_id
left join trans
on account.account_id = trans.account_id
group by loan_id
----***
join client
on district.District_Ids = client.district_id
join disp
on client.client_id = disp.client_id
join [card]
on disp.client_id = [card].disp_id


select distinct acco from account
left join trans
on account.account_id = trans.account_id

select * from trans
where account_id = 10079

select count(account_id) as acct_count,account_id from trans
group by account_id
having count(account_id)>1


with distinct_accounts as(
select distinct account_id,*  from trans

select count(*) as counts ,account_id from [order]
group by account_id
having count(*)>1 
order by counts desc

select distinct [Type] from trans 

select account_id,string_agg([Type],',') as trans_types ,
string_agg([operation],',') as trans_operation,sum(amount) as trans_amt,sum(balance) as trans_balance,string_agg(k_symbol,',') as trans_k_symbols
from trans 
group by account_id

select account_id ,string_agg(cast([type] as varchar(max)),',') as trans_type,string_agg(cast(operation as varchar(max)),',') as trans_operation,string_agg(cast(k_symbol as varchar(max)),',') as trans_symbol,
sum(trans_amt)as trans_amt,sum(trans_balance) as trans_balance from(
select account_id,[type],operation, k_symbol,sum(amount) as trans_amt,sum(balance) as trans_balance from trans 
group by account_id,[type],operation,k_symbol) as a
group by account_id

---------------------------***

-- transactions = 

select top 5* from trans
select distinct account_id from account
select * from account

;with clean_type as(
select distinct account_id,[type] from trans),

clean_operations as(
select distinct account_id,operation from trans),

clean_k_symbol as(
select distinct account_id,k_symbol from trans),

sums as(
select distinct account_id,round(sum(amount),2) as trans_amt,
round(sum(balance),2) as trans_balance,count(trans_id)as trans_counts from trans
group by account_id),
 
clean_trans_bank as(
select distinct account_id,bank
from trans),

clean_trans_account as(
select distinct account_id,account
from trans),

year_mon as(
select distinct account_id,Month([date]) as months,Year([Date])as years from trans),

dates_duration as (
select account_id,DATEDIFF(day,minimum_date,last_date_trans) as trans_duration_days,minimum_date
as minimum_date_trans,last_date_trans
from(
select min([date]) as minimum_date,max([date]) as last_date_trans,account_id
from trans
group by account_id) as a),

transactions_gaps as(
select account_id,avg(trans_gaps) as trans_gaps from(
select account_id,
lag([date],1) over(partition by account_id order by [date]) as previous_date,[date] as current_dates,
datediff(day,lag([date],1) over(partition by account_id order by [date]),[date]) as trans_gaps
from trans) as a
group by account_id),

months as (
select account_id,avg(trans_counts) as avg_tran_counts,Months from(
select account_id,month([date]) as Months ,count(trans_id) as trans_counts  from trans
group by account_id,month([date])) as a
group by account_id,Months
),

Years as (
select account_id,avg(trans_counts) as avg_tran_counts,years from(
select account_id,count(trans_id) as trans_counts ,year([date]) as years from trans
group by account_id,year([date])) as a
group by account_id,years
),


distincts_ as (
select account_id,avg(trans_counts) as avg_trans_counts ,months,years from(
select distinct account_id,Month([date]) as months,Year([Date])as years,count(trans_id) as trans_counts from trans
group by account_id,Month([date]),Year([Date])
) as a
group by account_id,months,years),

distinct_order_k_symbol as(
select distinct account_id , k_symbol from [order]),

distinct_order_bank_to as(
select distinct account_id , bank_to from [order]),

distinct_order_account_to as(
select distinct account_id , account_to from [order]),

orders_total_amts as(
select distinct account_id ,sum(amount) as order_amts from [order]
group by account_id )

select s.account_id
,(select string_agg(cast([type] as varchar(max)),',') from clean_type where s.account_id = clean_type.account_id)as [type],
(select string_agg(cast(operation as varchar(max)),',') from clean_operations where s.account_id = clean_operations.account_id)as operations,
(select string_agg(cast(k_symbol as varchar(max)),',') from clean_k_symbol where s.account_id = clean_k_symbol.account_id)as k_symbol,
(select string_agg(cast(bank as varchar(max)),',') from clean_trans_bank where s.account_id = clean_trans_bank.account_id)as bank,
(select string_agg(cast(account as varchar(max)),',') from clean_trans_account where s.account_id = clean_trans_account.account_id)as account,
sum(dates_duration.trans_duration_days) as trans_duration_days,min(dates_duration.minimum_date_trans) as trans_min_date
,max(dates_duration.last_date_trans) as trans_max_date,
sum(s.trans_amt)as trans_amt, sum(s.trans_balance) as trans_balance,sum(s.trans_counts) as trans_count,sum(transactions_gaps.trans_gaps) as avg_trans_gaps ,
(select string_agg(cast(Months as varchar(max)),',') from months where s.account_id = months.account_id and avg_tran_counts>5)as Months,
(select string_agg(cast(years as varchar(max)),',') from Years where s.account_id = Years.account_id and avg_tran_counts>5)as years,
(select string_agg(cast(k_symbol as varchar(max)),',') from distinct_order_k_symbol 
where s.account_id = distinct_order_k_symbol.account_id) as order_k_symbol,
(select string_agg(cast(bank_to as varchar(max)),',') from distinct_order_bank_to 
where s.account_id = distinct_order_bank_to.account_id) as order_bank_to,
(select string_agg(cast(account_to as varchar(max)),',') from distinct_order_account_to 
where s.account_id = distinct_order_account_to.account_id) as order_account_to,
max(order_amts) as order_total_amts 
into transactions_360
from sums as s
left join dates_duration
on s.account_id = dates_duration.account_id
left join transactions_gaps
on s.account_id = transactions_gaps.account_id
left join orders_total_amts
on s.account_id = orders_total_amts.account_id
group by s.account_id

select * from transactions_360 --- 4500 rows affected 


select top 5* from district
select top 5* from [card]
select top 5* from disp
select top 5* from account
select top 5* from trans
select top 5* from [order]
select top 5* from client

;with clients_records as(
select client_id , gender , dob,district_id from client 
),

trans_last_date as(
select max([date])as last_date,account_id from trans
group by account_id),

distinct_status as (
select account_id,
case when [status]='A'  then 'No_Delays'
when [status]='B' then 'Mild_Delays'
when [status]='C' then 'High_Delays'
else 'Bad_Debts' end as 'Loan_Status'
from loan
group by account_id,[status]),

distinct_loan_status as(
select account_id,
case when duration between 12 and 24 then 'Short_Term_Loan'
when duration between 36 and 48 then 'Medium_Term_Loan'
else 'Long_Term_Loan' end as 'Loan_Type' from loan
group by account_id,duration),

owner_types as(
select client_id,[type] from disp
group by client_id,[type]),

card_types as(
select disp_id,[type] as card_types from card
group by disp_id,[type] ),

trans_types as(
select 
account_id,[type] as trans_types
from trans
group by account_id,[type]),

trans_operation_types as(
select 
account_id,operation as trans_operation
from trans
group by account_id,operation)

select clients_records.client_id,
DATEDIFF(year,min(dob),max(last_date)) as age ,gender,
case when datediff(year , min(Dob), max(last_date)) <18 then 'Minor'
when datediff(year , min(Dob), max(last_date)) between 18 and 50
then 'Adult' else 'Senior' end as 'Age_Grp',district.District_Name,district.Region,count(Region) as region_client_counts,
 count(case when distinct_status.Loan_Status = 'High_Delays' then 1 end ) as  'High_delay',
 count(case when distinct_status.Loan_Status = 'Mild_Delays' then 1 end)as 'Mild_Delays',
 count(case when distinct_status.Loan_Status = 'No_Delays' then 1 end)as 'No_Delays',
 count(case when distinct_status.Loan_Status = 'Bad_Debts' then 1 end)as 'Bad_Debts',
 count(case when distinct_loan_status.Loan_Type = 'Short_Term_Loan' then 1 end)as 'Short_Term_Loan',
 count(case when distinct_loan_status.Loan_Type = 'Medium_Term_Loan' then 1 end)as 'Medium_Term_Loan',
 count(case when distinct_loan_status.Loan_Type = 'Long_Term_Loan' then 1 end)as 'Long_Term_Loan',
isnull(card_types,'cash') as card_types,
count(case when trans_types.[trans_types] = 'Withdrawal' then 1 end ) as  'Withdrawal',
count(case when trans_types.[trans_types] = 'Expense' then 1 end ) as  'Expense',
count(case when trans_types.[trans_types] = 'Income' then 1 end ) as  'Income',
count(case when trans_operation_types.trans_operation = 'None' then 1 end ) as  'No_Operation',
count(case when trans_operation_types.trans_operation = 'Transfer from account' then 1 end ) as  'Transfer from account',
count(case when trans_operation_types.trans_operation = 'Card Withdrawal' then 1 end ) as  'Card Withdrawal',
count(case when trans_operation_types.trans_operation = 'Withdrawal' then 1 end ) as  'operation_Withdrawal',
count(case when trans_operation_types.trans_operation = 'Deposit' then 1 end ) as  'Deposit',
count(case when trans_operation_types.trans_operation = 'Transfer to account' then 1 end ) as  'Transfer to account'
into customer_360
from clients_records
left join district
on clients_records.district_id = district.District_Ids
left join account
on district.District_Ids = account.district_id
left join trans_last_date
on account.account_id = trans_last_date.account_id
left join distinct_status
on account.account_id = distinct_status.account_id
left join loan
on account.account_id = loan.account_id
left join  distinct_loan_status
on loan.account_id = distinct_loan_status.account_id
left join owner_types
on clients_records.client_id = owner_types.client_id
left join disp
on clients_records.client_id = disp.client_id
left join card_types
on disp.disp_id = card_types.disp_id
left join trans_types
on account.account_id = trans_types.account_id
left join trans_operation_types
on account.account_id = trans_operation_types.account_id
group by clients_records.client_id,District_Name,gender,Region,isnull(card_types,'cash') 

----*** customer_360 - 5369 rows recorded

--- Analysis

select * from transactions_360
select * from customer_360

select top 5 * from trans
select count(distinct client_id) from client
select distinct District_Ids from district
select min([date]) , max([date]) from  trans 
select count(distinct account_id) from account
select count(distinct loan_id) from loan

--- How many transactions are there 
select count(distinct trans_id)as total_trans_counts from trans  ---- 10,56,320

--- Avg transactions per day 
select avg(transactions_counts) as avg_transactions_counts ,days_trans from(
select datename(weekday,[date]) as days_trans,
count(*) as transactions_counts
from trans
group by datename(weekday,[date])) as a
group by days_trans
order by avg_transactions_counts asc



--- which type of transactions more done

select [type],count(trans_id)as transactions_count from trans
group by [type]
order by transactions_count desc

--- which type of operation is most frequently done 
select operation,count(trans_id) as operations_counts from trans 
group by operation
order by operations_counts desc

--- if there is a difference between balance and account then where the money went the flow of money
select avg(trans_flowed) as avg_trans_flowed,account_id,k_symbol,bank,account,[type],operation from(
select account_id,k_symbol,sum(amount)as amount,[type],operation,
sum(balance)as balance,bank,account
,sum(amount)-sum(balance) as trans_flowed
from trans
group by account_id,k_symbol,bank,account,[type],operation
having sum(amount)<> sum(balance)) as a
group by account_id,k_symbol,bank,account,[type],operation
order by avg_trans_flowed 

select sum(balance)-sum(amount) as trans_flowed,account_id,sum(amount) as amount,sum(balance)as balance from trans
group by account_id


select account_id,k_symbol,sum(amount)as amount,[type],operation,
sum(balance)as balance,bank,account
,sum(amount)-sum(balance) as trans_flowed
from trans
--where [type] = 'None' 
--and [type] = 'None' and operation = 'None'k_symbol = 'None'
group by account_id,k_symbol,bank,account,[type],operation
having sum(amount)<> sum(balance) and sum(balance)<sum(amount)

--- where amount and balance are not same 
select avg(balanced) as average_balanced , k_symbol,[type] from(
select account_id,sum(amount) as amounts , sum(balance) as balance,
sum(balance) - sum(amount) as balanced,k_symbol,[type]
from trans 
group by account_id,k_symbol,[type]
having sum(amount) <>sum(balance)) as a
group by k_symbol,[type]


---- the reason behind k_symbol is none??
;with transactions_summary as(
select trans_id,k_symbol,[type],operation,sum(amount) as amount ,frequency,month(trans.[date]) as months,
year(trans.[date]) as years ,
sum(balance) as balance from trans 
left join account
on trans.account_id = account.account_id
group by trans_id,k_symbol,[type],operation,frequency,year(trans.[date]),month(trans.[date])
having sum(amount)  <>sum(balance) ),

trans_types as(
select count(trans_id) as transaction_counts,[type],sum(amount) as Total_amount_trans
,months,years,k_symbol,operation,frequency
from transactions_summary
group by [type],months,years,k_symbol,operation,frequency
--order by years,months desc
)

---withdrwal_type_summary as(
select avg(Total_amount_trans) as avg_amts ,avg(transaction_counts)
as avg_trans_counts ,operation,frequency,k_symbol
from trans_types
where [type] = 'Expense' and k_symbol = 'None'
group by [type]
,operation,frequency,k_symbol

--)


--- how many account with no transactions
select * from trans ------------------- There are all accounts having some transactions
right join account
on trans.account_id = account.account_id
where trans.account_id is null

---- Finding out where k_symbol are none what is there accounts behaviour
select count(trans_id)as trans_counts,[type],operation,count(distinct account.account_id)as account_ids from trans
left join account
on trans.account_id = account.account_id
where k_symbol = 'None'
group by [type],operation 

--- where type is expense and k_symbol is zero 
select count(trans_id)as trans_counts,operation
,count(distinct account.account_id)as account_ids from trans
left join account
on trans.account_id = account.account_id
where k_symbol = 'None' and [type] = 'Expense'
group by [type],operation 

--- where type is expense and k_symbol is not zero 
select count(trans_id)as trans_counts,operation
,count(distinct account.account_id)as account_ids from trans
left join account
on trans.account_id = account.account_id
where [type] = 'Expense'
group by [type],operation 

--- type of income 
select count(trans_id)as trans_counts,operation
,count(distinct account.account_id)as account_ids from trans
left join account
on trans.account_id = account.account_id
where [type] = 'Income'
group by [type],operation 

---- finding out why the operations are none in income type ??
select count(trans_id)as trans_counts,operation,k_symbol
,count(distinct account.account_id)as account_ids from trans
left join account
on trans.account_id = account.account_id
where [type] = 'Income' and operation = 'None'
group by [type],operation,k_symbol

--- transaction counts,account_ids count based on k_symbol -- type - income
select count(trans_id)as trans_counts,k_symbol
,count(distinct account.account_id)as account_ids from trans
left join account
on trans.account_id = account.account_id
where [type] = 'Income' 
---and k_symbol = 'None'
group by [type],k_symbol

--- transaction counts,account_ids count based on k_symbol -- type - withdrawal
select count(trans_id)as trans_counts,k_symbol,operation
,count(distinct account.account_id)as account_ids from trans
left join account
on trans.account_id = account.account_id
where [type] = 'Withdrawal' 
---and k_symbol = 'None'
group by [type],k_symbol,operation

select distinct [type] from trans

select * from customer_360
select top 5* from [order]

select count(distinct trans_id) from trans
where amount<> balance

select count(trans_id)*1.0/(select count(trans_id) from trans)as balanced_counts
,(select count(distinct trans_id) from trans
where amount<> balance)*1.0/(select count(trans_id) from trans) as imbalanced_trans_counts
from trans
where amount = balance

select * from account
where frequency = 'None'

--- transactions _counts based on months & year 
select month([date])as months,year([date]) as years
,count(trans_id)as transaction_counts,
[type],operation 
from trans
group by month([date]),year([date]),
[type],operation  
order by years,months,transaction_counts desc

---- transactions based on years 
select month([date])as months,year([date]) as years
,count(trans_id)as transaction_counts
from trans
group by month([date]),year([date])
order by years,months,transaction_counts desc

----- Percentage change in transaction month wise 

;with month_grps as(
select month([date])as months,count(trans_id) as transaction_counts from trans
---where year([date]) = 1998
group by month([date]))

select months,transaction_counts,lag(transaction_counts)over(order by months) as previous_trans_counts,
(transaction_counts - lag(transaction_counts)over(order by months))*100 / 
lag(transaction_counts)over(order by months) as percent_change
from month_grps


---- percentage change in accounts month wise 
select month([date]) as months ,count(account_id)as account_counts from account
group by  month([date])
order by account_counts


--- why there is drop in transactions_counts in certain months??
--- so analysing the orders table 

with grps as (
select trans.[date],order_id,trans.account_id from trans
left join account 
on trans.account_id = account.account_id
left join [order]
on account.account_id = [order].account_id),

order_by_months as(
select month(grps.[date]) as order_month,count(order_id) as order_counts from grps
group by month(grps.[date]))


--percent_change_month as(
select order_month,
lag(order_counts) over(partition by month(order_month) order by month(order_month)) as previous_month_orders,
((order_counts) - lag(order_counts) over(partition by month(order_month) order by month(order_month)))*100
/lag(order_counts) over(partition by month(order_month) order by month(order_month)) as percent_change
from order_by_months
--group by order_month
order by order_month

--- to analyze the drop in transactions
--- changes in Type

with month_wise_types as(
select month([date]) as months,count(trans_id) as transaction_counts,[Type] from trans
group by [Type],month([date]))

select months,transaction_counts,[type],lag(transaction_counts) over(partition by [type] order by months) as 
previous_type_month_counts,
(transaction_counts - lag(transaction_counts) over(partition by [type] order by months)) *100/
lag(transaction_counts) over(partition by [type] order by months) *100 as percent_change
from month_wise_types

--- to analyze the drop in transactions
--- changes in operation
;with month_wise_operation as(
select month([date]) as months,count(trans_id) as transaction_counts,operation from trans
group by operation,month([date]))

select months,transaction_counts,operation,lag(transaction_counts) over(partition by operation order by months) as 
previous_operations_month_counts,
(transaction_counts - lag(transaction_counts) over(partition by operation order by months)) *100/
lag(transaction_counts) over(partition by operation order by months) *100 as percent_change
from month_wise_operation

--- to analyze the drop in transactions
--- changes in k_symbols
;with month_wise_k_symbols as(
select month([date]) as months,count(trans_id) as transaction_counts,k_symbol from trans
group by k_symbol,month([date]))

select months,transaction_counts,k_symbol,lag(transaction_counts) over(partition by k_symbol order by months) as 
previous_k_symbols_month_counts,
(transaction_counts - lag(transaction_counts) over(partition by k_symbol order by months)) *100/
lag(transaction_counts) over(partition by k_symbol order by months) *100 as percent_change
from month_wise_k_symbols


--- why there is a drop in transaction in 1998 ?
-- basis of k_symbols 
;with month_wise_k_symbols as(
select month([date]) as months,count(trans_id) as transaction_counts,k_symbol from trans
where year([date]) = 1998
group by k_symbol,month([date]))

select months,transaction_counts,k_symbol,lag(transaction_counts) over(partition by k_symbol order by months) as 
previous_k_symbols_month_counts,
(transaction_counts - lag(transaction_counts) over(partition by k_symbol order by months)) *100/
lag(transaction_counts) over(partition by k_symbol order by months) *100 as percent_change
from month_wise_k_symbols

--- why there is a drop in transaction in 1998 ?
-- basis of operations
;with month_wise_operation as(
select month([date]) as months,count(trans_id) as transaction_counts,operation from trans
where year([date]) = 1998
group by operation,month([date]))

select months,transaction_counts,operation,lag(transaction_counts) over(partition by operation order by months) as 
previous_operations_month_counts,
(transaction_counts - lag(transaction_counts) over(partition by operation order by months)) *100/
lag(transaction_counts) over(partition by operation order by months) *100 as percent_change
from month_wise_operation



--- why there is a drop in transaction in 1998 ?
-- basis of Type-- expense
;with month_wise_operation as(
select month([date]) as months,count(trans_id) as transaction_counts,[Type] from trans
where year([date]) = 1998
group by [Type],month([date]))

select months,transaction_counts,[Type],lag(transaction_counts) over(partition by [Type] order by months) as 
previous_Type_month_counts,
(transaction_counts - lag(transaction_counts) over(partition by [Type] order by months)) *100/
lag(transaction_counts) over(partition by [Type] order by months) *100 as percent_change
from month_wise_operation

--- percent_change by year & Months
;with month_wise_operation as(
select month([date]) as months,year([date]) as years,
count(trans_id) as transaction_counts
--,[Type] 
from trans
---where year([date]) = 1998
group by [Type],month([date]),year([date]))

select months,transaction_counts,years,
lag(transaction_counts) over(partition by years,months order by months) as 
previous_Trans_year_month_counts,
(transaction_counts - lag(transaction_counts) over(partition by years,months order by months)) *100/
lag(transaction_counts) over(partition by years,months order by months) *100 as percent_change
from month_wise_operation


---- transaction_percentage based on age_grps and holder type??
select 
case when age>=11 and age<= 17 then ' Minor'
when age between 18 and 50 then 'Adult'
when age>50 then 'Senior' end 'Age_grp'
from customer_360

select * from client

;with last_date_of_trans as(
select max([date]) as last_date
from trans
),

clients_age as (
select Dob as dob,client_id
from client
),

holder_types_distribution as(
select trans_counts as trans_counts
,case when datediff(year,dob,last_date) between 11 and 17 then 
'Minor' 
when datediff(year,dob,last_date) between 18 and 50 then 'Adult'
when datediff(year,dob,last_date)>50 then 'Senior' end as 'Age_Grps',
holder_type
from(
select clients_age.dob as dob,
count(trans.trans_id) as trans_counts,disp.[type] as holder_type,(select max([date]) from trans) as last_date
from clients_age 
left join disp 
on clients_age.client_id = disp.client_id
left join account 
on disp.account_id = account.account_id
left join trans
on account.account_id = trans.account_id
group by disp.[type],clients_age.dob) 
as a 

)

select sum(trans_counts)*100/(select sum(trans_counts) from holder_types_distribution)as trans_percent
,Age_Grps,holder_type
from holder_types_distribution
group by Age_Grps,holder_type

------- Days btw opening account to issuing the card ??
select count(clients)as client_counts,
avg(days_btw) as avg_days_btw,card_type from(
select client.client_id as clients ,
card.[type] as card_type,card.issued,account.[date],datediff(day,[date],issued) as days_btw
from [card] 
left join disp 
on [card].disp_id = disp.disp_id
left join account
on disp.account_id = account.account_id
left join client
on disp.client_id = client.client_id) as a
group by card_type

---- how many customer opting for more than one card and for which they are going for??
--- client is not having more than one card 

select count(card.card_id) as card_counts
,[card].type
,client.client_id
from [card]
left join disp
on [card].disp_id = disp.disp_id
left join client
on disp.client_id = client.client_id
group by [card].type
,client.client_id
having count(card.card_id) >1

---- age grp opting for which card and which type of card 
select card_types,count(client_id) as clients_counts,Age_grp
from customer_360
group by card_types,Age_grp

---- Customers Transactions Based on days btw the transactions 

select * from client
select top 5 * from trans

---- segmenting_cutsomer based on duration and trans_counts ??
;with customer_active_trans_duration as(
select 
datediff(day,min(trans.[date]),max(trans.[date]))as trans_duration,count(trans.trans_id) as trans_count,
trans.account_id
from trans 
left join account
on trans.account_id = account.account_id
left join disp
on account.account_id = disp.account_id
left join client
on disp.client_id = client.client_id
group by trans.account_id)
,

Percentages as(
select account_id,round(sum(trans_duration)*100.0/(select sum(trans_duration) from customer_active_trans_duration),2) as trans_duration_percent
,round(sum(trans_count)*100.0/(select sum(trans_count) from customer_active_trans_duration),2) as trans_counts_percent
from customer_active_trans_duration
group by account_id

),

Activity_score as(
select account_id,trans_duration_percent,trans_counts_percent,
trans_duration_percent +trans_counts_percent as activity_scores from Percentages)

select sum(account_counts) as account_counts 
, Customer_Type from( select Account_counts, case when 
activity_scores between 0.12 and 0.15 then 'Premium' when 
activity_scores between 0.09 and 0.14 then 'High'
when activity_scores between 0.04 and 0.09 then 'Medium' 
when activity_scores <=0.04 then 'Low' end as 'Customer_Type'
from( select count(account_id) as Account_counts,account_id, sum(activity_scores) as activity_scores 
from Activity_score group by account_id ) as a ) as ab 
group by Customer_Type

----- updating clinets age in client_table??
alter table client 
add Age int;

update a
set a.age = ab.age
from client as a
left join( 
select client.client_id,datediff(Year,DOB,(select max([date]) from trans)) as Age,
case when datediff(Year,DOB,(select max([date]) from trans)) <18 then 'Minor'
when datediff(Year,DOB,(select max([date]) from trans)) between 18 and 50 then 'Adult'
when datediff(Year,DOB,(select max([date]) from trans))>50 then 'Senior'
end as ' Age_grps'
from client
left join disp
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
left join trans
on account.account_id = trans.account_id)as ab
on a.client_id = ab.client_id

---- updating age_grp column in client_table??
alter table client 
add Age_grps varchar(50);

update a
set a.Age_grps = ab.Age_grps
from client as a
left join( 
select client.client_id,datediff(Year,DOB,(select max([date]) from trans)) as Age,
case when datediff(Year,DOB,(select max([date]) from trans)) <18 then 'Minor'
when datediff(Year,DOB,(select max([date]) from trans)) between 18 and 50 then 'Adult'
when datediff(Year,DOB,(select max([date]) from trans))>50 then 'Senior'
end as 'Age_grps'
from client
left join disp
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
left join trans
on account.account_id = trans.account_id)as ab
on a.client_id = ab.client_id

----- Howm much percentage of people actually applying for loan and of which type

;with joining_tables as(
select client.client_id,loan_id,age_grps,duration from client
left join disp 
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
left join loan
on account.account_id = loan.account_id
where disp.[type] = 'owner')

select count(client_id)*100.0/(select count(client_id) from joining_tables) as percent_loan_taken,Age_grps,
case when duration between 12 and 24 then 'Short_Term_Loan'
when duration between 36 and 48 then 'Medium_Term_Loan'
else 'Loan_Term_Loan' end as 'Loan_Types'
from joining_tables 
where loan_id is not null
group by Age_grps,case when duration between 12 and 24 then 'Short_Term_Loan'
when duration between 36 and 48 then 'Medium_Term_Loan'
else 'Loan_Term_Loan' end

---- from which district most loan is taken 
select Top 5 District_Name,count(loan_id)as loans_taken from loan
left join account
on loan.account_id = account.account_id
left join district
on account.district_id = district.District_Ids
group by District_Name
order by loans_taken desc

---- why in those districts are having more loans 

with top_districts_loans as(
select District_Name,count(loan_id)as count_loan_taken,rank()over(order by count(loan_id) desc)
as ranks  from (
select District_Name,loan_id
from loan
left join account
on loan.account_id = account.account_id
left join district
on account.district_id = district.District_Ids) as a
group by District_Name),

Top_5_districts as(
select * from top_districts_loans
where ranks <=5)

select avg(avg_Salary) as avg_salary ,avg([population]) as avg_population,
avg(Ratio_Of_Urban_Populations) as avg_Ratio_Of_Urban_Populations,
(select avg(Avg_Salary) from district) as tot_avg_salary , (select avg([population]) from district
) as tot_avg_districts,
(select avg(Ratio_Of_Urban_Populations) from district) as tot_avg_Ratio_Of_Urban_Populations
from district
right join Top_5_districts
on district.District_Name = Top_5_districts.District_Name

---- Which age_grp is of which status are more 
select [status],count(loan_id) as loan_taken,Age_grps from client
left join disp
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
left join loan
on account.account_id = loan.account_id
where loan_id is not null and disp.[type] = 'owner'
group by [status],Age_grps


---- Accounts distribution based on Type & Age_Grps 
select round(count(account.account_id)*100.0 /(select count(account_id) from account),2)as account_counts
,[type],Age_grps
from client
left join disp
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
group by [type],Age_grps

---- count of transactions based on transaction_type??
select count(trans_id)as type_counts ,[type] from trans
group by [type]
order by type_counts desc

---- Count of operations on the basis of operations ??
select count(*)as operation_counts ,operation from trans
group by operation
order by operation_counts desc

--- Count of transaction operation types in case of type = 'Expense'
select count(trans_id)as type_counts ,[type],operation from trans
where [type] = 'Expense'
group by [type],operation
order by type_counts desc

--- Gender by Transaction counts ??
select gender,count(trans.trans_id)as trans_counts from client
left join disp 
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
left join trans
on account.district_id = trans.account_id
group by gender


select count(*),gender from client
group by gender


---- Operation by client_counts ??
select operation,count(client.client_id) as customers_count from client 
left join disp 
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
left join trans
on account.account_id = trans.account_id
group by operation

---- to find new / repeat cust 

;with summarized_tab as (
select client.client_id,birth_number,trans.[date] as trans_date,month(trans.[date]) as months from client
left join disp
on client.client_id = disp.client_id
left join account
on disp.account_id = account.account_id
left join trans
on account.account_id = trans.account_id
),

min_date_trans as(
select client_id,min(trans_date) as minimum_trans_date from summarized_tab
group by client_id)

select client_id,
case when trans_date == (select 
from summarized_tab

select * from client
select * from account
select * from disp

select account_id,count(client_id) from disp 
group by account_id
having count(client_id)>1

select top 5 * from trans
