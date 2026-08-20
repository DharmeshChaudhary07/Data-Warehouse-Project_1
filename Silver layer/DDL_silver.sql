		
/*
===============================================================================
DDL Script: Create SIlver Tables
===============================================================================
Script Purpose:
-- DDL defines the structure of database table for Silver layer, drop exsiting tables if they already exists.

-- Define the structure of table or Run this script to re-define the DDL structure of 'Silver' Tables.

-- Addding one extra column in all the table with current time stamps. 
===============================================================================
*/

===============================================================================
-- DROP TABLE IF EXSITS 
DROP TABLE IF EXISTS Datawarehouse.silver_crm_cust_info;
-- create table
create table Datawarehouse.silver_crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE NULL,
dwh_create_date DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
);

-- check table created or not 
select * from Datawarehouse.silver_crm_cust_info;
===============================================================================

-- DROP TABLE IF EXSITS 
DROP TABLE IF EXISTS Datawarehouse.silver_crm_prd_info;
-- create table
create table Datawarehouse.silver_crm_prd_info(
prd_id INT,
cat_id NVARCHAR(50),
prd_key_code NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE NULL,
prd_end_dt DATE NULL,
dwh_create_date DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
);

===============================================================================

-- DROP TABLE IF EXSITS 
DROP TABLE IF EXISTS Datawarehouse.silver_crm_sales_details;
-- create table
create table Datawarehouse.silver_crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE, 		 
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
);	
===============================================================================

-- DROP TABLE IF EXSITS 
DROP TABLE IF EXISTS Datawarehouse.silver_erp_CUST_AZ12;
-- create table
create table Datawarehouse.silver_erp_CUST_AZ12(
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_date DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
);
===============================================================================


-- DROP TABLE IF EXSITS 
DROP TABLE IF EXISTS Datawarehouse.silver_erp_LOC_A101;
-- create table
create table Datawarehouse.silver_erp_LOC_A101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
);
===============================================================================


-- DROP TABLE IF EXSITS 
DROP TABLE IF EXISTS Datawarehouse.silver_erp_PX_CAT_G1V2;
-- create table
create table  Datawarehouse.silver_erp_PX_CAT_G1V2(
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
);