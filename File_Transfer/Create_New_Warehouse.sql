-- Exercise from Udemy Workshop
-- To Create a New Warehouse 'EXERCISE_WH'

USE ROLE SYSADMIN;
CREATE OR REPLACE WAREHOUSE EXERCISE_WH
WAREHOUSE_SIZE = XSMALL
MIN_CLUSTER_COUNT = 1
MAX_CLUSTER_COUNT = 3
AUTO_SUSPEND = 600  -- automatically suspend the virtual warehouse after 10 minutes of not being used
AUTO_RESUME = TRUE 
COMMENT = 'This is a virtual warehouse of size X-SMALL that can be used to process queries.';

-- Drop Warehouse
DROP WAREHOUSE EXERCISE_WH;