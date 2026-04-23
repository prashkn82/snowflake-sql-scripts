-- Udemy Lab - How to use COPY Command by creating Database & Stage

-- CREATE DATABASE 
-- CREATE SCHEMA_STAGE, ALTER SCHEMA_STAGE
-- CREATE PUBLIC SCHEMA_STAGE
-- DEFINE File Format
-- LOAD DATA USING 'COPY' COMMAND
-- Database to manage stage objects, fileformats etc.

CREATE OR REPLACE DATABASE MANAGE_DB;

CREATE OR REPLACE SCHEMA external_stages;


-- Creating external stage

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3'
    credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');


-- Description of external stage

DESC STAGE MANAGE_DB.external_stages.aws_stage; 
    
    
-- Alter external stage   

ALTER STAGE aws_stage
    SET credentials=(aws_key_id='XYZ_DUMMY_ID' aws_secret_key='987xyz');
    
    
-- Publicly accessible staging area    

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

-- List files in STAGE

LIST @aws_stage;

-- Creating ORDERS table

 CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
    
SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS;

DESCRIBE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS;

-- First copy command
-- The below 'COPY Command' Failed to Execute

COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS
    FROM @aws_stage
    file_format = (type = csv field_delimiter=',' skip_header=1);

-- Copy command with fully qualified stage object
-- The below 'COPY Command' fully qualified stage object Failed to Execute

COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1);


-- Load data using the copy command
-- This 'COPY' COMMAND SUCCESSFULLY LOADED.
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS
    FROM @aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';

Select count(*) from OUR_FIRST_DEMO_DB.PUBLIC.ORDERS;
Truncate table OUR_FIRST_DEMO_DB.PUBLIC.ORDERS;(optional)

DESC STAGE MANAGE_DB.external_stages.aws_stage;

Show databases;
Use database OUR_FIRST_DEMO_DB;

show tables;
    
SELECT * FROM ORDERS;
LIST @MANAGE_DB.external_stages.aws_stage; 

LIST @aws_stage; 

-- Copy command with specified file(s)

COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails.csv');
    