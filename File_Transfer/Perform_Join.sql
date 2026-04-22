SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
SHOW WAREHOUSES;

ALTER WAREHOUSE UDEMY_MASTERCLASS_WAREHOUSE
SET AUTO_SUSPEND = 600; 

SELECT CURRENT_TIMESTAMP;

describe TABLE  SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
desc table customer
desc table LINEITEM
desc table  NATION
desc table ORDERS
desc table PART
desc table PARTSUPP
desc table REGION
desc table SUPPLIER

SELECT * FROM customer;
SELECT * FROM LINEITEM;
SELECT * FROM NATION;
SELECT * FROM ORDERS;
SELECT * FROM PART;
SELECT * FROM PARTSUPP;
SELECT * FROM REGION;
SELECT * FROM  SUPPLIER

SELECT count(*) FROM customer;
SELECT count(*) FROM LINEITEM;
SELECT count(*)  FROM NATION;
SELECT count(*)  FROM ORDERS;
SELECT count(*)  FROM PART;
SELECT count(*)  FROM PARTSUPP;
SELECT count(*)  FROM REGION;
SELECT count(*)  FROM  SUPPLIER



SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER

-- Scenario 1: Total Revenue by Region
-- Which region generates the most revenue?
-- Join Tables: REGION → NATION → CUSTOMER → ORDERS → LINEITEM

SELECT r.r_name as Country,
        TO_CHAR(
           ROUND(SUM(l.l_extendedprice * (1 - l.l_discount)),2),
           '$999,999,999,999.00'
       ) AS revenue
 FROM region r
JOIN nation n ON r.r_regionkey = n.n_regionkey
JOIN customer c ON c.c_nationkey = n.n_nationkey
JOIN orders o ON o.o_custkey = c.c_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
GROUP BY r.r_name
ORDER BY revenue;

-- Convert Revenue to K / M / B
SELECT r.r_name AS region,
       CASE
           WHEN SUM(l.l_extendedprice * (1 - l.l_discount)) >= 1000000000
                THEN TO_VARCHAR(ROUND(SUM(l.l_extendedprice * (1 - l.l_discount))/1000000000,2)) || ' B'
           WHEN SUM(l.l_extendedprice * (1 - l.l_discount)) >= 1000000
                THEN TO_VARCHAR(ROUND(SUM(l.l_extendedprice * (1 - l.l_discount))/1000000,2)) || ' M'
           WHEN SUM(l.l_extendedprice * (1 - l.l_discount)) >= 1000
                THEN TO_VARCHAR(ROUND(SUM(l.l_extendedprice * (1 - l.l_discount))/1000,2)) || ' K'
           ELSE TO_VARCHAR(ROUND(SUM(l.l_extendedprice * (1 - l.l_discount)),2))
       END AS revenue
FROM region r
JOIN nation n ON r.r_regionkey = n.n_regionkey
JOIN customer c ON c.c_nationkey = n.n_nationkey
JOIN orders o ON o.o_custkey = c.c_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
GROUP BY r.r_name
ORDER BY revenue;

-- Revenue Contribution Percentage by Region
SELECT r.r_name,
TO_VARCHAR(
    ROUND(
     SUM(l.l_extendedprice * (1 - l.l_discount)) /
       SUM(SUM(l.l_extendedprice * (1 - l.l_discount))) OVER () * 100,2)
       ) || '%' AS "revenue_%",
FROM region r
JOIN nation n ON r.r_regionkey = n.n_regionkey
JOIN customer c ON c.c_nationkey = n.n_nationkey
JOIN orders o ON o.o_custkey = c.c_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
GROUP BY r.r_name;


--Bonus: Top 5 Regions by Revenue
SELECT r.r_name,
   TO_CHAR(ROUND(SUM(l.l_extendedprice * (1 - l.l_discount)),2),'$999,999,999,999.00')  AS revenue,
   TO_VARCHAR(
        ROUND(
            SUM(l.l_extendedprice * (1 - l.l_discount)) /
            SUM(SUM(l.l_extendedprice * (1 - l.l_discount))) OVER () * 100,2)
       ) || '%' AS "revenue_%",
FROM region r
JOIN nation n ON r.r_regionkey = n.n_regionkey
JOIN customer c ON c.c_nationkey = n.n_nationkey
JOIN orders o ON o.o_custkey = c.c_custkey
JOIN lineitem l ON l.l_orderkey = o.o_orderkey
GROUP BY r.r_name
ORDER BY revenue DESC
FETCH FIRST 5 ROWS ONLY;

-- Scenario 2: Who are the most valuable customers?
-- Join Tables : CUSTOMER → ORDERS → LINEITEM

SELECT c.c_name as "Valuable Customer Name",
       SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM customer c
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
GROUP BY c.c_name
ORDER BY revenue DESC
LIMIT 5;

-- Scenario 3: Supplier Performance Analysis
-- Which supplier supplies the most products?
-- Join Tables: SUPPLIER → LINEITEM

SELECT s.s_name "Top Supplier Name",
       COUNT(*) AS total_shipments
FROM supplier s
JOIN lineitem l ON s.s_suppkey = l.l_suppkey
GROUP BY s.s_name
ORDER BY total_shipments DESC
Limit 5;

--Scenario 4: Product Sales Analysis
-- Which products generate the most revenue?
-- Join Tables: PART → LINEITEM
-- Helps identify best-selling products.

Select p_name from part

SELECT p.p_name as "Product Generated Name",
       SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM part p
JOIN lineitem l ON p.p_partkey = l.l_partkey
GROUP BY p.p_name
ORDER BY revenue DESC;

-- Scenario 5: Regional Supplier Analysis
-- Which region has the most suppliers?
-- Join Tables:REGION → NATION → SUPPLIER
-- Shows supplier distribution by region.

SELECT r.r_name as "Regional Country",
       COUNT(s.s_suppkey) AS supplier_count
FROM region r
JOIN nation n ON r.r_regionkey = n.n_regionkey
JOIN supplier s ON s.s_nationkey = n.n_nationkey
GROUP BY r.r_name;

-- Scenario 6: Advanced Analytical Scenario (Supply Chain)
-- Which supplier provides parts with the highest cost?
-- Join TablesSUPPLIER → PARTSUPP → PART

SELECT s.s_name as "Supplier Name", p.p_name "Product Name",
       ps.ps_supplycost
FROM supplier s
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN part p ON ps.ps_partkey = p.p_partkey
ORDER BY ps.ps_supplycost DESC;

--Most Important Join Keys (Memorize These)
*/
Customer → Orders
C_CUSTKEY = O_CUSTKEY

Orders → LineItem
O_ORDERKEY = L_ORDERKEY

Part → LineItem
P_PARTKEY = L_PARTKEY

Supplier → LineItem
S_SUPPKEY = L_SUPPKEY

Nation → Region
N_REGIONKEY = R_REGIONKEY

Customer/Supplier → Nation
C_NATIONKEY = N_NATIONKEY
S_NATIONKEY = N_NATIONKEY


-- Most queries start from:

-- LINEITEM (fact table) and join to dimensions like:

       -- CUSTOMER
        -- PART
        -- SUPPLIER
        -- NATION
        -- REGION

/*
