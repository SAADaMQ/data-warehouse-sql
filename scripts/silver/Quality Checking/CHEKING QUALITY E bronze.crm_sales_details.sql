--CHEKING QUALITY OF THE TABLE bronze.crm_sales_details

--sls_order_dt
select sls_order_dt,
nullif(sls_order_dt ,0)
from bronze.crm_sales_details
where sls_order_dt <=0

select
sls_order_dt
from bronze.crm_sales_details
where 8 != len(sls_order_dt)



--sls_ship_dt
select sls_ship_dt,
nullif(sls_ship_dt ,0)
from bronze.crm_sales_details
where sls_ship_dt <=0



select
sls_ship_dt

from bronze.crm_sales_details
where 8 != len(sls_ship_dt)



--sls_due_dt
select sls_due_dt,
nullif(sls_due_dt ,0)
from bronze.crm_sales_details
where sls_due_dt <=0

select
sls_due_dt

from bronze.crm_sales_details
where 8 != len(sls_due_dt) 




-- business checks


SELECT 

sls_price,
sls_sales,
sls_quantity,

case
when sls_price <0 then sls_price*-1.0
when sls_price IS null or sls_price = 0 then sls_sales/nullif (sls_quantity , 0)
else sls_price 
end as sls_price,

case 
when sls_sales <=0 or  sls_sales IS null or sls_sales !=sls_quantity* abs(sls_price)
then sls_quantity*abs(sls_price)
else sls_sales
end as sls_sales





FROM bronze.crm_sales_details
WHERE sls_sales!= sls_quantity*sls_price
or sls_sales is null 
or sls_price is null 
or sls_quantity is null
or sls_sales  <=0
or sls_price  <=0
or sls_quantity <=0
