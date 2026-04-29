-- INSERT FLATTENED JSON DATA INTO TABLE
-- Replace OUR_FIRST_DB.PUBLIC.JSON_RAW with MANAGE_DB.PUBLIC.JSON_RAW ;


--// Option 1: CREATE TABLE AS
USE MANAGE_DB;
CREATE OR REPLACE TABLE Languages AS
select
      RAW_FILE:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from MANAGE_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;

SELECT * FROM Languages;

truncate table languages;

// Option 2: INSERT INTO

INSERT INTO languages
select
      RAW_FILE:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from MANAGE_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;

SELECT * FROM Languages;
