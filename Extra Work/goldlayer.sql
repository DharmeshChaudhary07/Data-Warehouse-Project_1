		
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
