 use DataWareH
 
--if OBJECT_ID('x','U') is not null
	--drop table x


 --create 3 tables for crm AS	silver.crm_namefile
 create table silver.crm_cust_info(
 
 cst_id INT,
 cst_key NVARCHAR(50),
 cst_firstname NVARCHAR(50),
 cst_lastname NVARCHAR(50),
 cst_marital_status NVARCHAR(50) ,
 cst_gndr NVARCHAR(50) ,
 cst_create_date date
 );


  create table silver.crm_prd_info(
 prd_id INT,
 cat_id NVARCHAR(100),
 prd_key NVARCHAR(100),
 prd_nm NVARCHAR(100),
 prd_cost FLOAT,
 prd_line NVARCHAR(50),
 prd_start_dt date,
 prd_end_dt date,
 );


 if OBJECT_ID('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details

CREATE TABLE silver.crm_sales_details(
 sls_ord_num NVARCHAR(100),
 sls_prd_key NVARCHAR(100),
 sls_cust_id INT,
 sls_order_dt date,
 sls_ship_dt date,
 sls_due_dt date,
 sls_sales FLOAT,
 sls_quantity INT,
 sls_price FLOAT
);




 use DataWareH
 --create 3 tables for erp AS silver.erp_namefile
 create table silver.erp_CUST_AZ12(
 CID NVARCHAR(100),
 BDATE date ,
 GEN NVARCHAR(50),
 );

 create table silver.erp_LOC_A101(
 CID NVARCHAR(100),
 CNTRY NVARCHAR(50)
 );



  create table silver.erp_PX_CAT_G1V2(
  ID NVARCHAR(100),
  CAT NVARCHAR(100),
  SUBCAT NVARCHAR(100),
  MAINTENANCE NVARCHAR(50),
 );














