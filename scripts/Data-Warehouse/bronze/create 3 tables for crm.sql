 use DataWareH
 --create 3 tables for crm AS	bronze.crm_namefile
 create table bronze.crm_cust_info(
 
 cst_id INT,
 cst_key NVARCHAR(50),
 cst_firstname NVARCHAR(50),
 cst_lastname NVARCHAR(50),
 cst_marital_status NVARCHAR(50) ,
 cst_gndr NVARCHAR(50) ,
 cst_create_date date
 );


  create table bronze.crm_prd_info(
 prd_id INT,
 prd_key NVARCHAR(100),
 prd_nm NVARCHAR(100),
 prd_cost FLOAT,
 prd_line NVARCHAR(50),
 prd_start_dt date,
 prd_end_dt date,
 );




CREATE TABLE bronze.crm_sales_details(
 sls_ord_num NVARCHAR(100),
 sls_prd_key NVARCHAR(100),
 sls_cust_id INT,
 sls_order_dt INT,
 sls_ship_dt INT,
 sls_due_dt INT,
 sls_sales FLOAT,
 sls_quantity INT,
 sls_price FLOAT
);











