-- INSERTING TO silver.crm_cust_info WITH SOLVING THE PROBLEMS OF CHEKING 
insert into silver.crm_cust_info (
 cst_id ,
 cst_key ,
 cst_firstname ,
 cst_lastname ,
 cst_marital_status ,
 cst_gndr  ,
 cst_create_date

)
select  
cst_id,
trim(cst_key),


trim(cst_firstname) as cst_firstname ,
trim(cst_lastname) as cst_lastname,

case 
when upper(trim(cst_marital_status)) = 'S' then 'Single'
when upper(trim(cst_marital_status)) = 'M' then 'Married'
ELSE 'Unknown'
end  as cst_marital_status,

case 
when upper(trim(cst_gndr)) = 'F' then 'Female'
when upper(trim(cst_gndr)) = 'M' then 'Male'
ELSE 'Unknown'
end  as cst_gndr ,
cst_create_date 

from (
		select 
		*,
		ROW_NUMBER() over (partition by cst_id  order by cst_create_date desc  ) flag
		from bronze.crm_cust_info
		)ct
where flag =1 