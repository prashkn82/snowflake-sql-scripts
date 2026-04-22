//Rename data base & creating the table + meta data

ALTER DATABASE DEMO_DB RENAME TO OUR_FIRST_DEMO_DB

CREATE TABLE "OUR_FIRST_DEMO_DB"."PUBLIC"."LOAN_PAYMENT" (
  "Loan_ID" STRING,
  "loan_status" STRING,
  "Principal" STRING,
  "terms" STRING,
  "effective_date" STRING,
  "due_date" STRING,
  "paid_off_time" STRING,
  "past_due_days" STRING,
  "age" STRING,
  "education" STRING,
  "Gender" STRING);

SHOW TABLES;
  
 //Check that table is empy
 USE DATABASE OUR_FIRST_DEMO_DB;

 SELECT * FROM LOAN_PAYMENT;

 
 //Loading the data from S3 bucket
  
 COPY INTO LOAN_PAYMENT
    FROM s3://bucketsnowflakes3/Loan_payments_data.csv
    file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);
    

//Validate
 SELECT * FROM LOAN_PAYMENT;


desc table customer
desc table LINEITEM
desc table  NATION
desc table ORDERS
desc table PART
desc table PARTSUPP
desc table REGION
desc table SUPPLIER

SELECT count(*) FROM customer;
SELECT count(*) FROM LINEITEM;
SELECT count(*)  FROM NATION;
SELECT count(*)  FROM ORDERS;
SELECT count(*)  FROM PART;
SELECT count(*)  FROM PARTSUPP;
SELECT count(*)  FROM REGION;
SELECT count(*)  FROM  SUPPLIER

Drop table customer;
Drop table LINEITEM;
Drop table Nation;
Drop table Part;
Drop table Partsupp;
Drop table Region;
Drop table Supplier;

Show databases;
Use database OUR_FIRST_DEMO_DB;
show tables;