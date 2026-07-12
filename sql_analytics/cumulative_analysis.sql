-- Running Total of Sales by Year & Moving Average Price
WITH running_total_cte AS (
SELECT
YEAR(order_date) order_year,
SUM(sales_amount) total_sales,
AVG(price) avg_price
FROM fact_sales_staging
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
)
SELECT order_year,
total_sales,
SUM(total_sales) OVER(ORDER BY order_year) AS running_total_sales,
AVG(avg_price) OVER(ORDER BY order_year) AS moving_avg_price
FROM running_total_cte;



-- Running Total of Sales by Month
WITH month_running_total_cte AS (
SELECT SUBSTRING(order_date, 1, 7) order_date,
SUM(sales_amount) total_sales
FROM fact_sales_staging
WHERE order_date IS NOT NULL
GROUP BY SUBSTRING(order_date, 1, 7)
)
SELECT order_date, total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
FROM month_running_total_cte;



-- Running Total of Sales by Month and Year
WITH month_running_total_cte AS (
SELECT SUBSTRING(order_date, 1, 7) order_date,
SUM(sales_amount) total_sales
FROM fact_sales_staging
WHERE order_date IS NOT NULL
GROUP BY SUBSTRING(order_date, 1, 7)
)
SELECT order_date, total_sales,
SUM(total_sales) OVER(PARTITION BY SUBSTRING(order_date, 1, 4) ORDER BY order_date) AS running_total_sales
FROM month_running_total_cte;



-- Moning Average of Sales by Month
WITH moving_avg_sales_cte AS (
SELECT 
SUBSTRING(order_date, 1, 7) order_date,
AVG(sales_amount) avg_sales
FROM fact_sales_staging
WHERE order_date IS NOT NULL
GROUP BY SUBSTRING(order_date, 1, 7)
)
SELECT order_date, avg_sales,
AVG(avg_sales) OVER(ORDER BY order_date) moving_avg_sales
FROM moving_avg_sales_cte;