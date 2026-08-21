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

-- for customer

-- if exist drop the view
drop view if exists datawarehouse.custview_gold_layer;
-- create view
create view datawarehouse.custview_gold_layer as 
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

-- ======================================================================

-- for product

-- drop if already exists
drop view if exists Datawarehouse.productview_gold_layer;
-- create view
create view datawarehouse.productview_gold_layer as
select
	ROW_NUMBER() OVER (ORDER BY scpi.prd_start_dt, scpi.prd_key_code) AS product_key,
	scpi.prd_id as product_id,
    scpi.prd_key_code as product_no,
    scpi.prd_nm as productname,
	scpi.cat_id as category_id,
	sepcg.cat as category,
    sepcg.subcat as subcategory,
    sepcg.maintenance as maintenance,
    scpi.prd_cost as cost,
    scpi.prd_line as product_line,
	scpi.prd_start_dt as startdate
from Datawarehouse.silver_crm_prd_info as scpi
left join Datawarehouse.silver_erp_PX_CAT_G1V2 as sepcg
on scpi.cat_id = sepcg.id
where prd_end_dt is null; -- using current data only (leaves historical data) (having end_date = null)
	

-- ======================================================================

-- use the dimensions surrogate key instead od ids to easily connect facts with dimensions 
-- remove 
-- for sales


-- drop if already exists
drop view if exists Datawarehouse.salesview_gold_layer;
-- create view
create view datawarehouse.salesview_gold_layer as 

select 
	sls_ord_num  asorder_no,
    pgl.product_key,        -- removed sls_prd_key as we dont need it we joining using it, and took just surrogate key
    cgl.customer_key,       -- removed sls_cust_id as we dont need it we joining using it, and took just surrogate key
	sls_order_dt as order_date,
	sls_ship_dt as ship_date,
	sls_due_dt as due_date,
	sls_sales as sales_amount,
	sls_quantity as quantity,
	sls_price
from Datawarehouse.silver_crm_sales_details as csd
left join Datawarehouse.productview_gold_layer as pgl
on csd.sls_prd_key = pgl.product_no
left join Datawarehouse.custview_gold_layer as cgl
on cgl.customer_id = csd.sls_cust_id



