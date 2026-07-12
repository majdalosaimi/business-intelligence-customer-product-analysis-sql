-- Segment products into costs ranges and 
-- count how many products fall into each segment
WITH product_segment AS (
SELECT product_name,
cost,
CASE
	WHEN cost < 100 THEN 'Below 100'
    WHEN cost BETWEEN 100 and 500 THEN '100-500'
    WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
    ELSE 'Above 1000'
END AS cost_range
FROM dim_products_staging
)
SELECT cost_range,
COUNT(*) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;



/* Group customers into 3 segments based on their spending behavior:
- VIP: at least 12 months of history and spending more than 5000.
- Regular: at least 12 months of history but spending 5000 or less.
- New: lifespan less 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS(
SELECT f.customer_key,
SUM(sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c
	ON f.customer_key = c.customer_key
GROUP BY f.customer_key
),
customer_segment_cte AS (
SELECT customer_key, 
CASE
	WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment
FROM customer_spending
)
SELECT customer_segment,
COUNT(customer_key) AS total_customers
FROM customer_segment_cte
GROUP BY customer_segment
ORDER BY total_customers DESC;