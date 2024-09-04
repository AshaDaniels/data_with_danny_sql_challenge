-- Skills demonstrated:
-- Data joining
-- Aggregation
-- Window functions

-- A. Customer Nodes Exploration

WITH INFO AS(
    SELECT R.REGION_NAME, N.*
    FROM REGIONS as R
    LEFT JOIN CUSTOMER_NODES as N ON R.REGION_ID = N.REGION_ID
)

-- How many unique nodes are there on the Data Bank system?
-- SELECT COUNT(DISTINCT NODE_ID) AS NODES
-- FROM INFO

-- What is the number of nodes per region?
-- SELECT COUNT(DISTINCT NODE_ID) AS NODES, REGION_NAME
-- FROM INFO
-- GROUP BY REGION_NAME

-- How many customers are allocated to each region?
-- SELECT COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS, REGION_NAME
-- FROM INFO
-- GROUP BY REGION_NAME

-- How many days on average are customers reallocated to a different node?
    -- , SUMMED_DAYS AS(
    -- SELECT SUM(DATEDIFF('day',start_date, end_date)) AS DAYS, CUSTOMER_ID, NODE_ID
    -- FROM INFO
    -- WHERE END_DATE != DATE('9999-12-31')
    -- GROUP BY NODE_ID, CUSTOMER_ID)

-- SELECT AVG(DAYS) AS AVG_DAYS, NODE_ID
-- FROM SUMMED_DAYS
-- GROUP BY NODE_ID
-- LIMIT 5

-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
    , SUMMED_DAYS AS(
    SELECT SUM(DATEDIFF('day',start_date, end_date)) AS DAYS, CUSTOMER_ID, node_id, REGION_NAME
    FROM INFO
    WHERE END_DATE != DATE('9999-12-31')
    GROUP BY REGION_NAME, node_id, CUSTOMER_ID)

    , PERCENTILE AS(
    SELECT DAYS, REGION_NAME,
    PERCENTILE_CONT(0.8) WITHIN 
        GROUP (ORDER BY DAYS) 
        OVER (PARTITION BY REGION_NAME)
        AS PERCENTILE_80,
    PERCENTILE_CONT(0.95) WITHIN 
        GROUP (ORDER BY DAYS) 
        OVER (PARTITION BY REGION_NAME)
        AS PERCENTILE_95,
    FROM SUMMED_DAYS
    )

    SELECT MEDIAN(DAYS), MAX(PERCENTILE_80), MAX(PERCENTILE_95), REGION_NAME
    FROM PERCENTILE
    GROUP BY REGION_NAME
    LIMIT 5
    

