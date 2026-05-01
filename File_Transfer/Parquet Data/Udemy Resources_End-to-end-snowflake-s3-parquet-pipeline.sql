-- =====================================================
-- STEP 1: PREVIEW PARQUET DATA FROM EXTERNAL STAGE
-- =====================================================
-- Reads Parquet file directly from S3 using Snowflake external stage
-- Also captures file-level metadata for auditing

    // Adding metadata
USE MANAGE_DB;      
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
METADATA$FILENAME as FILENAME,                 -- Metadata columns (very useful for debugging & lineage)
METADATA$FILE_ROW_NUMBER as ROWNUMBER,
TO_TIMESTAMP_NTZ(current_timestamp) as LOAD_DATE    -- Load timestamp
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;


-- =====================================================
-- STEP 2: VALIDATE CURRENT TIMESTAMP FUNCTION
-- =====================================================
-- Quick check (optional)

SELECT TO_TIMESTAMP_NTZ(current_timestamp);


-- =====================================================
-- STEP 3: CREATE DESTINATION TABLE
-- =====================================================
-- Stores ingested Parquet data inside Snowflake (warehouse layer)

  
CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.PARQUET_DATA(
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


-- =====================================================
-- STEP 4: LOAD DATA FROM PARQUET (S3) INTO TABLE
-- =====================================================
-- Uses COPY INTO with a SELECT transformation
-- Maps Parquet fields → table columns

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

        
-- =====================================================
-- STEP 5: VALIDATE LOADED DATA
-- =====================================================    
SELECT * FROM MANAGE_DB.PUBLIC.PARQUET_DATA;

-- =====================================================
-- STEP 6: RAW FILE INSPECTION (PARQUET READ TEST)
-- =====================================================
SELECT *
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
(FILE_FORMAT => MANAGE_DB.EXTERNAL_STAGES.PARQUET_FORMAT);


