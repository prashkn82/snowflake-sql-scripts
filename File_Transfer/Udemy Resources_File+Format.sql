-- Replace OUR_FIRST_DB.PUBLIC.ORDERS_EX -->   OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
-- // Follow this - Table - ORDERS_EX_PROFITABLE_FLAG


// Specifying file_format in Copy command
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
    
-- Earlier version of ORDERS_EX_PROFITABLE_FLAG - No. of Rows Exist (Handling ON ERROR)
SELECT COUNT(*) FROM  OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG -- 285 Rows.
DESCRIBE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG --Columns are same and will be recreated for 'FILE_FORMAT' OBJECT (OPTIONAL) But for better structure. 

// Creating table
CREATE OR REPLACE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));    

SELECT COUNT(*) FROM  OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG -- 0 Rows.
DESCRIBE TABLE OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG --Columns are same and will be recreated for 'FILE_FORMAT' OBJECT (OPTIONAL) But for better structure. 
    
// Creating schema to keep things organised
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

// Creating file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;

// See properties of file format object
DESC file format MANAGE_DB.file_formats.my_file_format;


// Using file format object in Copy command       
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 


// Altering file format object
ALTER file format MANAGE_DB.file_formats.my_file_format
    SET SKIP_HEADER = 1;
    
// Defining properties on creation of file format object   
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format
    TYPE=JSON,
    TIME_FORMAT=AUTO;    
    
// See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   

  
// Using file format object in Copy command       
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 


// Altering the type of a file format is not possible
ALTER file format MANAGE_DB.file_formats.my_file_format
SET TYPE = CSV;


// Recreate file format (default = CSV)
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;


// See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   



// Truncate table
TRUNCATE table OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG



// Overwriting properties of file format object      
COPY INTO OUR_FIRST_DEMO_DB.PUBLIC.ORDERS_EX_PROFITABLE_FLAG
    FROM  @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (FORMAT_NAME= MANAGE_DB.file_formats.my_file_format  field_delimiter = ',' skip_header=1 )
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

DESC STAGE MANAGE_DB.external_stages.aws_stage_errorex;
