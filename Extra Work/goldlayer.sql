		
/*
===============================================================================
Script -> rough work Gold layer 
===============================================================================

*/


select * from datawarehouse.silver_crm_cust_info;
select * from datawarehouse.silver_erp_CUST_AZ12;
select * from datawarehouse.silver_erp_LOC_A101;


select cst_id, count(*)
from datawarehouse.silver_crm_cust_info
group by cst_id
having count(*) > 1;


with cte_check as (
    select 
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
        sci.cst_create_date as create_date,
        count(*) over(partition by sci.cst_id) as dup_count
    from datawarehouse.silver_crm_cust_info as sci
    left join Datawarehouse.silver_erp_CUST_AZ12 as seca
        on sci.cst_key = seca.cid
    left join Datawarehouse.silver_erp_LOC_A101 as sela
        on sci.cst_key = sela.CID
)
select *
from cte_check
where dup_count > 1
order by customer_id;

-------------

select * from datawarehouse.silver_crm_prd_info;
select * from datawarehouse.silver_erp_PX_CAT_G1V2;

---------


select * from Datawarehouse.silver_crm_sales_details;
select * from datawarehouse.custview_gold_layer;
select * from datawarehouse.productview_gold_layer;
select * from Datawarehouse.salesview_gold_layer;



--- fact check 
-- forign key integrity (Dimension)


select * 
from Datawarehouse.salesview_gold_layer as f
left join datawarehouse.custview_gold_layer as c
on c.customer_key = f.customer_key
where c.customer_key is null;

select * 
from Datawarehouse.salesview_gold_layer as s
left join datawarehouse.productview_gold_layer as p
on s.product_key = p.product_key 
where s.product_key is null;