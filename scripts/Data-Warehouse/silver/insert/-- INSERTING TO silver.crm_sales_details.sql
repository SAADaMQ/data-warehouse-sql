
-- INSERTING TO silver.crm_sales_details WITH SOLVING THE PROBLEMS OF CHEKING 

insert into silver.crm_sales_details(
sls_ord_num ,
 sls_prd_key ,
 sls_cust_id ,
 sls_order_dt ,
 sls_ship_dt ,
 sls_due_dt ,
 sls_sales ,
 sls_quantity ,
 sls_price 
 )
select

sls_ord_num ,
sls_prd_key ,
sls_cust_id ,
--ALL GOOD

--sls_order_dt
CASE 
    WHEN LEN(sls_order_dt) != 8 THEN NULL
    WHEN sls_order_dt = 0 THEN NULL
    ELSE CAST ( CAST( sls_order_dt AS VARCHAR) AS DATE ) 
END AS sls_order_dt,

--sls_ship_dt
CASE 
    WHEN LEN(sls_ship_dt) != 8 THEN NULL
    WHEN sls_ship_dt = 0 THEN NULL
    ELSE CAST ( CAST( sls_ship_dt AS VARCHAR) AS DATE ) 
END AS sls_ship_dt,

--sls_due_dt 
CASE 
    WHEN LEN(sls_due_dt) != 8 THEN NULL
    WHEN sls_due_dt = 0 THEN NULL
    ELSE CAST ( CAST( sls_due_dt AS VARCHAR) AS DATE ) 
END AS sls_due_dt,


--sls_sales 
case 
when sls_sales <=0 or  sls_sales IS null or sls_sales !=sls_quantity* abs(sls_price)
then sls_quantity*abs(sls_price)
else sls_sales
end as sls_sales,


sls_quantity ,

--sls_price 
case
when sls_price <0 then sls_price*-1.0
when sls_price IS null or sls_price = 0 then sls_sales/nullif (sls_quantity , 0)
else sls_price 
end as sls_price

from bronze.crm_sales_details