-- How Total Sales Changes Over Time?
SELECT 
YEAR(order_date) order_year, 
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers, 
SUM(quantity) total_quantity
FROM fact_sales_staging
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

SELECT 
YEAR(order_date) order_year,
MONTH(order_date) order_month, 
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers, 
SUM(quantity) total_quantity
FROM fact_sales_staging
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

SELECT 
SUBSTRING(order_date, 1, 7) order_date, 
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers, 
SUM(quantity) total_quantity
FROM fact_sales_staging
WHERE order_date IS NOT NULL
GROUP BY SUBSTRING(order_date, 1, 7)
ORDER BY SUBSTRING(order_date, 1, 7);

