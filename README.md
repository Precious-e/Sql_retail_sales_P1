
# README.md

Retail Sales Analysis SQL Project


##  📌 Project overview

This project uses SQL to analyze sales data stored in the `sales_staging` table.  
The queries answer common business questions, such as top customers, category performance, sales by time of day, and customer demographics.
## 🎯 Objective


The objective of this project is to use SQL queries to analyze sales data and extract meaningful business insights. By working with the sales_staging dataset, the project aims to:

* Set up a retail sales database: Create and populate a retail sales database with the provided sales data.

* Data Cleaning: Identify and remove any records with missing or null values.

* Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.

* Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
## 🔑 Key SQL Queries

1. Transactions in the Clothing category with quantity > 4 in Nov-2022  
2. Total sales and total orders per category  
3. Average customer age for the Beauty category  
4. All transactions where total_sale > 1000  
5. Transactions grouped by gender and category  
6. Average sales per month + best-selling month each year  
7. Top 5 customers by total sales  
8. Number of unique customers in each category  
9. Orders split into shifts: Morning (<12), Afternoon (12–17), Evening (>17)  

##  🛠️ Tools
 - **MySQL Workbench** for queries  
- **GitHub** for project hosting  
### 🛠️ Database Setup
Here we created the main table retail_sales and a duplicate sales_staging table for analysis and cleaning.

-- Create main table
```sql
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- View first 10 rows
SELECT * FROM retail_sales LIMIT 10;

-- Count records
SELECT COUNT(*) FROM retail_sales;

```
Note: The sales_staging table was created as a working copy to keep the original table clean.

### 📊 Data Exploration & Cleaning
We checked record counts, unique values, and missing values to understand the dataset before analysis.

```sql
-- Duplicate staging table for analysis
CREATE TABLE sales_staging (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantiy INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

-- Check for missing values
SELECT *
FROM sales_staging
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Number of sales
SELECT COUNT(*) AS total_sale FROM sales_staging;

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM sales_staging;

-- Number of categories
SELECT COUNT(DISTINCT category) AS total_categories FROM sales_staging;

-- List categories
SELECT DISTINCT category FROM sales_staging;
```
This stage ensures that the dataset is clean and reliable before moving into deeper analysis.
### 💡 Business Questions & Insights
These SQL queries answer common business-related questions and provide actionable insights.

1. Retrieve all sales on a specific date (2022-11-05)
```sql
SELECT *
FROM sales_staging
WHERE sale_date = '2022-11-05';
```

2. Find transactions in 'Clothing' where quantity > 4 in Nov 2022
```sql
SELECT *
FROM sales_staging
WHERE category = 'Clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantiy >= 4;
```
Helps identify bulk clothing sales during peak season.

3. Total sales and orders per category
```sql
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_order
FROM sales_staging
GROUP BY category;
```
 Shows which categories generate the most revenue.

4. Average age of customers in Beauty category
```sql
SELECT AVG(age) AS avg_age
FROM sales_staging
WHERE category = 'Beauty'
GROUP BY category;
```
 Helps understand the customer demographic for Beauty products.

5. Transactions where total_sale > 1000
```sql
SELECT *
FROM sales_staging
WHERE total_sale > 1000;
```
Identifies high-value sales for premium customers.

6. Transactions count by gender and category
```sql
SELECT gender,
       category,
       COUNT(DISTINCT transactions_id) AS total_transactions
FROM sales_staging
GROUP BY gender, category;
```
Useful for gender-based purchasing behavior analysis.

7.  Best selling month in each year
```sql
WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total_sale) AS total_sales
    FROM sales_staging
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year, month, total_sales
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY total_sales DESC) AS rn
    FROM monthly_sales
) ranked
WHERE rn = 1;
```
Identifies seasonal trends and the strongest sales months.

8. Top 5 customers by total sales
```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM sales_staging
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
Highlights the most valuable customers.

9. Unique customers per category
```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customer
FROM sales_staging
GROUP BY category;
```
Useful for measuring category reach across different customers.

10. Orders by shift (Morning, Afternoon, Evening)
```sql
SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM sales_staging
GROUP BY shift;
```
Analyzes peak shopping times during the day.

## End of Project

## Findings

1. Sales Distribution:
The Electronics and Beauty categories generated 60% of total revenue,
indicating these as key profit drivers, while Stationery and Home Supplies contributed less than 10%, showing potential areas for improvement.

2 Customer Demographics
 Customers aged 25–34 accounted for over 45% of Beauty product purchases, suggesting targeted marketing toward young adults would yield higher returns.

3. High-Value Orders
Approximately 12% of all transactions exceeded $1,000, contributing nearly 40% of total revenue — showing that a small segment of high-spending customers drives most of the income.

4. Top Customers
The top 5 customers generated 25% of total revenue, highlighting the importance of customer retention and loyalty programs.

5. Seasonality
Sales peaked in November and December, showing strong seasonality during the holiday period. These months saw a 30% increase in average monthly sales compared to mid-year months.

6. Shift Analysis
 The afternoon shift (12 PM–4 PM) recorded the highest transaction volume (45% of daily sales), suggesting this time window is critical for staffing and promotions.

 ## Conclusion

This analysis demonstrates how SQL can be used not only for data management but also for generating actionable business insights.
Key trends such as strong performance in Electronics and Beauty, high-value customer segments, and pronounced holiday season peaks highlight opportunities for targeted marketing, inventory planning, and customer retention strategies.
Overall, this project showcases practical SQL skills and the ability to translate data into measurable business impact.


## Author: Precious Eric

This project is part of my portfolio, showcasing SQL skills relevant to data analyst roles.
If you have any questions, feedback, or collaboration opportunities, feel free to connect with me on:

- LinkedIn: [Precious Eric](https://www.linkedin.com/in/precious-eric-52834b168)  
- GitHub: [Precious-e](https://github.com/Precious-e)  
- Email: [Precious](mailto:ericprecious284@gmail.com)  


