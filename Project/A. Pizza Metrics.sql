-- A. Pizza Metrics
--- 1. How many pizzas were ordered?
SELECT COUNT(*) AS PIZZAS_ORDERED 
FROM CUSTOMER_ORDERS;

--- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT ORDER_ID) AS UNIQUE_CUSTOMER_ORDERS
FROM CUSTOMER_ORDERS;

--- 3. How many successful orders were delivered by each runner?
SELECT RUNNER_ID, COUNT (RO.ORDER_ID) AS SUCCESSFUL_ORDERS 
FROM RUNNER_ORDERS RO 
WHERE PICKUP_TIME <> 'NULL' 
GROUP BY RUNNER_ID;

--- 4. How many of each type of pizza was delivered?
SELECT PN.PIZZA_NAME, COUNT(CO.PIZZA_ID) AS PIZZAS_DELIVERED
FROM RUNNER_ORDERS RO 
INNER JOIN CUSTOMER_ORDERS CO ON RO.ORDER_ID = CO.ORDER_ID
INNER JOIN PIZZA_NAMES PN ON CO.PIZZA_ID = PN.PIZZA_ID
WHERE PICKUP_TIME <> 'null' 
GROUP BY PN.PIZZA_NAME;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT C.CUSTOMER_ID,
SUM(CASE WHEN P.PIZZA_NAME ='Meatlovers' THEN 1 ELSE 0 END)AS MEAT_LOVERS_COUNT,
SUM(CASE WHEN P.PIZZA_NAME ='Vegetarian' THEN 1 ELSE 0 END)AS VEGETARIAN_COUNT
FROM CUSTOMER_ORDERS C JOIN PIZZA_NAMES P 
ON C.PIZZA_ID = P.PIZZA_ID
GROUP BY C.CUSTOMER_ID;


--- 6. What was the maximum number of pizzas delivered in a single order?
SELECT ORDER_ID, COUNT(PIZZA_ID) AS PIZZA_COUNT
FROM CUSTOMER_ORDERS
WHERE PIZZA_ID IS NOT NULL
GROUP BY ORDER_ID
ORDER BY PIZZA_COUNT DESC
LIMIT 1;


--- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
  CUSTOMER_ID, 
  SUM(CASE 
    WHEN 
        (
          (EXCLUSIONS IS NOT NULL AND EXCLUSIONS<>'null' AND LENGTH(EXCLUSIONS)>0) 
        AND (EXTRAS IS NOT NULL AND EXTRAS<>'null' AND LENGTH(EXTRAS)>0)
        )=TRUE
    THEN 1 
    ELSE 0
  END) AS CHANGES, 
  SUM(CASE 
    WHEN 
        (
          (EXCLUSIONS IS NOT NULL AND EXCLUSIONS<>'null' AND LENGTH(EXCLUSIONS)>0) 
        AND (EXTRAS IS NOT NULL AND EXTRAS<>'null' AND LENGTH(EXTRAS)>0)
        )=TRUE
    THEN 0 
    ELSE 1
  END) AS NO_CHANGES 
FROM 
  CUSTOMER_ORDERS AS CO 
  INNER JOIN RUNNER_ORDERS AS RO ON RO.ORDER_ID = CO.ORDER_ID 
WHERE 
  PICKUP_TIME<>'null'
GROUP BY 
  CUSTOMER_ID;


--- 8. How many pizzas were delivered that had both exclusions and extras? Thảo
SELECT 
  COUNT(PIZZA_ID) AS PIZZAS_DELIVERED_WITH_EXCLUSIONS_AND_EXTRAS 
FROM 
  CUSTOMER_ORDERS AS CO 
  INNER JOIN RUNNER_ORDERS AS RO ON RO.ORDER_ID = CO.ORDER_ID 
WHERE 
  PICKUP_TIME<>'null'
  AND (EXCLUSIONS IS NOT NULL AND EXCLUSIONS<>'null' AND LENGTH(EXCLUSIONS)>0) 
  AND (EXTRAS IS NOT NULL AND EXTRAS<>'null' AND LENGTH(EXTRAS)>0); 


--- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
  DATE_PART('HOUR', ORDER_TIME) AS HOUR, 
  COUNT(*) AS ORDERED_PIZZAS 
FROM 
  CUSTOMER_ORDERS 
GROUP BY 
  DATE_PART('HOUR', ORDER_TIME); 

--- 10. What was the volume of orders for each day of the week?
SELECT
    TO_CHAR(ORDER_TIME, 'DAY') AS DAY ,
    COUNT(*) AS ORDERED_PIZZAS
FROM
    CUSTOMER_ORDERS
GROUP BY
    TO_CHAR(ORDER_TIME, 'DAY');

