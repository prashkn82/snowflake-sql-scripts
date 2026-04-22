CREATE DATABASE EXERCISE_DB

SHOW DATABASES;
Use Exercise_DB;

-- Exercise:1
-- Create New Table: Customer

create or replace table CUSTOMER(
  customer_id int,
  first_name varchar,
  last_name varchar,
  email varchar,
  age int,
  city varchar)
 

show tables;

-- Count the records.
Select count(*) from CUSTOMER

 
 //Loading the data from S3 bucket
  
  COPY into customer
  from s3://snowflake-assignments-mc/gettingstarted/customers.csv
  file_format = (
    type = csv 
    field_delimiter = ',' 
    skip_header = 1);

//Validate
 SELECT * FROM CUSTOMER;

-- Exercise: 2
--  Create a stage object
/*
Instruction: 
    - The data is available under: s3://snowflake-assignments-mc/loadingdata/
    - Data type: CSV - delimited by ';' (semicolon)
    - Header is in the first line.
*/
 
-- To perform this either Truncate the existing Table or Create a New Table
-- I prefer to choose 'TRUNCATE'

TRUNCATE TABLE CUSTOMER;

-- CREATE SCHEMA_STAGE 
 CREATE OR REPLACE SCHEMA EXERCISE_DB.external_stages;

 -- Creating an EXTERNAL STAGE
CREATE OR REPLACE STAGE EXERCISE_DB.external_stages.aws_stage
      url='s3://snowflake-assignments-mc/loadingdata/'
      credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');

-- Description of external stage
     DESC STAGE EXERCISE_DB.external_stages.aws_stage; 

-- Alter external stage   

ALTER STAGE aws_stage
    SET credentials=(aws_key_id='DFG_DUMMY_ID' aws_secret_key='859xyz');
    
    
-- Publicly accessible staging area    

CREATE OR REPLACE STAGE EXERCISE_DB.external_stages.aws_stage
    url='s3://snowflake-assignments-mc/loadingdata/';

-- List files in stage
LIST @aws_stage;

-- Structure of Customer table.
DESCRIBE TABLE CUSTOMER;



-- Since two Customer CSV files exist so need another Customer Table.

CREATE OR REPLACE TABLE EXERCISE_DB.PUBLIC.CUSTOMER_3 AS SELECT * FROM EXERCISE_DB.PUBLIC.CUSTOMER

SHOW TABLES;
SELECT COUNT(*) FROM CUSTOMER_3
UNION ALL
SELECT COUNT(*) FROM CUSTOMER

TRUNCATE TABLE EXERCISE_DB.PUBLIC.CUSTOMER

DROP TABLE EXERCISE_DB.EXTERNAL_STAGES.CUSTOMER_3

-- List files in stage
LIST @aws_stage;

COPY INTO EXERCISE_DB.PUBLIC.CUSTOMER
    FROM @EXERCISE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=';' skip_header=1)
    --pattern='.*customers2.*';
    files = ('customers2.csv');
    
COPY INTO EXERCISE_DB.PUBLIC.CUSTOMER_3
    FROM @EXERCISE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=';' skip_header=1)
    pattern='.*customers3.*';
    -- files = ('customer3.csv');

    -- Assignment 4: Create file format object & use copy option
    -- If you have not created the database EXERCISE_DB then you can do so. The same goes for the customer table with the following     
    /*   ID INT,
         first_name varchar,
         last_name varchar,
         email varchar,
         age int,
        city varchar

 1. Create a stage & file format object
The data is available under: s3://snowflake-assignments-mc/fileformat/
Data type: CSV - delimited by '|' (pipe)
Header is in the first line.

2. List the files in the table

3. Load the data in the existing customers table using the COPY command your stage and the created file format object.

4. How many rows have been loaded in this assignment?

Questions for this assignment
How many rows have been loaded?

*/

-- Re CREATE the CUSTOMER TABLE IN EXERCISE_DB.
Use Exercise_DB;
CREATE OR REPLACE TABLE CUSTOMER(
  customer_id int,
  first_name varchar,
  last_name varchar,
  email varchar,
  age int,
  city varchar)

 -- View the Table Records
 SELECT Count(*) from CUSTOMER


/* 
 1. Create a stage & file format object
The data is available under: s3://snowflake-assignments-mc/fileformat/
Data type: CSV - delimited by '|' (pipe)
Header is in the first line.
*/

// Creating schema to keep things organised
CREATE OR REPLACE SCHEMA EXERCISE_DB.external_stages;

 -- Creating an EXTERNAL STAGE
