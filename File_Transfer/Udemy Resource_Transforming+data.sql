--  Data Transformation- Implement SQL FUNCTIONS ON COPY COMMAND 

--  Database : OUR_FIRST_DEMO_DB.PUBLIC.

// Transforming using the SELECT statement
-- use this Database : OUR_FIRST_DEMO_DB.PUBLIC.

show databases;
Use Our_First_Demo_DB
Show tables;

// Example 1 - Table

CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT
    );
   
-- Count operation BEFORE Data Loading via 'COPY' command.
SELECT COUNT(*)  FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX;

-- MANAGE_DB.external_stages.aws_stage
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX
    FROM (select s.$1, s.$2 from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');


-- Count operation AFTER Data Loading via 'COPY' command.
SELECT COUNT(*)  FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX;

-- Structure of OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG table
DESCRIBE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX;

-- View Table Records
SELECT *  FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX;
   
// Example 2 - Table    

CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
);

TRUNCATE TABLE ORDERS_EX_PROFITABLE_FLAG;

-- Count operation BEFORE Data Loading via 'COPY' command.
SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG

SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG 
WHERE  PROFITABLE_FLAG IS NOT NULL;


-- Structure of OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG table
DESCRIBE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG

// Example 2 - Copy Command using a SQL function (subset of functions available)

COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            CASE WHEN CAST(s.$3 as int) < 0 THEN 'not profitable' ELSE 'profitable' END 
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');

-- Count operation AFTER Data Loading via 'COPY' command.
SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG

-- View Table Records
SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG

 -- to view the External table from STAGE
 LIST @MANAGE_DB.external_stages.aws_stage; 


// Example 3 - Table

CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    CATEGORY_SUBSTRING VARCHAR(10)
      );

--  COUNT OPERATION BEFORE LOADING
SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG;

DESCRIBE TABLE ORDERS_EX_PROFITABLE_FLAG;

TRUNCATE TABLE ORDERS_EX_PROFITABLE_FLAG;

// Example 3 - Copy Command using a SQL function (subset of functions available)

COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            substring(s.$5,1,8) 
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');

-- COUNT OPERATION AFTER LOADING.
SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG;

SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG;

-- to view the External table from STAGE
 LIST @MANAGE_DB.external_stages.aws_stage; 

 

 SELECT CURRENT_USER();

 -- Example to download the CSV from your external stage to local - C:\Users\PRASHANTH K\Downloads\OrderDetails.csv
  GET @MANAGE_DB.external_stages.aws_stage/OrderDetails.csv "file:///C:/Users/PRASHANTH K/Downloads/OrderDetails.csv";

 


