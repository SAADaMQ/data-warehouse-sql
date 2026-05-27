/*
========================================================
DDL Script: Create Gold Views Silver -> Gold
========================================================
script purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables 
    Star Schema built from the cleaned and integrated Silver layer.

    Each view performs transformations and combines data from the 
    Silver layer to produce a business-ready dataset.

Usage:
    These views can be queried directly for analytics and reporting.
========================================================
*/

-- ================================================================
-- CREATE DIMENSION VIEWS
-- ================================================================

-- ----------------------------------------------------------------
-- Create Dimension: gold.dim_Customers
-- ----------------------------------------------------------------
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

GO
-- ----------------------------------------------------------------
-- Create Dimension: gold.dim_Products
-- ----------------------------------------------------------------
create view gold.dim_Products as 
SELECT 
    ROW_NUMBER() over (order by prd_info.prd_id) as ProductKey,
    prd_info.prd_id        AS ProductID,
    prd_info.cat_id        AS CategoryID,
    prd_info.prd_key       AS [ProductNumber],

    px.CAT                 AS CategoryName,
    px.SUBCAT              AS Subcategory,

    prd_info.prd_nm        AS [ProductName],
    prd_info.prd_line      AS Line,
    prd_info.prd_cost      AS Cost,
    

    px.MAINTENANCE         AS Maintenance,


    prd_info.prd_start_dt  AS StartDate,
    prd_info.prd_end_dt    AS EndDate




 



FROM silver.crm_prd_info AS prd_info

LEFT JOIN silver.erp_PX_CAT_G1V2 AS px 
    ON prd_info.cat_id = px.ID


WHERE prd_end_dt IS NULL  -- current data

GO
-- ================================================================
-- CREATE FACT VIEWS
-- ================================================================

-- ----------------------------------------------------------------
-- Create Fact: gold.fact_sales
-- ----------------------------------------------------------------
create view gold.fact_sales as

SELECT 
    sls.sls_ord_num as OrderNumber, 


    pro.ProductKey   as ProductKey, 
    cus.Customer_Key as CustomerKey, 


    sls.sls_order_dt as OrderDate, 
    sls.sls_ship_dt as ShipDate, 
    sls.sls_due_dt as DueDate, 
    sls.sls_sales AS SalesAmount, 
    sls.sls_quantity as Quantity, 
    sls.sls_price AS Price


from silver.crm_sales_details sls 
left JOIN gold.dim_Customers cus 
    on sls.sls_cust_id = cus.ID 
left join gold.dim_Products pro 
    on sls.sls_prd_key = pro.ProductNumber;
GO