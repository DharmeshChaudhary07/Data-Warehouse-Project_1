/*
===============================================================================
			Load data from Source and Stored Procedures
===============================================================================
1. Loading data from the csv file to table using queryies
		
        - In MYSQL just load data local infile to load data --in sqlserver we can use buck insert to load data from source
        -  Also to load data we should enable both server side and client side to fetch data(Step to enable are below)
        
2. Stored procedure cannot be used with load data in mysql
		- Use mysqlimport (command-line tool) instead of LOAD DATA, called from outside SQL: Not a stored procedure, 
        but a shell script that does the same job:

3. Declare Handler (try/catch in sql server)Not for this script — DECLARE ... HANDLER only works inside a BEGIN...END block (a stored procedure, 
function, or trigger). Since LOAD DATA can't go inside a procedure, and this script has no BEGIN...END wrapper, 
there's no valid place to put a handler here. Adding one would just cause a syntax error, since DECLARE outside a procedure body 
isn't valid MySQL syntax at all. 

4. Calculate duration of query 
*/





-- Creating Stored Procedures

-- DELIMITER $$

-- CREATE PROCEDURE datawarehouse.load_bronze()
-- BEGIN 
		
        -- duration of query
		SET @start_time = NOW(6);

		/*
		===============================================================================
		Inserting data to table from csv file (bronze_crm_cust_info)
		===============================================================================
		*/
        
        SET @tbl_start = NOW(6);

		-- Empty the table before inserting into table 
		truncate table datawarehouse.bronze_crm_cust_info;
		-- inserting data
		LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_crm/cust_info.csv'
		INTO TABLE datawarehouse.bronze_crm_cust_info
		FIELDS TERMINATED BY ','
		LINES TERMINATED BY '\n'
		IGNORE 1 ROWS;
        
        SET @tbl_end = NOW(6);
		SELECT 'bronze_crm_cust_info' AS table_name, TIMEDIFF(@tbl_end, @tbl_start) AS load_duration;

		/*
		===============================================================================
		Inserting data to table from csv file (bronze_crm_prd_info)
		===============================================================================
		*/
        SET @tbl_start = NOW(6);

		-- Empty the table before inserting into table 
		truncate table datawarehouse.bronze_crm_prd_info;
		-- inserting data
		LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_crm/prd_info.csv'
		INTO TABLE datawarehouse.bronze_crm_prd_info
		FIELDS TERMINATED BY ','
		LINES TERMINATED BY '\n'
		IGNORE 1 ROWS;
        
        SET @tbl_end = NOW(6);
		SELECT 'bronze_crm_prd_info' AS table_name, TIMEDIFF(@tbl_end, @tbl_start) AS load_duration;	

		/*
		===============================================================================
		Inserting data to table from csv file (bronze_crm_sales_details)
		===============================================================================
		*/
        SET @tbl_start = NOW(6);

		-- Empty the table before inserting into table 
		truncate table datawarehouse.bronze_crm_sales_details;
		-- inserting data
		LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_crm/sales_details.csv'
		INTO TABLE datawarehouse.bronze_crm_sales_details
		FIELDS TERMINATED BY ','
		LINES TERMINATED BY '\n'
		IGNORE 1 ROWS;

        SET @tbl_end = NOW(6);
		SELECT 'bronze_crm_sales_details' AS table_name, TIMEDIFF(@tbl_end, @tbl_start) AS load_duration;


		/*
		===============================================================================
		Inserting data to table from csv file (bronze_erp_CUST_AZ12)
		===============================================================================
		*/
        SET @tbl_start = NOW(6);

		-- Empty the table before inserting into table 
		truncate table datawarehouse.bronze_erp_CUST_AZ12;
		-- inserting data
		LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_erp/CUST_AZ12.csv'
		INTO TABLE datawarehouse.bronze_erp_CUST_AZ12
		FIELDS TERMINATED BY ','
		LINES TERMINATED BY '\n'
		IGNORE 1 ROWS;

        SET @tbl_end = NOW(6);
		SELECT 'bronze_erp_CUST_AZ12' AS table_name, TIMEDIFF(@tbl_end, @tbl_start) AS load_duration;
        
		/*
		===============================================================================
		Inserting data to table from csv file (bronze_erp_LOC_A101)
		===============================================================================
		*/
        SET @tbl_start = NOW(6);

		-- Empty the table before inserting into table 
		truncate table datawarehouse.bronze_erp_LOC_A101;
		-- inserting data
		LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_erp/LOC_A101.csv'
		INTO TABLE datawarehouse.bronze_erp_LOC_A101
		FIELDS TERMINATED BY ','
		LINES TERMINATED BY '\n'
		IGNORE 1 ROWS;

        SET @tbl_end = NOW(6);
		SELECT 'bronze_erp_LOC_A101' AS table_name, TIMEDIFF(@tbl_end, @tbl_start) AS load_duration;
        
		/*
		===============================================================================
		Inserting data to table from csv file (bronze_erp_PX_CAT_G1V2)
		===============================================================================
		*/
        SET @tbl_start = NOW(6);

		-- Empty the table before inserting into table 
		truncate table datawarehouse.bronze_erp_PX_CAT_G1V2;
		-- inserting data
		LOAD DATA LOCAL INFILE '/Users/dharmeshchaudhary/Material/SQL/Data_Warehouse_project/Bara/datasets/source_erp/PX_CAT_G1V2.csv'
		INTO TABLE datawarehouse.bronze_erp_PX_CAT_G1V2
		FIELDS TERMINATED BY ','
		LINES TERMINATED BY '\n'
		IGNORE 1 ROWS;
   
        SET @tbl_end = NOW(6);
		SELECT 'bronze_erp_PX_CAT_G1V2' AS table_name, TIMEDIFF(@tbl_end, @tbl_start) AS load_duration;
        
        
        SET @end_time = NOW(6);
        SELECT TIMEDIFF(@end_time, @start_time) AS total_duration;
-- END $$
-- DELIMITER ;

-- Call the stored Procedure
-- CALL datawarehouse.load_bronze();


	
