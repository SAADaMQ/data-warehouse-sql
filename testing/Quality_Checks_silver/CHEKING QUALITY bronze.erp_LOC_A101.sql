--CHEKING QUALITY OF THE TABLE bronze.erp_LOC_A101
select 

*

from bronze.erp_LOC_A101

select 
cid,
CNTRY
from bronze.erp_LOC_A101


select 
replace(cid , '-' , '') as cid
from bronze.erp_LOC_A101


--cheking : good 
select 
replace(cid , '-' , '')
from bronze.erp_LOC_A101
where replace(cid , '-' , '') not in 
(
select
cst_key
from silver.crm_cust_info
)


select distinct
CNTRY
from bronze.erp_LOC_A101


SELECT distinct
cntry,
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
FROM bronze.erp_LOC_A101



