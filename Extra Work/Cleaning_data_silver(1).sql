
===============================================================================

-- cleaning 

Select *
from datawarehouse.bronze_erp_cust_az12

Select *
from datawarehouse.silver_crm_cust_info

select distinct
	cid
from datawarehouse.silver_erp_cust_az12
where cid not in (select cst_key from datawarehouse.silver_crm_cust_info)

-- checking bdate is out of range (1925-01-01 and greater than current date)

Select *
from datawarehouse.silver_erp_cust_az12
where bdate < '1925-01-01' or bdate > curdate()

-- check distinct gender

select distinct
	gen
from datawarehouse.bronze_erp_cust_az12
order by gen

-- no need row number just use order by 
select 
	gen,
    row_number()over(order by gen) as flag
from(
	select distinct 
		trim(gen) as gen
	from datawarehouse.silver_erp_cust_az12
)t

/*
select distinct gen, hex(gen), length(gen), count(*) 
from datawarehouse.bronze_erp_cust_az12
group by gen
order by count(*) desc;

Found it — every value has a trailing carriage return character (\r, hex 0D) attached to it. 
Look at the hex dumps: 'Male\r' = 4D616C650D (the 4D...C65 is "Male", the final 0D is \r), 'Female\r' same pattern.
Why this breaks your CASE: TRIM() in MySQL, by default, only strips plain spaces (0x20) — it does not remove \r, \n, tabs, or other 
control characters. So trim(gen) on 'Male\r' still leaves 'Male\r' behind. 
Then upper('Male\r') → 'MALE\r', which does not exactly match 'MALE' in your IN ('F','FEMALE')/IN ('M','MALE') list — 
string comparison requires an exact match, and the trailing \r breaks it every time. So literally every row falls through to your ELSE 'N/A'.

Root cause: this is a classic Windows-style line ending (CRLF) import issue — your source file used \r\n line breaks, 
but whatever loaded it into MySQL only treated \n as the row terminator, leaving the \r stuck onto the last column of every row.



*/


select *
from datawarehouse.silver_erp_cust_az12
===============================================================================

-- check for primary key matches the other column primary key

select 
	cid,
    cntry
from datawarehouse.bronze_erp_loc_a101

select *
from datawarehouse.silver_crm_cust_info

-- standardization/ normailization for country 

select distinct
    cntry
from datawarehouse.silver_erp_loc_a101
order by cntry

-- check insert into silver_erp_LOC_A101

select * 
from datawarehouse.silver_erp_LOC_A101

===============================================================================

-- check if primary key matches the primary key other column
select 
	id
from datawarehouse.bronze_erp_px_cat_g1v2

select distinct 
	id
from datawarehouse.bronze_erp_px_cat_g1v2
where id in(select cat_id from datawarehouse.silver_crm_prd_info)

select distinct 
	cat
from datawarehouse.bronze_erp_px_cat_g1v2

select distinct
	subcat
from datawarehouse.silver_erp_px_cat_g1v2

select distinct 
	maintenance
from datawarehouse.silver_erp_px_cat_g1v2

select *
from datawarehouse.silver_erp_px_cat_g1v2
===============================================================================
/*
how error_log table get called and how it get error detail
How it actually works, step by step:
You CALL load_silver()
MySQL starts executing statements inside the procedure, in order
Say block4's insert (silver_erp_CUST_AZ12) throws an error — e.g. a data type mismatch, string too long, whatever The moment that error occurs, 
MySQL immediately looks for a handler covering that block. It finds your DECLARE CONTINUE HANDLER FOR SQLEXCEPTION inside block4
Control jumps into that handler's body — this is a completely separate, fresh set of statements that MySQL now executes on its own. 
The failed INSERT is abandoned, but the handler's statements (GET DIAGNOSTICS, then INSERT INTO etl_error_log) are brand new statements 
that haven't failed — they run normally, start to finish Because it's a CONTINUE handler (not EXIT), once the handler finishes, 
execution resumes at the next statement after the one that failed — in this case, it exits block4 and moves on to block5
block5 and block6 then run completely normally, unaffected by block4's failure

to check
select * from datawarehouse.etl_error_log order by occurred_at desc;

*/`