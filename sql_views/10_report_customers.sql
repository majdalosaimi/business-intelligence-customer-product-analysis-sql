/*
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
*/

CREATE VIEW report_customers AS
WITH base_query AS (
-- 1) Basic query to retrieve core columns for tables
SELECT order_number, product_key, 
order_date, sales_amount, quantity,
c.customer_key, customer_number,
CONCAT(first_name, ' ', last_name) AS customer_name,
TIMESTAMPDIFF(year, birthdate, CURDATE()) AS age
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c
	ON f.customer_key = c.customer_key
WHERE birthdate IS NOT NULL AND order_date IS NOT NULL
),
customer_aggregation AS (
-- 2) Customer Aggregations: Summarizes key metrics at the customer level
SELECT customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT product_key) AS total_products,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
MAX(order_date) AS last_order_date,
TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_in_months
FROM base_query
GROUP BY  customer_key,
customer_number,
customer_name,
age
)
--   3) Final Query: Combines all customer results into one output
SELECT customer_key,
customer_number,
customer_name,
age,
CASE
	WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 AND 29 THEN '20-29'
    WHEN age BETWEEN 30 AND 39 THEN '30-39'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    ELSE '50 and Above'
END AS age_group,
CASE
	WHEN lifespan_in_months >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan_in_months >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
last_order_date,
TIMESTAMPDIFF(month, last_order_date, CURDATE()) AS recency_in_months,
lifespan_in_months,
total_orders,
total_products,
total_sales,
total_quantity,
-- Average order value (AOV)
CASE
	WHEN total_orders = 0 THEN 0
    ELSE ROUND(total_sales / total_orders, 2)
END AS avg_order_value,
-- Average monthly spend
CASE
	WHEN lifespan_in_months = 0 THEN total_sales
    ELSE ROUND(total_sales / lifespan_in_months, 2)
END AS avg_monthly_spend
FROM customer_aggregation;

SELECT *
FROM report_customers;
