use DataWareH
go 

-- crm_cust_info is the master tablre for customer info 

select * from silver.erp_CUST_AZ12 --cid = cst_key
select *from silver.erp_LOC_A101-- cid = cst_key

select distinct erpcust.GEN , cust.cst_gndr from silver.erp_CUST_AZ12 erpCUST 
left join silver.crm_cust_info AS cust  
on cust.cst_key = erpCUST.CID



-- we take gen from silver.erp_CUST_AZ12  only if crm_cust_info is null and erp cust has a value

select distinct cust.cst_gndr ,erpcust.GEN   from silver.crm_cust_info AS cust 
left join silver.erp_CUST_AZ12 as erpCUST  
on cust.cst_key = erpCUST.CID


select distinct 
case 
when cust.cst_gndr ='Unknown' and erpcust.GEN != 'Unknown' and erpcust.GEN  is not null then erpcust.GEN
else cust.cst_gndr 
end as Customer_Gender , 

cust.cst_gndr ,

erpcust.GEN   

from silver.crm_cust_info AS cust 
left join silver.erp_CUST_AZ12 as erpCUST  
on cust.cst_key = erpCUST.CID

-- final select
--dim V table gold.dim_Customers
go
drop view gold.dim_Customers 
go
create view gold.dim_Customers AS 
SELECT 
    ROW_NUMBER () over (order by cust.cst_id   ) as Customer_Key,
    cust.cst_id   AS ID,
    cust.cst_key  AS Number,
    cust.cst_firstname  AS FirstName,
    cust.cst_lastname   AS LastName,
    
    
    
    CASE 
        WHEN cust.cst_gndr = 'Unknown' AND erpcust.GEN != 'Unknown' AND erpcust.GEN IS NOT NULL 
            THEN erpcust.GEN
        ELSE cust.cst_gndr
    END  AS Gender,
cust.cst_marital_status AS MaritalStatus,
    loc.CNTRY     AS Country,

    Age= DATEDIFF(day , erpcust.BDATE , GETDATE()) /365,
    erpcust.BDATE AS BirthDate,


    


    cust.cst_create_date AS CreateDate
    
    
FROM silver.crm_cust_info as cust
left join silver.erp_CUST_AZ12 AS erpCUST  
on cust.cst_key = erpCUST.CID

LEFT JOIN silver.erp_LOC_A101 as loc
on cust.cst_key = loc.CID

























































