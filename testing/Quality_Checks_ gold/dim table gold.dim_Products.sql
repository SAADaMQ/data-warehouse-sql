

--dim table gold.dim_Products

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