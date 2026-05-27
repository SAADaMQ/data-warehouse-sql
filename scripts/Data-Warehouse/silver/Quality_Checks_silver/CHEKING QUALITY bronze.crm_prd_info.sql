--CHEKING QUALITY OF THE TABLE silver.crm_prd_info


select * from silver.crm_prd_info



select 
prd_id
from silver.crm_prd_info
where prd_id is null 

select 
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id
having count(*) > 1

select  prd_cost from silver.crm_prd_info
where prd_cost <0 or prd_cost is null 

select distinct 
prd_line
from silver.crm_prd_info

-- make no scence !! 
select 
prd_start_dt,
prd_end_dt
from silver.crm_prd_info
where prd_start_dt>prd_end_dt



-- solving it ! 
select 
prd_key,
COUNT (*)
from silver.crm_prd_info
where prd_start_dt>prd_end_dt
group by prd_key
order by COUNT (*) desc
-- examples to solve this problem : 'BI-RB-BK-R50B-44' , 'BI-RB-BK-R50B-48'

select 
*
from silver.crm_prd_info
where prd_key in ('BI-RB-BK-R50B-44' , 'BI-RB-BK-R50B-48' ) 


-- do the logic :
select 
prd_end_dt as prd_start_dt,


dateadd (day , -1 ,LEAD (prd_start_dt,1,null) over (partition by prd_key order by prd_start_dt) ) as prd_end_dt

from silver.crm_prd_info
where prd_key in ('BI-RB-BK-R50B-44' , 'BI-RB-BK-R50B-48' ) 


-- testing 
SELECT * FROM (
	select 
	prd_id,
	prd_key,
	prd_nm,
	prd_start_dt as expiered_old_start_dt,
	prd_end_dt as prd_start_dt,
	

	dateadd (day , -1 ,LEAD (prd_start_dt,1,null) over (partition by prd_key order by prd_start_dt) ) as prd_end_dt,
	COUNT(*) OVER (PARTITION BY prd_key) as flag 
	from silver.crm_prd_info
	where prd_start_dt>prd_end_dt )t 
	where flag>1 


	-- doing the logic to all column 

	select 
	prd_id,
	prd_key,
	prd_nm,
	prd_start_dt,
	
	dateadd (day , -1 ,LEAD (prd_start_dt,1,null) over (partition by prd_key order by prd_start_dt) ) as prd_end_dt
	
	
	from silver.crm_prd_info
	where  prd_start_dt>prd_end_dt 



select *
from silver.crm_prd_info
