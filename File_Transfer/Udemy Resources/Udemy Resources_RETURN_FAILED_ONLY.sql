-- Using RETURN_FAILED_ONLY
-- If your goal is to see only the records that failed to load during a bulk data load, use the VALIDATE function or specific ON_ERROR parameters.
-- Snowflake COPY INTO documentation - this mode instructs Snowflake to return all errors across all specified files and stop without loading any data

Use COPY_DB;

-- View the previous records and Stage Info
SELECT COUNT(*) FROM ORDERS;
DESCRIBE TABLE ORDERS;
LIST @COPY_DB.PUBLIC.aws_stage_copy;



---- RETURN_FAILED_ONLY ----

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

// Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/returnfailed/';
  
LIST @COPY_DB.PUBLIC.aws_stage_copy;

-- After recreating the table for RETURN_FAILED_ONLY - View records

SELECT COUNT(*) FROM ORDERS;
SELECT * FROM ORDERS
DESCRIBE TABLE ORDERS;


 //Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    RETURN_FAILED_ONLY = TRUE;
    
    
    
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    ON_ERROR =CONTINUE
    RETURN_FAILED_ONLY = TRUE;

Truncate Table COPY_DB.PUBLIC.ORDERS
SELECT COUNT(*) FROM ORDERS

// Default = FALSE

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));


COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    ON_ERROR =CONTINUE;

    SELECT COUNT(*) AS "Records From All CSV FILES" FROM ORDERS

    