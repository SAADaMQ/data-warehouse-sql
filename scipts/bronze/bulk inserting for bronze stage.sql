USE DataWareH;
GO

/*
==============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
Purpose:
    Loads data into bronze schema from external CSV files.
    - Truncates bronze tables before loading.
    - Uses BULK INSERT to load data from CSV files.
==============================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @the_whole_bronze_time_start DATETIME;
    DECLARE @the_whole_bronze_time_end DATETIME;
    DECLARE @start_time DATETIME;
    DECLARE @end_time DATETIME;
    SET @the_whole_bronze_time_start =GETDATE()
    PRINT 'Loading Bronze Layer';
    PRINT 'Loading CRM Tables';
    PRINT '==============================================================';

    SET @start_time = GETDATE();
    PRINT 'Truncating: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SET @start_time = GETDATE();
    PRINT 'Inserting: bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info
    FROM 'C:\Users\saa_0\Desktop\filesofETL\sql-data-warehouse-project\datasets\source_crm\cust_info.CSV'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SELECT COUNT(*) FROM bronze.crm_cust_info;


    PRINT '==============================================================';
    SET @start_time = GETDATE();
    PRINT 'Truncating: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SET @start_time = GETDATE();
    PRINT 'Inserting: bronze.crm_prd_info';
    BULK INSERT bronze.crm_prd_info
    FROM 'C:\Users\saa_0\Desktop\filesofETL\sql-data-warehouse-project\datasets\source_crm\prd_info.CSV'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SELECT COUNT(*) FROM bronze.crm_prd_info;


    PRINT '==============================================================';
    SET @start_time = GETDATE();
    PRINT 'Truncating: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SET @start_time = GETDATE();
    PRINT 'Inserting: bronze.crm_sales_details';
    BULK INSERT bronze.crm_sales_details
    FROM 'C:\Users\saa_0\Desktop\filesofETL\sql-data-warehouse-project\datasets\source_crm\sales_details.CSV'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SELECT COUNT(*) FROM bronze.crm_sales_details;


    PRINT 'Loading ERP Tables';

    PRINT '==============================================================';
    SET @start_time = GETDATE();
    PRINT 'Truncating: bronze.erp_CUST_AZ12';
    TRUNCATE TABLE bronze.erp_CUST_AZ12;
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SET @start_time = GETDATE();
    PRINT 'Inserting: bronze.erp_CUST_AZ12';
    BULK INSERT bronze.erp_CUST_AZ12
    FROM 'C:\Users\saa_0\Desktop\filesofETL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.CSV'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SELECT COUNT(*) FROM bronze.erp_CUST_AZ12;


    PRINT '==============================================================';
    SET @start_time = GETDATE();
    PRINT 'Truncating: bronze.erp_LOC_A101';
    TRUNCATE TABLE bronze.erp_LOC_A101;
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SET @start_time = GETDATE();
    PRINT 'Inserting: bronze.erp_LOC_A101';
    BULK INSERT bronze.erp_LOC_A101
    FROM 'C:\Users\saa_0\Desktop\filesofETL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.CSV'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SELECT COUNT(*) FROM bronze.erp_LOC_A101;


    PRINT '==============================================================';
    SET @start_time = GETDATE();
    PRINT 'Truncating: bronze.erp_PX_CAT_G1V2';
    TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SET @start_time = GETDATE();
    PRINT 'Inserting: bronze.erp_PX_CAT_G1V2';
    BULK INSERT bronze.erp_PX_CAT_G1V2
    FROM 'C:\Users\saa_0\Desktop\filesofETL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.CSV'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT 'the time in sec is: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR);

    SELECT COUNT(*) FROM bronze.erp_PX_CAT_G1V2;

    PRINT 'Bronze Layer Load Completed';
    SET @the_whole_bronze_time_end =GETDATE()
    print 'the whole time is: ' + cast ( datediff(second , @the_whole_bronze_time_start , @the_whole_bronze_time_end) as varchar) 
END