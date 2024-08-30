-- 1.CTEs and Subqueries: I used Common Table Expressions (CTEs) and subqueries for organized and modular SQL queries.
-- 2.Aggregations and Grouping: I applied functions like COUNT, ROUND, and GROUP BY to analyze customer data and calculate percentages.
-- 3.Date Functions: I leveraged DATEDIFF, DATE_TRUNC, and YEAR to perform time-based data analysis and customer behavior tracking.

WITH FULL_TABLE AS(
SELECT subscriptions.* , plans.*EXCLUDE(PLAN_ID)
FROM subscriptions
LEFT JOIN plans ON subscriptions.PLAN_ID = plans.PLAN_ID )

-- How many customers has Foodie-Fi ever had?

    -- SELECT COUNT(DISTINCT CUSTOMER_ID)
    -- FROM subscriptions
    
    -- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
    
    -- SELECT DATE_TRUNC('mm', start_date) AS MONTH, COUNT(customer_id)
    -- FROM FULL_TABLE 
    -- WHERE plan_name = 'trial'
    -- GROUP BY MONTH
    
    -- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
    
    -- SELECT plan_name, COUNT(*) as NUMBER
    -- FROM FULL_TABLE
    -- WHERE YEAR(start_date) > 2020
    -- GROUP BY plan_name

-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

    --     , CHURN_CUSTOMERS AS(
    --     SELECT COUNT(DISTINCT customer_id) AS CHURN_CUSTOMER_COUNT
    --     FROM full_table
    --     WHERE plan_name= 'churn')
        
    --     ,ALL_CUSTOMERS AS(
    --     SELECT COUNT(DISTINCT customer_id) AS ALL_CUSTOMER_COUNT
    --     FROM full_table )
    
    --     SELECT CHURN_CUSTOMER_COUNT, ROUND((CHURN_CUSTOMER_COUNT/ALL_CUSTOMER_COUNT)*100, 1) AS PERCENT_OF_CHURN_CUSTOMERS
    --     FROM CHURN_CUSTOMERS
    --     JOIN ALL_CUSTOMERS ON 1=1
    -- LIMIT 5

-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
    -- , CHURN_CUSTOMERS AS(
    -- SELECT *EXCLUDE(start_date, price), start_date AS CHURN_START
    -- FROM full_table
    -- WHERE plan_name = 'churn' )

    --     ,TRIAL_CUSTOMERS AS(
    -- SELECT *EXCLUDE(start_date, price), start_date AS TRIAL_START
    -- FROM full_table 
    -- WHERE plan_name = 'trial' )
    
    -- ,ALL_CUSTOMERS AS(
    -- SELECT COUNT(DISTINCT customer_id) AS ALL_CUSTOMER_COUNT
    -- FROM full_table )

    -- , TRIAL_TO_CHURN AS( 
    -- SELECT COUNT(*) AS TRIAL_TO_CHURN_COUNT
    -- FROM CHURN_CUSTOMERS
    -- JOIN TRIAL_CUSTOMERS ON 1=1
    -- WHERE DATEDIFF('day',CHURN_START, TRIAL_START) = 0 )

    -- SELECT TRIAL_TO_CHURN_COUNT, ROUND(TRIAL_TO_CHURN_COUNT/ALL_CUSTOMER_COUNT*100,1) AS PERCENT
    -- FROM TRIAL_TO_CHURN
    -- JOIN ALL_CUSTOMERS ON 1=1
    -- LIMIT 5

-- What is the number and percentage of customer plans after their initial free trial?

    --     ,NON_TRIAL_CUSTOMERS AS(
    -- SELECT *EXCLUDE(start_date, price), start_date AS NON_TRIAL_START
    -- FROM full_table 
    -- WHERE plan_name != 'trial') 

    --     ,TRIAL_CUSTOMERS AS(
    -- SELECT *EXCLUDE(start_date, price), start_date AS TRIAL_START
    -- FROM full_table 
    -- WHERE plan_name = 'trial')

    --     ,ALL_CUSTOMERS AS(
    -- SELECT COUNT(*) AS ALL_CUSTOMER_COUNT
    -- FROM full_table )

    -- , TRIAL_TO_NON_TRIAL AS( 
    -- SELECT COUNT(*) AS TRIAL_TO_NON_TRIAL_COUNT
    -- FROM NON_TRIAL_CUSTOMERS
    -- JOIN TRIAL_CUSTOMERS ON NON_TRIAL_CUSTOMERS.customer_id = TRIAL_CUSTOMERS.customer_id
    -- WHERE DATEDIFF('day', TRIAL_START, NON_TRIAL_START) > 0)

    --     SELECT TRIAL_TO_NON_TRIAL_COUNT, ROUND(TRIAL_TO_NON_TRIAL_COUNT/ALL_CUSTOMER_COUNT*100,1) AS PERCENT
    -- FROM TRIAL_TO_NON_TRIAL
    -- JOIN ALL_CUSTOMERS ON 1=1
    -- LIMIT 5

