--CHEKING QUALITY OF THE TABLE bronze.crm_cust_info


--checking nulls ON PK 
select 
COUNT (*),
cst_id
from bronze.crm_cust_info
group by cst_id
having COUNT (*) > 1

select 
*
from bronze.crm_cust_info
where cst_id in (29466 , 29483 , 29433 ,29473,29449)


--cheking space in strs ! 

select * from bronze.crm_cust_info


select
cst_key
from bronze.crm_cust_info
where cst_key != trim( cst_key ) 

--EXIST !
select
cst_firstname
from bronze.crm_cust_info
where cst_firstname != trim( cst_firstname ) 


--EXIST !
select
cst_lastname
from bronze.crm_cust_info
where cst_lastname != trim( cst_lastname ) 




select
cst_marital_status
from bronze.crm_cust_info
where cst_marital_status!= trim( cst_marital_status ) 



select
cst_gndr
from bronze.crm_cust_info
where cst_gndr!= trim( cst_gndr ) 



--cheking the uniq values 

select distinct
cst_gndr
from bronze.crm_cust_info


select distinct
cst_marital_status
from bronze.crm_cust_info