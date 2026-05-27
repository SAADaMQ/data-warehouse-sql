-- INSERTING TO silver.crm_prd_info WITH SOLVING THE PROBLEMS OF CHEKING 





insert into silver.crm_prd_info
(
 prd_id ,
 cat_id ,
 prd_key ,
 prd_nm ,
 prd_cost ,
 prd_line ,
 prd_start_dt ,
 prd_end_dt 
 )
			select 
			prd_id,
			trim (replace(SUBSTRING(prd_key , 1 , 5) ,'-' , '_')) as cat_id,-- FOR ID from bronze.erp_PX_CAT_G1V2
			trim(SUBSTRING(prd_key , 7 , LEN (prd_key))) as prd_key,--FOR sls_prd_key from bronze.crm_sales_details
			prd_nm,

			COALESCE(prd_cost, 0) AS prd_cost,

			CASE 
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales' 
			WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain' 
			WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road' 
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring' 
			ELSE 'Unknown'
			end as prd_line  ,


			prd_start_dt,
			dateadd (day , -1 ,LEAD (prd_start_dt,1,null) over (partition by prd_key order by prd_start_dt) ) as prd_end_dt

			from bronze.crm_prd_info