CREATE OR REPLACE STAGE EXERCISE_DB.external_stages.aws_stage
      url='s3://snowflake-assignments-mc/fileformat/'
      
// Creating file format object
CREATE OR REPLACE file format  EXERCISE_DB.external_stages.my_file_format;


// See properties of file format object
DESC file format EXERCISE_DB.external_stages.file_formats;

-- 2. List the files in the table
-- List files in stage
LIST @aws_stage;

-- 3. Load the data in the existing customers table using the COPY command your stage and the created file format object.

// Using file format object in Copy command       
COPY INTO EXERCISE_DB.PUBLIC.CUSTOMER
    FROM @EXERCISE_DB.external_stages.aws_stage
    file_format= (FORMAT_NAME=EXERCISE_DB.external_stages.file_formats)
    files = ('customers4.csv')
    ON_ERROR = 'SKIP_FILE_3'; 


-- Failed due to SKP_HEADER VALUE set to 0  

// Altering file format object
ALTER file format EXERCISE_DB.external_stages.file_formats
    SET  field_delimiter = '|' SKIP_HEADER = 1;

-- 4. How many rows have been loaded in this assignment?

// After Altering File Format - Use again COPY COMMAND Using file format object   
-- Added : field_delimiter = '|' skip_header=1 in the File Format.

