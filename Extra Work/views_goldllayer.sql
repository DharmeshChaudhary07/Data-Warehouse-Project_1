-- 		
/*
===============================================================================
DDL Script: Gold Layer
===============================================================================

Script Purpose:

-- Join multiple table to create so we can create some business logic

	View
-- Create and store the new genrated tables in Views
===============================================================================



*/
-- if exist drop the view
drop view if exists datawarehouse.view_gold_layer;
-- create view
create view datawarehouse.view_gold_layer as 
-- query

select 
	row_number() over(order by cst_id) as customer_key,  -- no duplicate row but still i created for safety:
	sci.cst_id as customer_id,
    sci.cst_key as customer_no,
    sci.cst_firstname as firstname,
    sci.cst_lastname as lastname,
    sela.cntry,
	seca.bdate as birthdate,
    case
		when sci.cst_gndr = 'N/a' then seca.gen
        else sci.cst_gndr
        end as gender,
	sci.cst_marital_status as marital_status,
	sci.cst_create_date as create_date
from datawarehouse.silver_crm_cust_info as sci
left join Datawarehouse.silver_erp_CUST_AZ12 as seca
on sci.cst_key = seca.cid
left join Datawarehouse.silver_erp_LOC_A101 as sela
on sci.cst_key = sela.CID;

