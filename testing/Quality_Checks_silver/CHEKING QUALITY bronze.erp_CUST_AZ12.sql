use datawareH
--CHEKING QUALITY OF THE TABLE bronze.erp_CUST_AZ12

select 
*
from bronze.erp_CUST_AZ12


select 
CID
from bronze.erp_CUST_AZ12
--REMOVING NAS 

select 
CASE 
WHEN CID like 'NAS%' THEN REPLACE(CID , 'NAS' , '')
ELSE CID 
END AS CID
from bronze.erp_CUST_AZ12




--CKEING WITH crm_cust_info


SELECT 
*
FROM bronze.crm_cust_info
WHERE cst_key NOT IN (
select 
CASE 
WHEN CID like 'NAS%' THEN REPLACE(CID , 'NAS' , '')
ELSE CID 
END AS CID
from bronze.erp_CUST_AZ12


)
--RESAULT :
/*
cst_key
13451235
AW00029483
AW00029483
PO25
SF566
----------
cst_id
NULL
29483
29483
NULL
NULL

*/
-- the other way araound
select 
CASE 
WHEN CID like 'NAS%' THEN REPLACE(CID , 'NAS' , '')
ELSE CID 
END 
from bronze.erp_CUST_AZ12
where case WHEN CID like 'NAS%' THEN REPLACE(CID , 'NAS' , '')
ELSE CID END NOT IN ( 
select distinct cst_key from silver.crm_cust_info

)

--nthng = good 




 
 --checking the bdate 

 select 

 BDATE
 from bronze.erp_CUST_AZ12


 select 

 BDATE
 from bronze.erp_CUST_AZ12
 where BDATE > GETDATE()
 -- it has 16 result


 --or

 select 

 BDATE
 from bronze.erp_CUST_AZ12
 where BDATE <'1899-12-31'

 --no result


 --solving the fst plrom BDATE > GETDATE()


  select 

 case 
 when BDATE > GETDATE() then NULL
 ELSE BDATE 
 END AS BDATE
 from bronze.erp_CUST_AZ12
 where BDATE > GETDATE()



 -- CHECKING GEN 

 SELECT DISTINCT 

GEN
FROM bronze.erp_CUST_AZ12
/* 
RESULT :
GEN
NULL
F 
  
Male
Female
M 
*/


--SOLVING IT:

SELECT DISTINCT
GEN,
CASE 
WHEN UPPER(TRIM(GEN)) ='F' THEN 'Female'
WHEN UPPER(TRIM(GEN)) ='M' THEN 'Male'
WHEN UPPER(TRIM(GEN)) ='FEMALE' THEN 'Female'
WHEN UPPER(TRIM(GEN)) ='MALE' THEN 'Male'
else 'Unknown'
end as GEN

FROM bronze.erp_CUST_AZ12