COPY INTO EXERCISE_DB.PUBLIC.CUSTOMER
    FROM @EXERCISE_DB.external_stages.aws_stage
    file_format= (FORMAT_NAME=EXERCISE_DB.external_stages.file_formats field_delimiter = '|' skip_header=1)
    files = ('customers4.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

--   How many rows have been loaded? = 250 Rows.

-- Lets Truncate the Table and Reload it again using the copy command with Options.
TRUNCATE TABLE EXERCISE_DB.PUBLIC.CUSTOMER

SELECT COUNT(*) FROM EXERCISE_DB.PUBLIC.CUSTOMER

-- Intially failed to upload because in the FILE FORMAT 'FEILD_DELIMETER' was not updated. So the below Command failed.

COPY INTO EXERCISE_DB.PUBLIC.CUSTOMER
    FROM @EXERCISE_DB.external_stages.aws_stage
    file_format= (FORMAT_NAME=EXERCISE_DB.external_stages.file_formats)
    files = ('customers4.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

    SELECT COUNT(*) FROM EXERCISE_DB.PUBLIC.CUSTOMER

    SELECT * FROM  EXERCISE_DB.PUBLIC.CUSTOMER

    /*
        Assignment 5 : Using the COPY OPTIONS
       1.  CREATE an EMPLOYEE TABLE with following attributes.
            customer_id int, 
            first_name varchar(50),
            last_name varchar(50),
             email varchar(50),
             age int,
             department varchar(50)

        2.  Create a stage object pointing to 
            's3://snowflake-assignments-mc/copyoptions/example1'

        3. Create a file format object with the specification

            TYPE = CSV
            FIELD_DELIMITER=','
            SKIP_HEADER=1;

4. Use the copy option to only validate if there are errors and if yes what errors.

5. Load the data anyway, regardless of the error using the ON_ERROR option. How many rows have been loaded?

Questions for this assignment
How many rows have been loaded?
*/

 -- 1  CREATE an EMPLOYEE TABLE with the following attributes.
Use Exercise_DB;
CREATE OR REPLACE TABLE EMPLOYEES(
  customer_id int, 
  first_name varchar(50),
  last_name varchar(50),
  email varchar(50),
  age int,
  department varchar(50));

 -- 2. Create a stage object pointing to - 's3://snowflake-assignments-mc/copyoptions/example1'
 --  Creating schema to keep things organised
CREATE OR REPLACE SCHEMA EXERCISE_DB.external_stages;

-- View the Staging SCHEMA
LIST @aws_stage;

 -- Creating an EXTERNAL STAGE
CREATE OR REPLACE STAGE EXERCISE_DB.external_stages.aws_stage
      url='s3://snowflake-assignments-mc/copyoptions/example1'

--  3. Create a file format object with the specification

Copy into EXERCISE_DB.PUBLIC.EMPLOYEES
FROM @EXERCISE_DB.external_stages.aws_stage
FILE_FORMAT = (type=csv field_delimiter=',' skip_header=1)
pattern='.*employees.*'
validation_mode=return_errors;

-- 4. Use the copy option to validate only if there are errors and, if so, identify the specific errors.
-- ERROR: Numeric value '-' is not recognised at LINE 10, Character '1'

-- 5. Load the data anyway, regardless of the error, using the ON_ERROR option. How many rows have been loaded?
Copy into EXERCISE_DB.PUBLIC.EMPLOYEES
FROM @EXERCISE_DB.external_stages.aws_stage
FILE_FORMAT = (type=csv field_delimiter=',' skip_header=1)
pattern='.*employees.*'
ON_ERROR = CONTINUE;

SELECT COUNT(*) FROM EMPLOYEES; -- 121 rows are uploaded & Skipped 1 row due bad file.
SELECT * FROM EMPLOYEES;

TRUNCATE TABLE EMPLOYEES;

-- How many rows have been loaded? - 121 rows are uploaded & Skipped 1 row due bad file. 

/*
 Assignment 6: 
 1. Create a table called employees with the following columns and data types:
  customer_id int,first_name varchar(50),last_name varchar(50),email varchar(50),age int,department varchar(50)
 
 2 Create a stage object pointing to's3://snowflake-assignments-mc/copyoptions/example2'

 3. Create a file format object with the specification
        TYPE = CSV
        FIELD_DELIMITER=','
        SKIP_HEADER=1;

4. Use the copy option to only validate if there are errors and if yes what errors.

5. One value in the first_name column has more than 50 characters. We assume the table column properties could not be changed.

What option could you use to load that record anyways and just truncate the value after 50 characters?

Load the data in the table using that option.

6. Questions for this assignment
How many rows have been loaded? 

*/

-- 1 Create a table called employees with the following columns and data types:

  Use Exercise_DB;

  SELECT COUNT(*) FROM EXERCISE_DB.PUBLIC.EMPLOYEES
  
  CREATE OR REPLACE TABLE EMPLOYEES(
	customer_id int,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(50),
	age int,
	department varchar(50));

    -- 2 Create a stage object pointing to's3://snowflake-assignments-mc/copyoptions/example2'
    -- Create Schema & Stage.
    --  Creating schema to keep things organised
    CREATE OR REPLACE STAGE EXERCISE_DB.external_stages.aws_stage
        url='s3://snowflake-assignments-mc/copyoptions/example2'
     

        -- create file format object
        CREATE OR REPLACE FILE FORMAT EXERCISE_DB.public.aws_fileformat
        TYPE = CSV
        FIELD_DELIMITER=','
        SKIP_HEADER=1;

         -- View the Staging SCHEMA
            LIST @aws_stage;


      -- 3  Load the data using the Copy Command based on the  Validation_Mode option. 
      --  Check for  VALIDATION_MODE = RETURN_ERRORS;
        Copy into EXERCISE_DB.PUBLIC.EMPLOYEES
        FROM @EXERCISE_DB.external_stages.aws_stage
        FILE_FORMAT = (type=csv field_delimiter=',' skip_header=1)
        pattern='.*employees.*'
        VALIDATION_MODE = RETURN_ERRORS;   

        SELECT COUNT (*) FROM EMPLOYEES;

        -- OR
        -- Use validation mode
         COPY INTO EXERCISE_DB.PUBLIC.EMPLOYEES
         FROM @EXERCISE_DB.external_stages.aws_stage
         FILE_FORMAT = EXERCISE_DB.public.aws_fileformat
         pattern='.*employees.*'
         VALIDATION_MODE = RETURN_ERRORS;
    
      -- 4.   Use the copy option to only validate if there are errors and if yes what errors.
      -- There is an error. First_name - Row Num 28 - User character length limit (50) exceeded by string 
      -- 'Edee Antoin Lothar Marcus    Frank Alexander Gustav Aurelio'

      -- 5. One value in the first_name column has more than 50 characters. We assume that the table column properties cannot be changed.
      -- What option could you use to load that record ANYWAY and just truncate the value after 50 characters? - TRUNCATECOLUMNS = TRUE;
      -- Load the data in the table using that option. - TRUNCATECOLUMNS = TRUE;

      -- we will use - TRUNCATECOLUMNS = TRUE; that will eliminate the exceeding character and load into the table.

       Copy into EXERCISE_DB.PUBLIC.EMPLOYEES
        FROM @EXERCISE_DB.external_stages.aws_stage
        FILE_FORMAT = (type=csv field_delimiter=',' skip_header=1)
        pattern='.*employees.*'
       TRUNCATECOLUMNS = TRUE
       FORCE = TRUE;

       -- 6  Questions for this assignment - How many rows have been loaded? - 62 Rows loaded.

       Select count(*) from EXERCISE_DB.PUBLIC.EMPLOYEES#

       SELECT CUSTOMER_ID,FIRST_NAME,LAST_NAME,DEPARTMENT FROM EXERCISE_DB.PUBLIC.EMPLOYEES
       WHERE CUSTOMER_ID = 28

       