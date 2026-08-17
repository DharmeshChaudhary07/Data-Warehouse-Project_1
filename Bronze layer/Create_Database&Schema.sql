/*

script

*/

-- Create Data base 'DataWarehouse' 

use mysql;

create database Datawarehouse;

use datawarehouse;


-- Because in MySQL, CREATE SCHEMA is CREATE DATABASE — there's no separate "schema" concept to nest things inside a database.
-- We will not create schema for our project  

create schema bronze;

create schema silver;

create schema gold;