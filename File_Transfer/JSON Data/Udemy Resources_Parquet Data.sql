-- snowflake-s3-parquet-pipeline
-- Replace OUR_FIRST_DB.PUBLIC.JSON_RAW with MANAGE_DB.PUBLIC.JSON_RAW ;
-- =====================================================
-- STEP 1: SET CONTEXT
-- =====================================================
USE MANAGE_DB;  
USE SCHEMA EXTERNAL_STAGES;

-- =====================================================
-- STEP 2: CHECK EXISTING STAGES
-- =====================================================
SHOW STAGES;

-- If AWS_STAGE already exists, you can inspect it
LIST @AWS_STAGE;
SELECT $1 FROM @AWS_STAGE;

-- =================== Execute these commands in AWS CLI ========================================
-- STEP 3 A: CREATE STAGE (initial placeholder version)
-- NOTE: This version does NOT yet use storage integration
-- =============================================================
-- (a) Creates S3 bucket → storage layer for data lake. 
-- Creates a new S3 bucket to store Parquet files for Snowflake ingestion
aws s3 mb s3://parquet-snowflake-demo-bucket 
-- Output:make_bucket: parquet-snowflake-demo-bucket

-- (b) Uploads Parquet file → raw dataset ingestion
-- This file will later be accessed via Snowflake External Stage
aws s3 cp "C:\Users\PRASHANTH K\Downloads\daily_sales_items_top105.parquet" \
s3://parquet-snowflake-demo-bucket/
/*
output: upload: .\daily_sales_items_top105.parquet 
to s3://parquet-snowflake-demo-bucket/daily_sales_items_top105.parquet
*/


-- (c) Validates upload → ensures Snowflake can access file later
-- # Lists all objects in the bucket to confirm successful upload
aws s3 ls s3://parquet-snowflake-demo-bucket/
-- Output: 2026-04-29 16:25:30    4413445 daily_sales_items_top105.parquet

-- ============================================================
-- STEP 3 B: CREATE STAGE (initial placeholder version)
-- NOTE: This version does NOT yet use storage integration
-- =============================================================

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
URL = 's3://parquet-snowflake-demo-bucket';

-- Inspect stage metadata
DESC STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;

-- List files (will FAIL here if integration not attached)
LIST @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;
LIST @PARQUETSTAGE;

-- =========================================================
-- STEP 4: CREATE STORAGE INTEGRATION (AWS IAM CONNECTION)
-- =========================================================

CREATE OR REPLACE STORAGE INTEGRATION S3_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::054330749015:role/snowflake-s3-role'
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('s3://parquet-snowflake-demo-bucket');

-- Verify integration details (VERY IMPORTANT for IAM setup)
DESC INTEGRATION S3_INT;

-- =====================================================
-- STEP 5: ATTACH STORAGE INTEGRATION + PARQUET FORMAT
-- FIXES 403 ACCESS DENIED + PARQUET PARSING ISSUES
-- =====================================================


CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
URL='s3://parquet-snowflake-demo-bucket'
STORAGE_INTEGRATION = S3_INT
FILE_FORMAT = (TYPE = PARQUET);

-- Validate stage configuration
DESC STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;

-- Confirm files are accessible
LIST @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;

-- lists all stages in the schema
SHOW STAGES IN SCHEMA MANAGE_DB.EXTERNAL_STAGES;


-- =====================================================
-- STEP 6: GRANT REQUIRED PERMISSIONS
-- =====================================================
SELECT CURRENT_ROLE();
GRANT USAGE ON DATABASE MANAGE_DB TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA MANAGE_DB.EXTERNAL_STAGES TO ROLE ACCOUNTADMIN;
GRANT USAGE ON STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE TO ROLE ACCOUNTADMIN;

-- =====================================================
-- STEP 7: RAW FILE INSPECTION (PARQUET READ TEST)
-- =====================================================
SELECT *
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
(FILE_FORMAT => MANAGE_DB.EXTERNAL_STAGES.PARQUET_FORMAT);

- =====================================================
-- STEP 8: QUERY PARQUET FILE USING COLUMN MAPPING
-- =====================================================

SELECT 
$1:__index_level_0__::int as index_level,
$1:cat_id::VARCHAR(50) as category,
DATE($1:date::int ) as Date,
$1:"dept_id"::VARCHAR(50) as Dept_ID,
$1:"id"::VARCHAR(50) as ID,
$1:"item_id"::VARCHAR(50) as Item_ID,
$1:"state_id"::VARCHAR(50) as State_ID,
$1:"store_id"::VARCHAR(50) as Store_ID,
$1:"value"::int as value,
METADATA$FILENAME as FILENAME,   -- Metadata columns from Snowflake
METADATA$FILE_ROW_NUMBER as ROWNUMBER,
TO_TIMESTAMP_NTZ(current_timestamp) as LOAD_DATE  -- Load timestamp
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;


SELECT TO_TIMESTAMP_NTZ(current_timestamp);



   // Create destination table

CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.PARQUET_DATA (
    ROW_NUMBER int,
    index_level int,
    cat_id VARCHAR(50),
    date date,
    dept_id VARCHAR(50),
    id VARCHAR(50),
    item_id VARCHAR(50),
    state_id VARCHAR(50),
    store_id VARCHAR(50),
    value int,
    Load_date timestamp default TO_TIMESTAMP_NTZ(current_timestamp));


   // Load the parquet data
   
COPY INTO MANAGE_DB.PUBLIC.PARQUET_DATA
    FROM (SELECT 
            METADATA$FILE_ROW_NUMBER,
            $1:__index_level_0__::int,
            $1:cat_id::VARCHAR(50),
            DATE($1:date::int ),
            $1:"dept_id"::VARCHAR(50),
            $1:"id"::VARCHAR(50),
            $1:"item_id"::VARCHAR(50),
            $1:"state_id"::VARCHAR(50),
            $1:"store_id"::VARCHAR(50),
            $1:"value"::int,
            TO_TIMESTAMP_NTZ(current_timestamp)
        FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE);
        
    
SELECT * FROM MANAGE_DB.PUBLIC.PARQUET_DATA;