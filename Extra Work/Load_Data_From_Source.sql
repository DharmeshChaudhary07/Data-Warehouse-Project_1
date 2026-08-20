/*
===============================================================================
Load data from Source
===============================================================================
1. Loading data from the csv file to table using queryies
		
        - In MYSQL just load data local infile to load data --in sqlserver we can use buck insert to load data from source
        -  Also to load data we should enable both server side and client side to fetch data(Step to enable are below)
*/

===============================================================================
/*
LOAD DATA INFILE '/Users/dharmeshchaudhary/Material/SQL/Data Warehouse project /Bara/datasets/source_crm/cust_info.csv'
INTO TABLE datawarehouse.bronze_crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
## ERROR: The MySQL server is running with the --secure-file-priv option so it cannot execute this statement 
## Right — secure-file-priv blocks LOAD DATA INFILE from any path except the one MySQL allows. 
## You need to either use that allowed path, or switch to LOCAL INFILE.

SHOW VARIABLES LIKE 'secure_file_priv';
## SAYS NULL
*/

===============================================================================
Enable server and client side to access the data from source 
===============================================================================
LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_crm/cust_info.csv'
INTO TABLE datawarehouse.bronze_crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

## ERROR: Loading local data is disabled; this must be enabled on both the client and server sides ##
## local_infile is turned off on the server, so it's blocking your LOAD DATA LOCAL INFILE command.

-- For server side 

SHOW GLOBAL VARIABLES LIKE 'local_infile';   -- Was OFF

SET GLOBAL local_infile = 1;   -- TURNED ON 

SHOW GLOBAL VARIABLES LIKE 'local_infile';


-- For client side 
  Manage Connections → select connection → Advanced tab → "Others" box → add:
  
  OPT_LOCAL_INFILE=1 (move the cursor from others before closing (it auto saves))
  
  
  
  
  
===============================================================================
Inserting data to table from csv file (bronze_crm_cust_info)
===============================================================================

-- Empty the table before inserting into table 
truncate table datawarehouse.bronze_crm_cust_info;
-- inserting data
LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_crm/cust_info.csv'
INTO TABLE datawarehouse.bronze_crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check data if in correct column
select * 
from datawarehouse.bronze_crm_cust_info 
limit 10;

-- check the number of rows

select
		count(*) 
from datawarehouse.bronze_crm_cust_info ;

 
===============================================================================
Inserting data to table from csv file (bronze_crm_prd_info)
===============================================================================

-- Empty the table before inserting into table 
truncate table datawarehouse.bronze_crm_prd_info;
-- inserting data
LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_crm/prd_info.csv'
INTO TABLE datawarehouse.bronze_crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check data if in correct column
select * 
from datawarehouse.bronze_crm_prd_info 
limit 10;

-- check the number of rows

select
		count(*) 
from datawarehouse.bronze_crm_prd_info ;


===============================================================================
Inserting data to table from csv file (bronze_crm_sales_details)
===============================================================================

-- Empty the table before inserting into table 
truncate table datawarehouse.bronze_crm_sales_details;
-- inserting data
LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_crm/sales_details.csv'
INTO TABLE datawarehouse.bronze_crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check data if in correct column
select * 
from datawarehouse.bronze_crm_sales_details
limit 10;

-- check the number of rows

select
		count(*) 
from datawarehouse.bronze_crm_sales_details


===============================================================================
Inserting data to table from csv file (bronze_erp_CUST_AZ12)
===============================================================================

-- Empty the table before inserting into table 
truncate table datawarehouse.bronze_erp_CUST_AZ12;
-- inserting data
LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE datawarehouse.bronze_erp_CUST_AZ12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check data if in correct column
select * 
from datawarehouse.bronze_erp_CUST_AZ12
limit 10;

-- check the number of rows

select
		count(*) 
from datawarehouse.bronze_erp_CUST_AZ12


===============================================================================
Inserting data to table from csv file (bronze_erp_LOC_A101)
===============================================================================

-- Empty the table before inserting into table 
truncate table datawarehouse.bronze_erp_LOC_A101;
-- inserting data
LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_erp/LOC_A101.csv'
INTO TABLE datawarehouse.bronze_erp_LOC_A101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check data if in correct column
select * 
from datawarehouse.bronze_erp_LOC_A101
limit 10;

-- check the number of rows

select
		count(*) 
from datawarehouse.bronze_erp_LOC_A101


===============================================================================
Inserting data to table from csv file (bronze_erp_PX_CAT_G1V2)
===============================================================================

-- Empty the table before inserting into table 
truncate table datawarehouse.bronze_erp_PX_CAT_G1V2;
-- inserting data
LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE datawarehouse.bronze_erp_PX_CAT_G1V2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check data if in correct column
select * 
from datawarehouse.bronze_erp_PX_CAT_G1V2
limit 10;

-- check the number of rows

select
		count(*) 
from datawarehouse.bronze_erp_PX_CAT_G1V2
	
