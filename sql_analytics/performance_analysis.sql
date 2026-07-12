-- Analyze the yearly performance of products by comparing each products sales to both
-- It's average sales performance and the previous year's sales
WITH yearly_product_sales AS (
SELECT YEAR(order_date) AS order_year,
product_name,
SUM(sales_amount) current_sales
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
YEAR(order_date), 
product_name
)
SELECT order_year, product_name, current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales, 
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
    WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
    ELSE 'Avg'
END avg_change,
-- Year-Over-Year Analysis
LAG(current_Sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
current_sales - LAG(current_Sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE
	WHEN current_sales -  LAG(current_Sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
    WHEN current_sales -  LAG(current_Sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
    ELSE 'No Change'
END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;



-- Month-Over-Month Analysis
WITH monthly_product_sales AS (
SELECT YEAR(order_date) AS order_year, 
MONTH(order_date) AS order_month,
product_name,
SUM(sales_amount) current_sales
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
YEAR(order_date), 
MONTH(order_date), 
product_name
)
SELECT order_year,
order_month,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE
	WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
    WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
    ELSE 'Avg'
END AS avg_change,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year, order_month) AS py_sales,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year, order_month) AS diff_py,
CASE
	WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year, order_month) > 0 THEN 'Increase'
    WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year, order_month) < 0 THEN 'Decrease'
    ELSE 'No Change'
END AS avg_change
FROM monthly_product_sales
ORDER BY product_name, order_year, order_month;