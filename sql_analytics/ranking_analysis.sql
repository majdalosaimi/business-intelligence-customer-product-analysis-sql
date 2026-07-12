-- Which 5 Produsts generate the Highest Revenue?
SELECT
product_name,
SUM(sales_amount) Revenue
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY product_name
ORDER BY Revenue DESC
LIMIT 5;

-- Which 5 worst-performing Produsts in term of sales?
SELECT
product_name,
SUM(sales_amount) Revenue
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY product_name
ORDER BY Revenue ASC
LIMIT 5;

-- Which 5 subProdusts generate the Highest Revenue?
SELECT
subcategory,
SUM(sales_amount) Revenue,
DENSE_RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS rank_products
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY subcategory
LIMIT 5;

-- Top 10 Customer who have generate the Highest Revenue?
SELECT 
c.customer_key,
first_name,
last_name,
SUM(sales_amount) Revenue
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key, first_name, last_name
ORDER BY Revenue DESC
LIMIT 10;

-- 3 Customer with the fewest order placed
SELECT 
c.customer_key, 
first_name,
last_name,
COUNT(DISTINCT order_number) as Total_Orders
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key,
first_name,
last_name
ORDER BY Total_Orders ASC
LIMIT 3;