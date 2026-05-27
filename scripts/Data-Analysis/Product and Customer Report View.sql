-- ================================================================
-- customer report view
-- ================================================================

/*
Customer Report:

Purpose:
    This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details
    2. Segments customers into categories (VIP, Regular, New) and age groups
    3. Aggregates customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last order)
       - average order value
       - average monthly spend
========================================================
*/

go
drop view gold.report_Customers
go
create view gold.report_Customers as

with base_query as (
    --base query: retrieves core columns from tables
    select 
    sls.OrderNumber,
    sls.ProductKey,
    sls.OrderDate,
    sls.SalesAmount,
    sls.Quantity,
    cus.Customer_Key,
    cus.ID as Customer_Number,
    cus.FirstName + ' ' + cus.LastName as Customer_Name,
    cus.Age
    from gold.fact_sales sls
    left join gold.dim_Customers cus
    on sls.CustomerKey = cus.Customer_Key
    where sls.OrderDate is not null
    )
,
customer_aggregation as (
    --customer aggregations: summarizes key metrics at the customer level
    select 
    Customer_Key,
    Customer_Number,
    Customer_Name,
    Age,
    count(distinct OrderNumber) as Total_Orders,
    sum(SalesAmount) as Total_Sales,
    sum(Quantity) as Total_Quantity,
    count(distinct ProductKey) as Total_Products,
    max(OrderDate) as Last_Order_Date,
    datediff(month, min(OrderDate), max(OrderDate)) as Lifespan
    from base_query
    group by 
    Customer_Key,
    Customer_Number,
    Customer_Name,
    Age
    )
select 
Customer_Key,
Customer_Number,
Customer_Name,
Age,
case 
    when Age < 20 then 'Under 20'
    when Age between 20 and 29 then '20-29'
    when Age between 30 and 39 then '30-39'
    when Age between 40 and 49 then '40-49'
    else '50 and Above'
end as Age_Group,
case 
    when Lifespan >= 12 and Total_Sales > 5000 then 'VIP'
    when Lifespan >= 12 and Total_Sales <= 5000 then 'Regular'
    else 'New'
end as Customer_Segment,
Last_Order_Date,
datediff(month, Last_Order_Date, getdate()) as Recency,
Total_Orders,
Total_Sales,
Total_Quantity,
Total_Products,
Lifespan,
--compute average order value
case 
    when Total_Orders = 0 then 0
    else round(Total_Sales / Total_Orders, 2)
end as Avg_Order_Value,
--compute average monthly spend
case 
    when Lifespan = 0 then Total_Sales
    else round(Total_Sales / Lifespan, 2)
end as Avg_Monthly_Spend 
from customer_aggregation


-- ================================================================
-- query the customer report
-- ================================================================

select * from gold.report_Customers






/*
========================================================
Product Report
========================================================
Purpose:
    This report consolidates key product metrics and behaviors

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost
    2. Segments products by revenue performance (High-Performer, Mid-Range, Low-Performer)
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue
       - average monthly revenue
========================================================
*/

go
drop view gold.report_Products
go
create view gold.report_Products as

with base_query as (
    --base query: retrieves core columns from tables
    select 
    sls.OrderNumber,
    sls.OrderDate,
    sls.CustomerKey,
    sls.SalesAmount,
    sls.Quantity,
    pro.ProductKey,
    pro.ProductName,
    pro.CategoryName,
    pro.Subcategory,
    pro.Cost
    from gold.fact_sales sls
    left join gold.dim_Products pro
    on sls.ProductKey = pro.ProductKey
    where sls.OrderDate is not null
    )
,
product_aggregation as (
    --product aggregations: summarizes key metrics at the product level
    select 
    ProductKey,
    ProductName,
    CategoryName,
    Subcategory,
    Cost,
    count(distinct OrderNumber) as Total_Orders,
    sum(SalesAmount) as Total_Sales,
    sum(Quantity) as Total_Quantity,
    count(distinct CustomerKey) as Total_Customers,
    max(OrderDate) as Last_Sale_Date,
    datediff(month, min(OrderDate), max(OrderDate)) as Lifespan,
    round(avg(cast(SalesAmount as float) / nullif(Quantity, 0)), 1) as Avg_Selling_Price
    from base_query
    group by 
    ProductKey,
    ProductName,
    CategoryName,
    Subcategory,
    Cost
    )
select 
ProductKey,
ProductName,
CategoryName,
Subcategory,
Cost,
case 
    when Total_Sales > 50000 then 'High-Performer'
    when Total_Sales >= 10000 then 'Mid-Range'
    else 'Low-Performer'
end as Product_Segment,
Last_Sale_Date,
datediff(month, Last_Sale_Date, getdate()) as Recency,
Total_Orders,
Total_Sales,
Total_Quantity,
Total_Customers,
Lifespan,
Avg_Selling_Price,
--compute average order revenue
case 
    when Total_Orders = 0 then 0
    else round(Total_Sales / Total_Orders, 2)
end as Avg_Order_Revenue,
--compute average monthly revenue
case 
    when Lifespan = 0 then Total_Sales
    else round(Total_Sales / Lifespan, 2)
end as Avg_Monthly_Revenue
from product_aggregation


-- ================================================================
-- query the product report
-- ================================================================

select * from gold.report_Products

