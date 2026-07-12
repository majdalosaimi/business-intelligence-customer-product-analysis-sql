-- Explore All Objects in the Database
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'data_warehouse_analytics';

-- Explore All Columns in the Database
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'data_warehouse_analytics';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';



-- Cleaning and Standardizing Data
/* Customer Table */
CREATE TABLE dim_customers_staging
LIKE dim_customers;

INSERT INTO dim_customers_staging
SELECT *
FROM dim_customers;

SELECT birthdate,
STR_TO_DATE(birthdate, '%Y-%m-%d') AS check_date
FROM dim_customers_staging
LIMIT 20;

UPDATE dim_customers_staging
SET birthdate = STR_TO_DATE(birthdate, '%Y-%m-%d');

ALTER TABLE dim_customers_staging
MODIFY COLUMN birthdate DATE;

ALTER TABLE dim_customers_staging
MODIFY COLUMN create_date DATE;

UPDATE dim_customers_staging
SET birthdate = NULL
WHERE birthdate = '0000-00-00';

/* Product Table */
CREATE TABLE dim_products_staging
LIKE dim_products;

INSERT INTO dim_products_staging
SELECT *
FROM dim_products;

ALTER TABLE dim_products_staging
MODIFY COLUMN start_date DATE;

/* Sales Table */
CREATE TABLE fact_sales_staging
LIKE fact_sales;

INSERT INTO fact_sales_staging
SELECT *
FROM fact_sales;

SELECT *
FROM fact_sales_staging;

SELECT order_date,
STR_TO_DATE(order_date, '%Y-%m-%d') AS check_date
FROM fact_sales_staging
LIMIT 20;

UPDATE fact_sales_staging
SET order_date = STR_TO_DATE(order_date, '%Y-%m-%d');

ALTER TABLE fact_sales_staging
MODIFY COLUMN order_date DATE;

ALTER TABLE fact_sales_staging
MODIFY COLUMN shipping_date DATE;

ALTER TABLE fact_sales_staging
MODIFY COLUMN due_date DATE;

UPDATE fact_sales_staging
SET order_date = NULL
WHERE order_date = '0000-00-00';



-- Dimensions Exploration
SELECT country, COUNT(customer_id)
FROM dim_customers_staging
GROUP BY country;

SELECT DISTINCT category, subcategory, product_name
FROM dim_products_staging
ORDER BY category;

SELECT DISTINCT product_line
FROM dim_products_staging;



-- Date Exploration
SELECT MIN(create_date), MAX(create_date)
FROM dim_customers_staging;

SELECT MAX(birthdate) AS youngest_birthdate,
TIMESTAMPDIFF(YEAR, MAX(birthdate), CURDATE()) AS youngest_age,
MIN(birthdate) AS oldest_birthdate,
TIMESTAMPDIFF(YEAR, MIN(birthdate), CURDATE()) AS oldest_age
FROM dim_customers_staging
WHERE birthdate IS NOT NULL;

SELECT DISTINCT YEAR(birthdate)
FROM dim_customers_staging;

SELECT MIN(start_date), MAX(start_date)
FROM dim_products_staging;

SELECT MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
TIMESTAMPDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM fact_sales_staging
WHERE order_date IS NOT NULL;



-- Measures Exploration
SELECT SUM(cost) AS total_cost, /* Product Cost*/
ROUND(AVG(cost),2) AS avg_cost
FROM dim_products_staging;

SELECT SUM(sales_amount) total_sales, /* Total Sales */
ROUND(AVG(sales_amount),2) AS avg_sales
FROM fact_sales_staging;

SELECT 
ROUND(AVG(price),2) AS avg_price, /* Avg Selling Price */
MAX(price) highest_price,
MIN(price) lowest_price
FROM fact_sales_staging;

SELECT SUM(quantity) total_quantity /* how many item are sold? */ 
FROM fact_sales_staging;

SELECT sales_amount, (price * quantity) as check_sales
FROM fact_sales_staging
ORDER BY 1 DESC, 2 DESC;

SELECT COUNT(customer_key) AS total_customers /* Total Number of Customers */
FROM dim_customers_staging;

SELECT COUNT(product_key) AS total_products /* Total Number of Products */
FROM dim_products_staging;

SELECT COUNT(order_number) AS total_orders 
FROM fact_sales_staging;
SELECT COUNT(DISTINCT order_number) AS total_orders /* Total Number of Orders */
FROM fact_sales_staging;

SELECT COUNT(DISTINCT customer_key) AS num_customer_who_orders /* Total Number of Customers who place order */
FROM fact_sales_staging;