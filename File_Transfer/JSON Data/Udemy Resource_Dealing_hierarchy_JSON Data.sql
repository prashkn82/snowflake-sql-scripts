-- Dealing with HIERARCHY JSON DATA
-- Replace OUR_FIRST_DB.PUBLIC.JSON_RAW with MANAGE_DB.PUBLIC.JSON_RAW ;

USE MANAGE_DB;
SELECT 
    RAW_FILE:spoken_languages as spoken_languages
FROM MANAGE_DB.PUBLIC.JSON_RAW ;

SELECT * FROM MANAGE_DB.PUBLIC.JSON_RAW ;
DESCRIBE TABLE MANAGE_DB.PUBLIC.JSON_RAW ;

SELECT 
     array_size(RAW_FILE:spoken_languages) as spoken_languages
FROM MANAGE_DB.PUBLIC.JSON_RAW ;


SELECT 
     RAW_FILE:first_name::STRING as first_name,
     array_size(RAW_FILE:spoken_languages) as spoken_languages
FROM MANAGE_DB.PUBLIC.JSON_RAW ;


SELECT 
    RAW_FILE:spoken_languages[0] as First_language
FROM MANAGE_DB.PUBLIC.JSON_RAW ;


SELECT 
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:spoken_languages[0] as First_language
FROM MANAGE_DB.PUBLIC.JSON_RAW ;


SELECT 
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as First_language,
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW ;


SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as First_language,
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[1].language::STRING as First_language,
    RAW_FILE:spoken_languages[1].level::STRING as Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW 
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[2].language::STRING as First_language,
    RAW_FILE:spoken_languages[2].level::STRING as Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW 
ORDER BY ID;




SELECT
    RAW_FILE:first_name::STRING AS First_name,
    f.value:language::STRING AS First_language,
    f.value:level::STRING AS Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW,
     LATERAL FLATTEN(input => RAW_FILE:spoken_languages) f;