# Business Intelligence: Customer & Product Analytics (SQL)

## 📌 Project Overview
This project focuses on executing advanced exploratory data analysis (EDA) and driving strategic business decisions using a production-ready, clean dataset. Instead of data cleaning, the primary scope of this project is deep-dive business analysis and reporting optimization. 

To bridge the gap between raw tables and business reporting, key analytical metrics were materialized into reusable database **Views**. These views serve as a single source of truth for stakeholders and are structured to seamlessly connect with data visualization tools (like Tableau or Power BI).

## 📂 Repository Structure
- `datasets/`: Contains the clean dataset used for analysis.
- `sql_analytics/`: A collection of SQL scripts exploring various business operational metrics.
- `sql_views/`: Production-grade SQL scripts creating reporting views for high-level business insights.

## 📊 Analytical Focus & Key Metrics
The exploratory phase analyzed diverse segments of the business, answering critical questions regarding revenue distribution, transactional frequencies, and behavioral patterns.

## ⚙️ Production Reporting (Database Views)
To automate and streamline ongoing reporting, two comprehensive business views were created:

### 1. Customer Report View (`v_customer_reporting`)
This view consolidates all critical customer-centric metrics into a single, high-performing virtual table. It enables immediate access to:
- **Customer Demographics & Profile Data:** Core information uniquely identifying and segmenting each client.
- **Key Performance Indicators (KPIs):** Calculated attributes such as total spend, transaction velocity, and overall engagement duration to identify high-value customer segments.

### 2. Product Performance View (`v_product_reporting`)
Designed to provide the inventory and sales teams with immediate visibility into product health. This view aggregates data to deliver:
- **Sales Performance:** Total volume sold, revenue generated, and profitability margins per product.
- **Product Lifecycle Trends:** Insights into fast-moving vs. slow-moving inventory items to optimize supply chains.

## 🛠️ Technical Competencies Demonstrated
- **Advanced SQL Querying:** Aggregations, multi-table Joins, and Subqueries.
- **Database Architecture:** Creating and optimizing Database Views (`CREATE VIEW`) for decoupling analytical logic from raw storage.
- **Business Performance Metrics:** Formulating KPIs tailored for retail/business health monitoring.
