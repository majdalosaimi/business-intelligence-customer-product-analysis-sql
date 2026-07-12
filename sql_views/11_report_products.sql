/*
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
*/

CREATE VIEW report_products AS
WITH product_base_query AS (
-- 1) Basic query to retrieve core columns for tables
SELECT order_number,
customer_key,
order_date,
sales_amount,
quantity,
p.product_key,
product_number,
product_name,
category,
subcategory,
cost
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
WHERE order_date IS NOT NULL -- valid sales dates
),
product_aggregation AS (
-- 2) Product Aggregations: Summarizes key metrics at the customer level
SELECT product_key,
product_number,
product_name,
category,
subcategory,
cost,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) AS total_customer,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
MAX(order_date) AS last_sale_date,
TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_in_months,
ROUND(sales_amount / NULLIF(quantity, 0), 2) AS avg_selling_price
FROM product_base_query
GROUP BY  product_key,
product_number,
product_name,
category,
subcategory,
cost
)
--   3) Final Query: Combines all product results into one output
SELECT 
product_key,
product_number,
product_name,
category,
subcategory,
cost,
CASE
	WHEN total_sales > 50000 THEN 'High-Performer'
    WHEN total_sales >= 10000 THEN 'Mid-Range'
    ELSE 'Low-Performer'
END AS product_segment,
last_sale_date,
TIMESTAMPDIFF(month, last_sale_date, CURDATE()) AS recency_in_months,
lifespan_in_months,
total_orders,
total_customer,
total_sales,
total_quantity,
avg_selling_price,
-- Average order revenue (AOR)
CASE
	WHEN total_orders = 0 THEN 0
    ELSE ROUND(total_sales / total_orders, 2)
END AS avg_order_revenue,
-- Average monthly revenue
CASE
	WHEN lifespan_in_months = 0 THEN total_sales
    ELSE ROUND(total_sales / lifespan_in_months, 2)
END AS avg_monthly_revenue
FROM product_aggregation;

SELECT *
FROM report_products;
