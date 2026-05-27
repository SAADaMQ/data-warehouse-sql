/*
========================================================
EDA - Exploratory Data Analysis
========================================================
Purpose:
    Explore the gold layer dim_Customers, dim_Products, fact_sales
    to understand the data structure, dimensions, dates, and measures.
========================================================
*/


-- ================================================================
-- database exploration
-- ================================================================

-- explore all schemas in the database
select * from information_schema.schemata

-- explore all tables in the database
select * from information_schema.tables

-- explore all columns in the database
select * from information_schema.columns


-- ================================================================
-- dimension exploration: gold.dim_Customers
-- ================================================================

-- preview customer dimension
select * from gold.dim_Customers

-- explore unique genders
select distinct Gender 
from gold.dim_Customers

-- explore unique countries
select distinct Country 
from gold.dim_Customers

-- explore unique marital statuses
select distinct MaritalStatus 
from gold.dim_Customers


-- ================================================================
-- dimension exploration: gold.dim_Products
-- ================================================================

-- preview product dimension
select * from gold.dim_Products

-- explore unique subcategories
select distinct Subcategory 
from gold.dim_Products

-- explore unique categories
select distinct CategoryName 
from gold.dim_Products

-- explore categories with their subcategories
select distinct 
CategoryName,
Subcategory
from gold.dim_Products

-- explore unique product lines
select distinct Line 
from gold.dim_Products

-- explore unique maintenance values
select distinct Maintenance 
from gold.dim_Products


-- ================================================================
-- date exploration
-- ================================================================

-- find the oldest and youngest customers by birth date
select 
min(BirthDate) as Oldest_Customer_BirthDate,
max(BirthDate) as Youngest_Customer_BirthDate,
abs(datediff(year, min(BirthDate), max(BirthDate))) as Years_Difference
from gold.dim_Customers

-- find the youngest and oldest customer age
select 
min(Age) as Youngest_Customer_Age,
max(Age) as Oldest_Customer_Age,
abs(max(Age) - min(Age)) as Age_Difference
from gold.dim_Customers

-- find the average shipping duration in days
select 
avg(datediff(day, OrderDate, ShipDate)) as Avg_Shipping_Days
from gold.fact_sales

-- find the first and last order dates
select 
min(OrderDate) as First_Order_Date,
max(OrderDate) as Last_Order_Date,
datediff(year, min(OrderDate), max(OrderDate)) as Order_Range_Years
from gold.fact_sales


-- ================================================================
-- measures exploration individual
-- ================================================================

-- preview fact table
select * from gold.fact_sales

-- total sales amount
select sum(SalesAmount) as Total_Sales
from gold.fact_sales

-- total quantity of items sold
select sum(Quantity) as Total_Quantity
from gold.fact_sales

-- average selling price
select round(avg(Price),2) as Avg_Price
from gold.fact_sales

-- total number of orders
select count(OrderNumber) as Total_Orders
from gold.fact_sales

-- total number of unique orders no duplicates
select count(distinct OrderNumber) as Total_Unique_Orders
from gold.fact_sales

-- total number of products
select count(ProductKey) as Total_Products
from gold.dim_Products

-- total number of customers
select count(ID) as Total_Customers
from gold.dim_Customers

-- total number of customers who placed at least one order
select count(distinct CustomerKey) as Total_Customers_With_Orders
from gold.fact_sales


-- ================================================================
-- measures exploration combined report
-- ================================================================

-- generate one report that shows all key business metrics
select 'Total Sales' as Measure_Name, sum(SalesAmount) as Measure_Value from gold.fact_sales
union all
select 'Total Quantity' as Measure_Name, sum(Quantity) as Measure_Value from gold.fact_sales
union all
select 'Average Price' as Measure_Name, avg(Price) as Measure_Value from gold.fact_sales
union all
select 'Total Orders' as Measure_Name, count(distinct OrderNumber) as Measure_Value from gold.fact_sales
union all
select 'Total Products' as Measure_Name, count(ProductKey) as Measure_Value from gold.dim_Products
union all
select 'Total Customers' as Measure_Name, count(ID) as Measure_Value from gold.dim_Customers
union all
select 'Total Customers With Orders' as Measure_Name, count(distinct CustomerKey) as Measure_Value from gold.fact_sales


-- ================================================================
-- magnitude analysis
-- ================================================================

-- total customers by country
select 
Country,
count(*) as Total_Customers
from gold.dim_Customers
group by Country

-- total products by category
select 
CategoryName,
count(*) as Total_Products
from gold.dim_Products
group by CategoryName

-- average product cost by category
select 
CategoryName,
round(avg(Cost), 2) as Avg_Cost
from gold.dim_Products
where CategoryName is not null
group by CategoryName

-- total revenue by category
select 
pro.CategoryName,
sum(sls.SalesAmount) as Total_Revenue
from gold.fact_sales sls 
join gold.dim_Products pro
on sls.ProductKey = pro.ProductKey
group by pro.CategoryName

-- total customers by country sorted from highest to lowest
select 
Country,
count(*) as Total_Customers
from gold.dim_Customers
group by Country
order by count(*) desc

-- total revenue per customer sorted from highest to lowest
select 
cus.Customer_Key,
cus.FirstName + ' ' + cus.LastName as Customer_Name,
cus.Country,
sum(sls.SalesAmount) as Total_Revenue
from gold.fact_sales sls 
join gold.dim_Customers cus
on sls.CustomerKey = cus.Customer_Key
group by cus.Customer_Key, cus.FirstName, cus.LastName, cus.Country
order by Total_Revenue desc


-- ================================================================
-- ranking analysis
-- ================================================================

-- top 5 products by total revenue using dense_rank in a subquery
select *
from (
select 
pro.ProductName,
sum(sls.SalesAmount) as Total_Revenue,
dense_rank() over (order by sum(sls.SalesAmount) desc) as Product_Rank
from gold.dim_Products pro 
join gold.fact_sales sls
on pro.ProductKey = sls.ProductKey
group by pro.ProductName
) t
where Product_Rank <= 5

-- bottom 5 products by total revenue using row_number
select top 5
pro.ProductName,
sum(sls.SalesAmount) as Total_Revenue,
row_number() over (order by sum(sls.SalesAmount) asc) as Product_Rank
from gold.fact_sales sls 
join gold.dim_Products pro 
on sls.ProductKey = pro.ProductKey
group by pro.ProductName


-- top 5 countries by number of customers
select top 5
cus.Country,
count(distinct cus.Customer_Key) as Total_Customers
from gold.fact_sales sls 
join gold.dim_Customers cus 
on sls.CustomerKey = cus.Customer_Key
group by cus.Country
order by Total_Customers desc

-- top 5 countries by number of orders
select top 5
cus.Country,
count(distinct sls.OrderNumber) as Total_Orders
from gold.fact_sales sls 
join gold.dim_Customers cus 
on sls.CustomerKey = cus.Customer_Key
group by cus.Country
order by Total_Orders desc



















