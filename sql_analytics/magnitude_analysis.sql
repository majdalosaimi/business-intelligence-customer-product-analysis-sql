-- Total Sales by Country
SELECT country, SUM(sales_amount) AS Total_Sales
FROM fact_sales_staging AS f
LEFT JOIN dim_customers_staging AS c
	ON f.customer_key = c.customer_key
GROUP BY country
ORDER BY Total_Sales DESC;

-- Total Customers by Country
SELECT country, COUNT(customer_key) AS Total_Customers
FROM dim_customers_staging
GROUP BY country
ORDER BY 2 DESC;

-- Distribution of Sold Items Accross Countries
SELECT country, SUM(quantity) Total_Sold_Items
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c
	ON f.customer_key = c.customer_key
GROUP BY country;

-- Total Customers by Gender
SELECT gender, COUNT(customer_key) AS Total_Customers
FROM dim_customers_staging
GROUP BY gender
ORDER BY 2 DESC;

-- Total Product by Category
SELECT category, COUNT(product_key) Total_Products
FROM dim_products_staging
GROUP BY category;

-- Average Cost by Category
SELECT category, ROUND(AVG(cost), 1) avg_costs
FROM dim_products_staging
GROUP BY category
ORDER BY avg_costs DESC;

-- Total Revenue by Category
SELECT category, SUM(sales_amount) Revenue
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY category
ORDER BY Revenue DESC;

-- Total Quantity by Category
SELECT category, SUM(quantity) AS Total_Quantity
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY category
ORDER BY Total_Quantity DESC;

-- Avg Price by Product
SELECT product_name, ROUND(AVG(price), 1) avg_price
FROM fact_sales_staging f
LEFT JOIN dim_products_staging p
	ON f.product_key = p.product_key
GROUP BY product_name
ORDER BY avg_price DESC;

-- Total Revenue by Customer
SELECT 
c.customer_key,
first_name,
last_name,
SUM(sales_amount) Revenue
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key, first_name, last_name
ORDER BY Revenue DESC;

-- Total Orders by Customer
SELECT customer_number, COUNT(DISTINCT order_number) as Total_Orders
FROM fact_sales_staging f
LEFT JOIN dim_customers_staging c
	ON f.customer_key = c.customer_key
GROUP BY customer_number
ORDER BY Total_Orders DESC;