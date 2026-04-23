-- Handling nested data - JSON  
-- Replace  OUR_FIRST_DB.PUBLIC.JSON_RAW -to- MANAGE_DB.PUBLIC.JSON_RAW;

USE MANAGE_DB;
SELECT RAW_FILE:job as job  FROM MANAGE_DB.PUBLIC.JSON_RAW;

-- RAW_FILE - VARIANT column containing JSON
-- job.salary - extracts salary from nested "job" object
SELECT 
      RAW_FILE:job.salary::INT as salary
FROM MANAGE_DB.PUBLIC.JSON_RAW;


SELECT 
    RAW_FILE:first_name::STRING as First_Name,  -- extracts "first_name" from root JSON object
    RAW_FILE:job.salary::INT as Salary,  --  navigates into "job" object and extracts "salary"
    RAW_FILE:job.title::STRING as Job_Title  --  navigates into "job" object and extracts "job title"
FROM MANAGE_DB.PUBLIC.JSON_RAW;


// Handling arrays

SELECT
    RAW_FILE:prev_company as prev_company
FROM MANAGE_DB.PUBLIC.JSON_RAW;

SELECT
    RAW_FILE:prev_company[1]::STRING as prev_company
FROM MANAGE_DB.PUBLIC.JSON_RAW;


SELECT
    ARRAY_SIZE(RAW_FILE:prev_company) as prev_company
FROM MANAGE_DB.PUBLIC.JSON_RAW;




SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:prev_company[0]::STRING as prev_company
FROM MANAGE_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:prev_company[1]::STRING as prev_company
FROM MANAGE_DB.PUBLIC.JSON_RAW
ORDER BY id;

