/*
========================================================
stored procedure: Load Silver Layer Bronze -> Silver
========================================================
purpose:
    This stored procedure loads data into the silver schema
    from the bronze schema. It performs the following:
    - Truncates the silver tables before inserting data
    - Inserts transformed and cleaned data from bronze tables
    - Prints load duration for each table and the total batch

usage Example:
    EXEC silver.load_silver;
========================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;

SET @batch_start_time = GETDATE();

-- ================================================================
-- LOADING CRM TABLES
-- ================================================================

-- ----------------------------------------------------------------
-- INSERTING from bronze.crm_cust_info to silver.crm_cust_info
-- ----------------------------------------------------------------
SET @start_time = GETDATE();
print '>> loading silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
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
SET @end_time = GETDATE();
print '>> load duration: ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' seconds';
print '>> -------------';


-- ----------------------------------------------------------------
-- INSERTING from bronze.crm_prd_info to silver.crm_prd_info
-- ----------------------------------------------------------------
SET @start_time = GETDATE();
print '>> loading silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;
insert into silver.crm_prd_info
(
 prd_id ,
 cat_id ,
 prd_key ,
 prd_nm ,
 prd_cost ,
 prd_line ,
 prd_start_dt ,
 prd_end_dt 
 )
			select 
			prd_id,
			trim (replace(SUBSTRING(prd_key , 1 , 5) ,'-' , '_')) as cat_id,-- FOR ID from bronze.erp_PX_CAT_G1V2
			trim(SUBSTRING(prd_key , 7 , LEN (prd_key))) as prd_key,--FOR sls_prd_key from bronze.crm_sales_details
			prd_nm,

			COALESCE(prd_cost, 0) AS prd_cost,

			CASE 
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales' 
			WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain' 
			WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road' 
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring' 
			ELSE 'Unknown'
			end as prd_line  ,


			prd_start_dt,
			dateadd (day , -1 ,LEAD (prd_start_dt,1,null) over (partition by prd_key order by prd_start_dt) ) as prd_end_dt

			from bronze.crm_prd_info
SET @end_time = GETDATE();
print '>> load duration: ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' seconds';
print '>> -------------';


-- ----------------------------------------------------------------
-- INSERTING from bronze.crm_sales_details to silver.crm_sales_details
-- ----------------------------------------------------------------
SET @start_time = GETDATE();
print '>> loading silver.crm_sales_details';
TRUNCATE TABLE silver.crm_sales_details;
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
SET @end_time = GETDATE();
print '>> load duration: ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' seconds';
print '>> -------------';


-- ================================================================
-- LOADING ERP TABLES
-- ================================================================

-- ----------------------------------------------------------------
-- INSERTING from bronze.erp_CUST_AZ12 to silver.erp_CUST_AZ12
-- ----------------------------------------------------------------
SET @start_time = GETDATE();
print '>> loading silver.erp_CUST_AZ12';
TRUNCATE TABLE silver.erp_CUST_AZ12;
insert into silver.erp_CUST_AZ12(
CID,
BDATE,
GEN
)

select
CASE 
WHEN CID like 'NAS%' THEN REPLACE(CID , 'NAS' , '')
ELSE CID 
END AS CID,

 

 case 
 when BDATE > GETDATE() then NULL
 ELSE BDATE 
 END AS BDATE,

CASE 
WHEN UPPER(TRIM(GEN)) ='F' THEN 'Female'
WHEN UPPER(TRIM(GEN)) ='M' THEN 'Male'
WHEN UPPER(TRIM(GEN)) ='FEMALE' THEN 'Female'
WHEN UPPER(TRIM(GEN)) ='MALE' THEN 'Male'
else 'Unknown'
end as GEN

from bronze.erp_CUST_AZ12
SET @end_time = GETDATE();
print '>> load duration: ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' seconds';
print '>> -------------';


-- ----------------------------------------------------------------
-- INSERTING from bronze.erp_LOC_A101 to silver.erp_LOC_A101
-- ----------------------------------------------------------------
SET @start_time = GETDATE();
print '>> loading silver.erp_LOC_A101';
TRUNCATE TABLE silver.erp_LOC_A101;
insert into silver.erp_LOC_A101 (CID ,CNTRY )
select 


replace(cid , '-' , '') as cid,


CASE 
WHEN UPPER(TRIM(CNTRY)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
WHEN UPPER(TRIM(CNTRY)) IN ('DE', 'GERMANY') THEN 'Germany'
WHEN UPPER(TRIM(CNTRY)) = 'AUSTRALIA' THEN 'Australia'
WHEN UPPER(TRIM(CNTRY)) = 'UNITED KINGDOM' THEN 'United Kingdom'
WHEN UPPER(TRIM(CNTRY)) = 'CANADA' THEN 'Canada'
WHEN UPPER(TRIM(CNTRY)) = 'FRANCE' THEN 'France'
WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'Unknown'
ELSE CNTRY
END AS CNTRY

from bronze.erp_LOC_A101
SET @end_time = GETDATE();
print '>> load duration: ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' seconds';
print '>> -------------';


-- ----------------------------------------------------------------
-- INSERTING from bronze.erp_PX_CAT_G1V2 to silver.erp_PX_CAT_G1V2
-- ----------------------------------------------------------------
SET @start_time = GETDATE();
print '>> loading silver.erp_PX_CAT_G1V2';
TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
INSERT INTO silver.erp_PX_CAT_G1V2 
SELECT 
*
FROM bronze.erp_PX_CAT_G1V2
SET @end_time = GETDATE();
print '>> load duration: ' + CAST(DATEDIFF(second , @start_time , @end_time) AS NVARCHAR) + ' seconds';
print '>> -------------';


SET @batch_end_time = GETDATE();
print '>> ================================================';
print '>> total load duration: ' + CAST(DATEDIFF(second , @batch_start_time , @batch_end_time) AS NVARCHAR) + ' seconds';
print '>> ================================================';

END
