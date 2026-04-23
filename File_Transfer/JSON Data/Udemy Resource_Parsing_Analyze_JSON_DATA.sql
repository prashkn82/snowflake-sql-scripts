-- How to VIEW & ANALYSE the JSON DATA in SQL. 
-- Replace  OUR_FIRST_DB.PUBLIC.JSON_RAW -to- MANAGE_DB.PUBLIC.JSON_RAW;
-- View the records After loading JSON DATA

USE MANAGE_DB;
SELECT COUNT(*) FROM MANAGE_DB.PUBLIC.JSON_RAW;
SELECT * FROM MANAGE_DB.PUBLIC.JSON_RAW;

// Second step: Parse & Analyse Raw JSON 

   // Selecting attribute/column

SELECT RAW_FILE:city FROM MANAGE_DB.PUBLIC.JSON_RAW;

SELECT $1:first_name FROM MANAGE_DB.PUBLIC.JSON_RAW;
SELECT $2:city FROM MANAGE_DB.PUBLIC.JSON_RAW;


   // Selecting attribute/column - formattted

SELECT RAW_FILE:first_name::string as first_name  FROM MANAGE_DB.PUBLIC.JSON_RAW;

SELECT RAW_FILE:id::int as id  FROM MANAGE_DB.PUBLIC.JSON_RAW;

SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:last_name::STRING as last_name,
    RAW_FILE:gender::STRING as gender

FROM MANAGE_DB.PUBLIC.JSON_RAW;

   // Handling nested data
   
SELECT RAW_FILE:job as job  FROM MANAGE_DB.PUBLIC.JSON_RAW;