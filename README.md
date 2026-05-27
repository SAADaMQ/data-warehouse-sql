# My Data Warehouse Project 

Welcome to my project! so this is a data warehouse I built from scratch. I think it is a great way to practice data engineering and ETL processes. 

first, I want to talk about the data architecture. I decided to use the Medallion Architecture because it makes sense to me to organize data in stages. 

* **Bronze Layer:** here, i just imported the raw data from CSV files directly into my SQL Server.
* **Silver Layer:** then, i cleaned the data. there was some errors and missing things, so I fixed them and standardized everything.
* **Gold Layer:** last, after cleaning, I created a star schema. I think this is the best way to get it ready for reporting and dashboards.

so what did I actually do in this project?

* I designed the whole DWH architecture.
* I built ETL pipelines to move and transform the data.
* I wrote SQL queries to get some cool insights from the data.

I used tools that are completely free, which is awesome:

* SQL Server Express and SSMS to manage the database.
* Git and GitHub for saving my scripts.


first the main goal was to take sales data from two different systems ERP and CRM. then I had to clean it and merge it into one clear model. I didn't do data historization because I think focusing on the latest data is enough for this scope.

## Data Architecture

The data architecture for this project follows the **Medallion Architecture** with three layers Bronze, Silver, and Gold built on SQL Server.

- **Bronze Layer:** Stores raw data as-is from the source systems (CRM and ERP). Data is ingested from CSV files into SQL Server tables with no transformations.
- **Silver Layer:** Applies data cleansing, standardization, normalization, and enrichment to prepare data for analysis.
- **Gold Layer:** Houses business-ready data modeled as a Star Schema with fact and dimension views, optimized for reporting and analytics.

<img width="2752" height="1536" alt="High Level Architecture" src="https://github.com/user-attachments/assets/244deb94-2725-40f0-a2d5-29734001a6b8" />


## Data Flow

The diagram below illustrates how data flows across the three layers from raw CSV files in the source systems all the way to the final star schema views in the Gold layer.

- **6 source tables** ingested from CRM and ERP systems
- **1-to-1 mapping** between Bronze and Silver tables with transformations applied
- **Integration** happens at the Gold layer where multiple Silver tables are combined into business entities

<img width="841" height="462" alt="image" src="https://github.com/user-attachments/assets/1b0ba2ad-c501-4a36-9978-ee63e71e79df" />


##  Data Model Star Schema

The Gold layer is modeled as a Star Schema to optimize analytical queries and reporting performance. The schema consists of one central fact table surrounded by dimension tables, enabling efficient aggregations and slicing across business dimensions.

### Schema Components

- gold.fact_sales is the central fact table containing sales transactions with measures such as sales amount, quantity, and price, along with foreign keys to dimensions.

- gold.dim_customers is the customer dimension integrating data from CRM and ERP sources including name, gender, country, age, and marital status.

- gold.dim_products is the product dimension combining product details with category information such as name, category, subcategory, cost, and line.

### Relationships

- One customer can have many sales records.

- One product can appear in many sales records.

- Surrogate keys customer_key and product_key are used for joins instead of business keys for better performance.


<img width="2814" height="1536" alt="Data Model" src="https://github.com/user-attachments/assets/67032331-8813-4c27-9906-95e0e52e5788" />

