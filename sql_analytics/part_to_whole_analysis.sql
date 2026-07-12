-- Which categories contribute the most to overall sales?
WITH category_sales AS (
SELECT category,
SUM(sales_amount) AS total_sales
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY category
)
SELECT category, 
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2), '%') AS percentage_of_total_sales
FROM category_sales
ORDER BY total_sales DESC;



-- Which products brings most customers?
WITH product_ncustomers AS (
SELECT product_name,
COUNT(customer_key) AS total_customers
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY product_name
)
SELECT product_name,
total_customers,
SUM(total_customers) OVER() AS overall_customers,
CONCAT(ROUND((total_customers / SUM(total_customers) OVER()) * 100, 2), '%') AS percentage_of_total_cust
FROM product_ncustomers
ORDER BY total_customers DESC;



-- Which countries contribute the most to overall sold items?
WITH country_qnt AS (
SELECT country,
SUM(quantity) AS total_quantity
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c 
	ON f.customer_key = c.customer_key
GROUP BY country
)
SELECT country,
total_quantity,
SUM(total_quantity) OVER() AS overall_qnt,
CONCAT(ROUND((total_quantity / SUM(total_quantity) OVER()) * 100, 2), '%') AS percentage_of_total_qnt
FROM country_qnt
ORDER BY total_quantity DESC;