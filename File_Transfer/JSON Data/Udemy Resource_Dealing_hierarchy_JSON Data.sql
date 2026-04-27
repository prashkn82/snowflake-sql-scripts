-- Dealing with HIERARCHY JSON DATA &  LATERAL FLATTEN FUCNTION
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

-- This query processes JSON hierarchical data Name wise & also counts the number of Languages.
SELECT 
     RAW_FILE:first_name::STRING as first_name,
     array_size(RAW_FILE:spoken_languages) as spoken_languages
FROM MANAGE_DB.PUBLIC.JSON_RAW ;

-- This query processes JSON hierarchical data indexing-wise.
-- Accesses the first object inside the spoken_languages array
SELECT 
    RAW_FILE:spoken_languages[0] as First_language
FROM MANAGE_DB.PUBLIC.JSON_RAW ;

-- This will gives you only the first lange with the Corresponding Names
-- However it stil fails to provide the other languages if it exists. 
SELECT 
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:spoken_languages[0] as First_language
FROM MANAGE_DB.PUBLIC.JSON_RAW ;


-- This query extracts the first name and the FIRST spoken language details
SELECT 
    RAW_FILE:first_name::STRING as First_name,                        -- Extract first name from JSON and cast to STRING
    RAW_FILE:spoken_languages[0].language::STRING as First_language,  -- Access first element in spoken languages array, then get 'language'
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken        -- Access first element in spoken languages array, then get 'level'
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
ORDER BY ID

-- This query manually extracts up to three elements from the spoken_languages JSON array using fixed indexes ([0], [1], [2]) and combines them using UNION ALL, effectively turning selected array elements into separate rows while ignoring any additional languages beyond the third position.
-- Using UNION ALL in this way is a manual and rigid approach to simulate array unnesting, but it is not scalable or efficient because it only handles a fixed number of elements and should be replaced with FLATTEN for dynamic and complete data extraction.
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as First_language,
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW
WHERE RAW_FILE:spoken_languages[0].language IS NOT NULL
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[1].language::STRING as First_language,
    RAW_FILE:spoken_languages[1].level::STRING as Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW 
WHERE RAW_FILE:spoken_languages[1].language IS NOT NULL
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[2].language::STRING as First_language,
    RAW_FILE:spoken_languages[2].level::STRING as Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW 
WHERE RAW_FILE:spoken_languages[2].language IS NOT NULL
ORDER BY ID

-- LATERAL FLATTEN converts JSON arrays into relational rows while preserving the parent record context.

SELECT 
    RAW_FILE:id::int AS id,                          -- Extracts and casts the 'id' field from JSON
    RAW_FILE:first_name::STRING AS first_name,       -- Extracts the first_name from JSON object
    lang.value:language::STRING AS language,         -- From each flattened array element, extracts 'language'
    lang.value:level::STRING AS level_spoken         -- From each flattened array element, extracts 'level'
FROM MANAGE_DB.PUBLIC.JSON_RAW,                     -- Base table containing JSON data
LATERAL FLATTEN(input => RAW_FILE:spoken_languages) lang;  -- LATERAL FLATTEN explodes the 'spoken_languages' array into multiple rows
                                                     -- Each element in the array becomes a separate row while still linked to the parent record


SELECT
    RAW_FILE:id::int AS id, 
    RAW_FILE:first_name::STRING AS First_name,
    f.value:language::STRING AS First_language,
    f.value:level::STRING AS Level_spoken
FROM MANAGE_DB.PUBLIC.JSON_RAW,
     LATERAL FLATTEN(input => RAW_FILE:spoken_languages) f;


-- Name should appear once and rest should show in rows
-- Use aggregation - ARRAY_AGG
SELECT 
    RAW_FILE:id::int AS id,
    RAW_FILE:first_name::STRING AS first_name,

    ARRAY_AGG(lang.value:language::STRING) AS languages,
    ARRAY_AGG(lang.value:level::STRING) AS levels
FROM MANAGE_DB.PUBLIC.JSON_RAW,
LATERAL FLATTEN(input => RAW_FILE:spoken_languages) lang
GROUP BY 
    RAW_FILE:id,
    RAW_FILE:first_name
ORDER BY id;


-- Hybrid Version

WITH flattened AS (
    SELECT 
        RAW_FILE:id::int AS id,
        RAW_FILE:first_name::STRING AS first_name,
        lang.index AS lang_index,  -- position in array (0,1,2...)
        lang.value:language::STRING AS language,
        lang.value:level::STRING AS level_spoken
    FROM MANAGE_DB.PUBLIC.JSON_RAW,
    LATERAL FLATTEN(input => RAW_FILE:spoken_languages) lang
)

SELECT 
    id,
    first_name,

    -- Primary language (first element in array)
    MAX(CASE WHEN lang_index = 0 THEN language END) AS primary_language,
    MAX(CASE WHEN lang_index = 0 THEN level_spoken END) AS primary_level,

    -- All other languages grouped together
    ARRAY_AGG(
        CASE WHEN lang_index > 0 THEN language END
    ) WITHIN GROUP (ORDER BY lang_index) AS other_languages,

    ARRAY_AGG(
        CASE WHEN lang_index > 0 THEN level_spoken END
    ) WITHIN GROUP (ORDER BY lang_index) AS other_levels

FROM flattened
GROUP BY id, first_name
ORDER BY id;


/* In short, 
Want analysis / relational structure → use FLATTEN
Want presentation/summary per user → use GROUP BY + ARRAY_AGG
*/