/*
========================================================
Advanced Data Analytics 
========================================================
Purpose:
    This script applies advanced analytics techniques on the gold layer
    to extract business insights from the data warehouse.

Topics covered:
    1. Change Over Time Analysis
    2. Cumulative Analysis
    3. Performance Analysis
    4. Part-to-Whole Analysis
    5. Data Segmentation
    6. Customer Report View
========================================================
*/

use DataWareH


-- ================================================================
-- change over time analysis
-- ================================================================

-- total sales per year
select 
year(OrderDate) as Order_Year,
sum(SalesAmount) as Total_Sales
from gold.fact_sales
where year(OrderDate) is not null 
group by year(OrderDate) 
order by Total_Sales desc

-- total sales per month
select 
month(OrderDate) as Order_Month,
sum(SalesAmount) as Total_Sales
from gold.fact_sales
where month(OrderDate) is not null 
group by month(OrderDate) 
order by Total_Sales desc

-- the day with the highest sales in each month
select *
from (
    select 
    month(OrderDate) as Order_Month,
    day(OrderDate) as Order_Day,
    sum(SalesAmount) as Total_Sales,
    dense_rank() over (partition by month(OrderDate) order by sum(SalesAmount) desc) as Day_Rank
    from gold.fact_sales
    where OrderDate is not null
    group by month(OrderDate), day(OrderDate)
    )t
where Day_Rank = 1
order by Order_Month

-- monthly performance: total sales, customers, and quantity
select
year(OrderDate) as Order_Year,
month(OrderDate) as Order_Month,
sum(SalesAmount) as Total_Sales,
count(distinct CustomerKey) as Total_Customers,
sum(Quantity) as Total_Quantity
from gold.fact_sales
where OrderDate is not null
group by year(OrderDate), month(OrderDate)
order by year(OrderDate), month(OrderDate)


-- ================================================================
-- cumulative analysis
-- ================================================================

-- cumulative monthly sales over time
select 
Order_Year,
Order_Month,
Monthly_Sales,
sum(Monthly_Sales) over (order by Order_Year, Order_Month) as Running_Total_Sales
from (
    select 
    year(OrderDate) as Order_Year,
    month(OrderDate) as Order_Month,
    sum(SalesAmount) as Monthly_Sales
    from gold.fact_sales
    where year(OrderDate) is not null
    group by year(OrderDate), month(OrderDate)
    )t


-- ================================================================
-- performance analysis
-- ================================================================

-- analyze yearly product performance compared to its average sales
;with yearly_product_sales as (
    select 
    year(sls.OrderDate) as Order_Year,
    pro.ProductName,
    sum(sls.SalesAmount) as Total_Sales
    from gold.dim_Products pro 
    inner join gold.fact_sales sls
    on pro.ProductKey = sls.ProductKey
    where year(sls.OrderDate) is not null
    group by year(sls.OrderDate), pro.ProductName
    )
select 
Order_Year,
ProductName,
Total_Sales,
avg(Total_Sales) over (partition by ProductName) as Avg_Sales,
Total_Sales - avg(Total_Sales) over (partition by ProductName) as Diff_From_Avg,
case 
    when Total_Sales - avg(Total_Sales) over (partition by ProductName) > 0 then 'Above Avg'
    when Total_Sales - avg(Total_Sales) over (partition by ProductName) < 0 then 'Below Avg'
    else 'Avg'
end as Performance_Change
from yearly_product_sales
order by ProductName, Order_Year


-- ================================================================
-- part-to-whole analysis
-- ================================================================

-- which categories contribute the most to overall sales
select 
CategoryName,
Total_Sales,
sum(Total_Sales) over () as Overall_Sales,
cast(round(Total_Sales / sum(Total_Sales) over () * 100, 2) as varchar) + '%' as Sales_Percentage
from (
    select 
    pro.CategoryName as CategoryName,
    sum(sls.SalesAmount) as Total_Sales 
    from gold.dim_Products pro 
    join gold.fact_sales sls
    on pro.ProductKey = sls.ProductKey
    group by pro.CategoryName
    )t
order by Total_Sales desc


-- ================================================================
-- data segmentation
-- ================================================================

-- segment products into cost ranges and count how many products fall into each segment
select 
cost_range,
count(product_key) as Total_Products
from (
    select 
    ProductKey as product_key,
    ProductName as product_name,
    Cost as cost,
    case 
        when Cost < 100 then 'Below 100'
        when Cost between 100 and 500 then '100-500'
        when Cost between 500 and 1000 then '500-1000'
        else 'Above 1000'
    end as cost_range
    from gold.dim_Products
    )t
group by cost_range
order by Total_Products desc

-- group customers into three segments based on their spending behavior
-- VIP: at least 12 months of history and spending more than 5000
-- Regular: at least 12 months of history but spending 5000 or less
-- New: lifespan less than 12 months
with customer_spending as (
    select 
    cus.Customer_Key as customer_key,
    sum(sls.SalesAmount) as total_spending,
    min(sls.OrderDate) as first_order,
    max(sls.OrderDate) as last_order,
    datediff(month, min(sls.OrderDate), max(sls.OrderDate)) as lifespan
    from gold.fact_sales sls 
    left join gold.dim_Customers cus
    on sls.CustomerKey = cus.Customer_Key
    group by cus.Customer_Key
    )
select 
customer_segment,
count(customer_key) as Total_Customers
from (
    select 
    customer_key,
    total_spending,
    lifespan,
    case 
        when lifespan >= 12 and total_spending > 5000 then 'VIP'
        when lifespan >= 12 and total_spending <= 5000 then 'Regular'
        else 'New'
    end as customer_segment
    from customer_spending
    )t
group by customer_segment
order by Total_Customers desc


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









