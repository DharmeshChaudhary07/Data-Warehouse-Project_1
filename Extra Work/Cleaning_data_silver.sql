
===============================================================================
-- for cust_info
select
	*
from datawarehouse.bronze_crm_cust_info
limit 20 ;

-- check for dupliates in the cust_info

select
	cst_id,
    count(*)
from datawarehouse.bronze_crm_cust_info
group by cst_id
having count(cst_id) > 1;

----------

select
	*
FROM datawarehouse.bronze_crm_cust_info
where cst_id = 29466;

----------

select 
	*
from(select 
		*, 
		row_number() over(partition by cst_id order by cst_create_date) as flag
	from datawarehouse.bronze_crm_cust_info
)t where flag != 1;
----------

select
	cst_key,
    count(*)
from datawarehouse.bronze_crm_cust_info
group by cst_key
having count(cst_key) > 1;

----------

select
	cst_firstname
from datawarehouse.bronze_crm_cust_info
where cst_firstname != trim(cst_firstname);

----------

select
	cst_lastname
from datawarehouse.bronze_crm_cust_info
where cst_firstname != trim(cst_lastname);

----------

select distinct 
	cst_marital_status
from datawarehouse.bronze_crm_cust_info;

-- just beacuse later got to know that there was a empty string

SELECT
    cst_marital_status,
    ROW_NUMBER() OVER () AS row_num
FROM (
    SELECT DISTINCT cst_marital_status
    FROM datawarehouse.bronze_crm_cust_info
) t
ORDER BY row_num;

----------

select distinct 
	cst_gndr
from datawarehouse.bronze_crm_cust_info;

-- be safe you never know there is empty sring 
SELECT
    cst_marital_status,
    ROW_NUMBER() OVER (ORDER BY cst_marital_status) AS row_num
FROM (
    SELECT DISTINCT cst_marital_status
    FROM datawarehouse.bronze_crm_cust_info
) t
ORDER BY row_num;


-- 1. Compare as string via CAST
SELECT *
FROM datawarehouse.bronze_crm_cust_info
WHERE CAST(cst_create_date AS CHAR) = '0000-00-00';

select
	CASE 
		WHEN CAST(cst_create_date AS CHAR) = '0000-00-00' THEN NULL 
        ELSE cst_create_date 
    END AS cst_create_date
from datawarehouse.bronze_crm_cust_info;


select *
from Datawarehouse.silver_crm_cust_info

===============================================================================

select *
from datawarehouse.bronze_crm_prd_info
limit 20;

-- check for duplicates
select
prd_id 
from datawarehouse.bronze_crm_prd_info
group by prd_id
having count(prd_id) > 1;

-- checking prd key, substring name in px_cat_g1v2 is id and 

select *
from datawarehouse.bronze_crm_prd_info
limit 20;

select *
from datawarehouse.bronze_erp_px_cat_g1v2
limit 20;

select distinct sls_prd_key
from datawarehouse.bronze_crm_sales_details;

-- checking do we need to trim prd_nm

select *
from datawarehouse.bronze_crm_prd_info
where prd_nm != trim(prd_nm) ;   -- nothing on table so we dont need it

-- checking prd cost if not negative and chaning null to 0

select prd_cost
from datawarehouse.bronze_crm_prd_info
where prd_cost < 0 and prd_cost is null ;

-- prd_line replace with actual name 

select distinct prd_line
from datawarehouse.silver_crm_prd_info;

-- id prd_end_dt < prd_start_dt

select * 
from datawarehouse.bronze_crm_prd_info
where prd_start_dt > prd_end_dt; -- there are 

-- if inserted work or not 
select count(*)
from datawarehouse.silver_crm_prd_info;

select *
from datawarehouse.silver_crm_prd_info;

===============================================================================

-- check if trim needed

select sls_ord_num
from Datawarehouse.bronze_crm_sales_details
where sls_ord_num != trim(sls_ord_num);

-- check if sls_prd_key in silver_crm_prd_info and sls_cust_id in Datawarehouse.silver_crm_cust_info (primary key)
select 
	sls_prd_key
from Datawarehouse.bronze_crm_sales_details
where sls_prd_key in (select prd_key_code from Datawarehouse.silver_crm_prd_info);
 
select 
	sls_cust_id
from Datawarehouse.bronze_crm_sales_details
where sls_cust_id in (select cst_id from Datawarehouse.silver_crm_cust_info);

