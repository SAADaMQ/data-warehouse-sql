
-- INSERTING TO silver.erp_CUST_AZ12 WITH SOLVING THE PROBLEMS OF CHEKING 


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