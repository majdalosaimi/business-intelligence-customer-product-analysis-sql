-- Report that shows all key metrics of the business
SELECT 'Total Sales' AS Measure_Name, SUM(sales_amount) AS Measure_Value
FROM fact_sales_staging
UNION ALL
SELECT 'Total Quantity' AS Measure_Name, SUM(quantity) AS Measure_Value
FROM fact_sales_staging
UNION ALL
SELECT 'Avg Price' AS Measure_Name, ROUND(AVG(price),2) AS Measure_Value
FROM fact_sales_staging
UNION ALL
SELECT 'Total Nr. Orders' AS Measure_Name, COUNT(DISTINCT order_number) AS Measure_Value
FROM fact_sales_staging
UNION ALL
SELECT 'Total Nr. Products' AS Measure_Name, COUNT(product_key) AS Measure_Value
FROM dim_products_staging
UNION ALL
SELECT 'Total Nr. Customers' AS Measure_Name, COUNT(customer_key) AS Measure_Value
FROM dim_customers_staging;