-- sls_order_dt, sls_ship_dt, sls_due_dt are given as interger but we need to convert it into date
-- should be in range of 1900-01-01 to 2050-12-31 

select 
	sls_order_dt, 
    sls_ship_dt, 
    sls_due_dt
from Datawarehouse.bronze_crm_sales_details

where sls_order_dt <= 0 or sls_ship_dt <= 0 or sls_due_dt <= 0; -- sls_order_dt has 0 but no negative numbers

-- sls_sales, sls_quantity, sls_price 
-- check if there are -ve or 0 or null in all the column and #(sales = quantity * price)#

select
	sls_prd_key,
	sls_sales, 
    sls_quantity, 
    sls_price 
from Datawarehouse.silver_crm_sales_details 
-- where sls_sales is null or sls_quantity is null or sls_price is null;
where sls_sales <= 0 or sls_sales is null or sls_quantity <= 0 or sls_quantity is null or sls_price <= 0 or sls_price is null;  -- sls_sales and sls_price has -ve and 0 values 


-- checking if inserted or not 

select *
from Datawarehouse.silver_crm_sales_details;

select 
    s.sls_prd_key,
    s.sls_sales as silver_sales,
    s.sls_quantity as silver_qty,
    s.sls_price as silver_price,
    b.sls_sales as bronze_sales,
    b.sls_quantity as bronze_qty,
    b.sls_price as bronze_price
from Datawarehouse.silver_crm_sales_details s
join Datawarehouse.bronze_crm_sales_details b
    on s.sls_ord_num = b.sls_ord_num and s.sls_prd_key = b.sls_prd_key
where s.sls_sales <= 0 or s.sls_sales is null;

/*
-- RETURNS TABLE 2 -- which is 
sls_prd_key	silver_sales	silver_qty	silver_price	bronze_sales	bronze_qty	bronze_price
WB-H098			0				2			5				10				2			0
WB-H098			0				5			5				25				5			0
HL-U509-B		0				2			35				70				2			0
BC-R205			0				1			9				9				1			0
HL-U509			0				1			35				35				1			0
BC-M005			0				10			10				100				10			0
CL-9009			0				2			8				16				2			0

Found it — and it's not a bug in your logic exactly, it's a flawed assumption in the mismatch condition. Look at the actual data:
sls_prd_key	bronze_sales	bronze_qty	bronze_price
WB-H098	        10				2			0
BC-R205			9				1			0
sls_sales was already correct in bronze (10, 25, 70, 9, 35, 100, 16 — all valid numbers). The actual problem is sls_price = 0.
Here's what's happening in your sls_sales CASE:
sql
when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price)
then sls_quantity * abs(sls_price)
The third condition — sls_sales != sls_quantity * abs(sls_price) — fires because 10 != 2 * abs(0) (i.e. 10 != 0). That's true, so it "corrects" sales... by recalculating it using the broken price, giving 2 * abs(0) = 0. You're using a bad value (price = 0) to overwrite a perfectly good value (sales = 10). The bug isn't in your syntax anymore — it's that you can't reliably tell which of the two columns is the broken one just from a mismatch, and your formula always assumes it's sales that's wrong.
Fix — only recalculate sls_sales when sls_sales itself is invalid, not merely because it disagrees with a possibly-bad price:
sql
case 
    when sls_sales is null or sls_sales <= 0 
    then sls_quantity * abs(nullif(sls_price, 0))
    else sls_sales
end as sls_sales,
sls_quantity,
case 
    when sls_price is null or sls_price <= 0 
    then sls_sales / nullif(sls_quantity, 0)   -- uses the ORIGINAL bronze sls_sales, which is valid
    else sls_price 
end as sls_price
Key changes:
Dropped the sls_sales != sls_quantity * abs(sls_price) mismatch check from the sales CASE — it was the root cause, since it punished good sales data for a bad price.
sls_sales now only gets recalculated when it's genuinely null/≤0 itself.
sls_price's fallback (sls_sales / nullif(sls_quantity, 0)) still uses the original bronze sls_sales, which we've confirmed is trustworthy here — 10 / 2 = 5, giving back the correct price.
Re-run with this version (after truncating silver again) and check those 7 rows — sls_sales should now correctly show 10, 25, 70, 9, 35, 100, 16 and sls_price should be properly backfilled from sales ÷ quantity instead of staying 0.
*/

select *
from Datawarehouse.silver_crm_sales_details;

===============================================================================

