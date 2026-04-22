-- Replace OUR_FIRST_DB.PUBLIC.ORDERS_EX -->   OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
-- // Follow this - Table - ORDERS_EX_PROFITABLE_FLAG
-- Example 3 - ORDERS_EX_PROFITABLE_FLAG
CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    CATEGORY_SUBSTRING VARCHAR(10)
      );
      
-- So last updated table columns for ORDERS_EX_PROFITABLE_FLAG
-- Example 3 --> was back updated to Example 2
CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
);


SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
DESCRIBE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
 
// Create new stage
 CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage_errorex
    url='s3://bucketsnowflakes4';
 
 // List files in stage
 LIST @MANAGE_DB.external_stages.aws_stage_errorex;
 
 
 // Example 2 gets updated to Example 4 - Handling Copy Command ERROR.
  CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
DESCRIBE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
 
 // Demonstrating error message
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
     file_format= (type = csv field_delimiter=',' skip_header=1)
     files = ('OrderDetails_error.csv');
    
-- So here fails to update as because of 'Text'
 // Validating table is empty    
SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG  ;  
    

  // Error handling using the ON_ERROR option
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'CONTINUE';
    
  // Validating results and truncating table 
SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG;
SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG;

TRUNCATE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG;

// Error handling using the ON_ERROR option = ABORT_STATEMENT (default)
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'ABORT_STATEMENT';


  // Validating results and truncating table 
SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG

TRUNCATE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG;

// Error handling using the ON_ERROR option = SKIP_FILE
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE';
    
    
  // Validating results and truncating table 
SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
SELECT count(*)   FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG

TRUNCATE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    

// Error handling using the ON_ERROR option = SKIP_FILE_<number>
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE_2';    

// List files in stage
 LIST @MANAGE_DB.external_stages.aws_stage_errorex;
    
  // Validating results and truncating table 
SELECT * FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
SELECT COUNT(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG

TRUNCATE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG   

    
// Error handling using the ON_ERROR option = SKIP_FILE_<number>
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE_3%'; 

  // List files in stage
 LIST @MANAGE_DB.external_stages.aws_stage_errorex;
  
SELECT count(*) FROM OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG


 CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

SELECT COUNT(*) FROM  OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG


COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = SKIP_FILE_3 
    SIZE_LIMIT = 30;

SELECT * FROM  OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG


// List files in stage
 LIST @MANAGE_DB.external_stages.aws_stage_errorex;
