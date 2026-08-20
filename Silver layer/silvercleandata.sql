	

/*
===============================================================================
DDL Script: Create SIlver Tables
===============================================================================
Script Purpose:
-- Data Cleansing and transforming (as required for all 6 tables)
-- Stored procedure 
-- Error handling 
-- Time required for running the query all 6 seprately and total time.
===============================================================================

*/


-- calling below query 

call datawarehouse.load_silver;


-- creating error_log
	-- create error log table first (one-time setup, safe to re-run)
create table if not exists datawarehouse.etl_error_log (
    log_id int auto_increment primary key,
    proc_name varchar(100),
    error_state varchar(5),
    error_message text,
    occurred_at datetime default current_timestamp
);

-- creating stored procedures 

delimiter $$

create procedure datawarehouse.load_silver ()
begin
	-- ERROR HANDLING
    declare start_time datetime;
    declare end_time datetime;
    declare v_step varchar(100);
    
	declare continue handler for sqlexception
    begin
        get diagnostics condition 1 @err_state = returned_sqlstate, @err_msg = message_text;
        insert into datawarehouse.etl_error_log(proc_name, error_state, error_message)
        values (v_step, @err_state, @err_msg);
    end;

	set start_time = now();
    select concat('Starting silver layer load at ', start_time) as log_msg;
    
	set v_step = 'silver_crm_cust_info';
    
	-- 1: cust_info
    
	-- Cleaning data for bronze_cust_info and inserting into silver_crm_cust_info table 
    
	truncate table Datawarehouse.silver_crm_cust_info;

	INSERT INTO datawarehouse.silver_crm_cust_info(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
	select 
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case 
			when upper(trim(cst_marital_status)) = 'M' then 'Married'
			when upper(trim(cst_marital_status)) = 'S' then 'Single'
			else 'N/a' -- (there is empty string in the column -- also used trim and upper for safety(we know there are not as distinct showed only 3 rows)
			end as cst_marital_status,
		case 
			when upper(trim(cst_gndr)) = 'F' then 'Female'
			when upper(trim(cst_gndr)) = 'M' then 'Male'
			else 'N/a' -- (there is empty string in the column -- also used trim and upper for safety(we know there are not as distinct showed only 3 rows)
			end as cst_gndr,
			cst_create_date
			
			-- NULLIF(cst_create_date, '0000-00-00') AS cst_create_date
			--     case
			--         WHEN CAST(cst_create_date AS CHAR) = '0000-00-00' THEN NULL 
			--         ELSE cst_create_date 
			--     END AS cst_create_date -- there date(0000-00-00) in the table and silver table wont accept it, as its not in date format 
			
	from(select 
			*,
			row_number() over(partition by cst_id order by cst_create_date) as flag
		from datawarehouse.bronze_crm_cust_info
		WHERE CAST(cst_create_date AS CHAR) <> '0000-00-00' 
		-- as mysql was not accepting '0000-00-00' we just removed all the rows having cst_create_date = '0000-00-00'
		-- shouldn't remove that but as it wasn't accepting (tried with case when and casting as well)
	)t where flag = 1;

	-- ===============================================================================


	set v_step = 'silver_crm_prd_info';
	-- Cleaning data for bronze_crm_prd_info and inserting into silver_crm_prd_info table 

	truncate table datawarehouse.silver_crm_prd_info;

	INSERT INTO datawarehouse.silver_crm_prd_info(prd_id, cat_id, prd_key_code, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
	select
		prd_id,
		replace(substring(prd_key, 1,5), '-', '_')as cat_id,
		substring(prd_key, 7) as prd_key_code,
		trim(prd_nm) as prd_nm,
		coalesce(prd_cost,0) as prd_cost,
		case upper(trim(prd_line))
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'M' then 'Mountain'
			when 'T' then 'Touring'
			else 'N/A'
			end as prd_line,
		cast(prd_start_dt as date) as prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - interval 1 day as date) as prd_end_dt
	from datawarehouse.bronze_crm_prd_info;


	-- ===============================================================================


	set v_step = 'silver_crm_sales_details';
    
	-- Cleaning data for bronze_crm_sales_details and inserting into silver_crm_ table 

	truncate table Datawarehouse.silver_crm_sales_details;

	insert into Datawarehouse.silver_crm_sales_details(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt,
	sls_due_dt, sls_sales, sls_quantity, sls_price)
	select 
		trim(sls_ord_num) as sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case 
			when sls_order_dt <= 0 or length(sls_order_dt) != 8 then null 
			else cast(sls_order_dt as date)
			end as sls_order_dt,
		case 
			when sls_ship_dt <= 0 or length(sls_ship_dt) != 8 then null 
			else cast(sls_ship_dt as date)
			end as sls_ship_dt,
		case 
			when sls_due_dt <= 0 or length(sls_due_dt) != 8 then null 
			else cast(sls_due_dt as date)
			end as sls_due_dt,
		case 
			when sls_sales is null or sls_sales <= 0 
			then sls_quantity * abs(nullif(sls_price, 0)) -- do not use sls_sales = sls_quantity * abs(sls_price) as = inside an expression context (like a CASE...THEN is a boolean equality test, not a variable assignment like you'd get with SET x = y. So sls_sales = sls_quantity * abs(sls_price) doesn't set sls_sales to that computed value — it compares the current sls_sales to that computed value and returns 1 (true), 0 (false), or NULL if either side is NULL.
			else sls_sales
			end as sls_sales,
		sls_quantity,
		case 
			when sls_price is null or sls_price <= 0 
			then sls_sales / nullif(sls_quantity, 0)   -- uses the ORIGINAL bronze sls_sales, which is valid
			else sls_price 
			end as sls_price
	from Datawarehouse.bronze_crm_sales_details;


	-- ===============================================================================
	

	set v_step = 'silver_erp_cust_az12';
	-- Cleaning data for bronze_erp_cust_az12 and inserting into silver_erp_cust_az12 table 

	truncate table Datawarehouse.silver_erp_CUST_AZ12;

	insert into Datawarehouse.silver_erp_CUST_AZ12(cid, bdate, gen)
	Select 
		case 
			when cid like 'NAS%' then substring(cid, 4)
			else cid
			end as cid,
		case 
			when '1925-01-01' > bdate or bdate > curdate() 
			then null
			else bdate
			end as bdate,
		case -- check rough folder cleaning_data_silver(1) why we used upper(trim(both '\r' from trim(gen))) 
			when upper(trim(both '\r' from trim(gen))) in ('F','FEMALE') then 'Female'
			when upper(trim(both '\r' from trim(gen))) in ('M', 'MALE') then 'Male'
			else 'N/A'
			end as gen
	from datawarehouse.bronze_erp_cust_az12;


	-- ===============================================================================


	set v_step = 'silver_erp_LOC_A101';
	-- Cleaning data for bronze_erp_loc_a101 and inserting into silver_erp_loc_a101 table 

	truncate table Datawarehouse.silver_erp_LOC_A101;

	insert into Datawarehouse.silver_erp_LOC_A101 (cid, cntry)
	select 
		replace(cid, '-', '') as cid,
		case 
			when cntry in ('\r',' \r','  \r','   \r') then 'N/A'
			when (cntry) in ('DE\r', 'Germany\r') then 'Germany'
			when cntry in ('US\r', 'USA\r', 'United States\r') then 'United States'
			when cntry = ('France\r') then 'France'
			when cntry = ('Canada\r') then 'Canada'
			when cntry = ('Australia\r') then 'Australia'
			else 'N/A'
			end as cntry
	from datawarehouse.bronze_erp_loc_a101;


	-- ===============================================================================



	set v_step = 'silver_erp_PX_CAT_G1V2';
	-- Cleaning data for bronze_erp_px_cat_g1v2 and inserting into silver_erp_px_cat_g1v2 table 

	truncate table Datawarehouse.silver_erp_PX_CAT_G1V2;

	insert into Datawarehouse.silver_erp_PX_CAT_G1V2 (id, cat, subcat, maintenance)
	select 
		id,
		cat,
		subcat,
		case 
			when maintenance = 'No\r' then 'No'
			when maintenance in ('Yes', 'Yes\r') then 'Yes'
            else maintenance	
			end as maintenance
	from datawarehouse.bronze_erp_px_cat_g1v2;

    set end_time = now();
    select concat('Finished silver layer load at ', end_time,
                   ' | Duration (sec): ', timestampdiff(second, start_time, end_time)) as log_msg;
end $$

delimiter ;