-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

    --         ,ALL_CUSTOMERS AS(
    -- SELECT COUNT(*) AS ALL_CUSTOMER_COUNT
    -- FROM full_table 
    -- WHERE TO_DATE('2020-12-31') <= start_date)

    --             ,SPLIT_CUSTOMERS AS(
    -- SELECT SUM(
    --     CASE 
    --     WHEN TO_DATE('2020-12-31') <= start_date
    --     THEN 1
    --     ELSE 0
    --     END) AS SPLIT_CUSTOMER_COUNT, plan_name
    -- FROM full_table 
    -- GROUP BY plan_name)

    -- SELECT plan_name, SPLIT_CUSTOMER_COUNT, ROUND(SPLIT_CUSTOMER_COUNT/ALL_CUSTOMER_COUNT*100,1) AS PERCENT_OF_TOTAL
    -- FROM ALL_CUSTOMERS
    -- JOIN SPLIT_CUSTOMERS ON 1=1
    -- LIMIT 5

-- How many customers have upgraded to an annual plan in 2020?

    -- SELECT COUNT(DISTINCT CUSTOMER_ID) AS ANNUAL_CUSTOMERS_COUNT
    -- FROM FULL_TABLE
    -- WHERE plan_name = 'pro annual' AND YEAR(start_date) = 2020

-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

    --     ,NEW_CUSTOMERS AS(
    -- SELECT customer_id, MIN(start_date) AS FIRST_START
    -- FROM full_table 
    -- GROUP BY customer_id)

    --     ,ANNUAL_CUSTOMERS AS(
    -- SELECT *EXCLUDE(start_date, price), start_date AS ANNUAL_START
    -- FROM FULL_TABLE
    -- WHERE plan_name = 'pro annual')

    -- SELECT AVG(DATEDIFF('day',FIRST_START,ANNUAL_START)) AS AVG_DAYS_TO_UPGRADE
    -- FROM NEW_CUSTOMERS
    -- INNER JOIN ANNUAL_CUSTOMERS ON NEW_CUSTOMERS.customer_id = ANNUAL_CUSTOMERS.customer_id
    -- LIMIT 5

-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

    --     ,NEW_CUSTOMERS AS(
    -- SELECT customer_id, MIN(start_date) AS FIRST_START
    -- FROM full_table 
    -- GROUP BY customer_id)

    --     ,ANNUAL_CUSTOMERS AS(
    -- SELECT *EXCLUDE(start_date, price), start_date AS ANNUAL_START
    -- FROM FULL_TABLE
    -- WHERE plan_name = 'pro annual')

    -- SELECT AVG(DATEDIFF('day',FIRST_START,ANNUAL_START)) AS AVG_DAYS_TO_UPGRADE, TO_VARCHAR(FLOOR(((DATEDIFF('day',FIRST_START,ANNUAL_START))-1)/30)) AS BIN
    -- FROM NEW_CUSTOMERS
    -- INNER JOIN ANNUAL_CUSTOMERS ON NEW_CUSTOMERS.customer_id = ANNUAL_CUSTOMERS.customer_id
    -- GROUP BY BIN

-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

        ,MONTH_CUSTOMERS AS(
    SELECT *EXCLUDE(start_date, price), start_date AS MONTH_START
    FROM full_table 
    WHERE plan_name = 'pro monthly'
    AND YEAR(MONTH_START) = 2020)

        ,ANNUAL_CUSTOMERS AS(
    SELECT *EXCLUDE(start_date, price), start_date AS ANNUAL_START
    FROM full_table 
    WHERE plan_name = 'pro annual'
    AND YEAR(ANNUAL_START) = 2020)

    SELECT *
    FROM MONTH_CUSTOMERS
    JOIN ANNUAL_CUSTOMERS ON MONTH_CUSTOMERS.customer_id = ANNUAL_CUSTOMERS.customer_id
    WHERE ANNUAL_START <= MONTH_START
    LIMIT 5


    
