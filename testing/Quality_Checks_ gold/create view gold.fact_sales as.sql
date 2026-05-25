
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

