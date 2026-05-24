 use DataWareH
 --create 3 tables for erp AS bronze.erp_namefile
 create table bronze.erp_CUST_AZ12(
 CID NVARCHAR(100),
 BDATE date ,
 GEN NVARCHAR(50),
 );

 create table bronze.erp_LOC_A101(
 CID NVARCHAR(100),
 CNTRY NVARCHAR(50)
 );



  create table bronze.erp_PX_CAT_G1V2(
  ID NVARCHAR(100),
  CAT NVARCHAR(100),
  SUBCAT NVARCHAR(100),
  MAINTENANCE NVARCHAR(50),
 );







