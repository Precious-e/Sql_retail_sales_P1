--CREATE TABLE
DROP TABLE IF retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,	
				cogs	FLOAT,
				total_sale FLOAT
			);

SELECT *
FROM retail_sales
LIMIT 10;

SELECT
 COUNT(*)
FROM retail_sales;

---creating duplicate table-- 

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
SELECT 
	COUNT(*) 
FROM retail_sales;


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
   
   /*DATA EXPLORATION--
   
   --NUMBER OF SALES--*/
   SELECT COUNT(*) as total_sale
   FROM sales_staging;

-/*HOW MANY  CUSTOMERS--*/
SELECT COUNT(DISTINCT customer_id) AS total_sale
FROM sales_staging;

/*how many category do we have */
SELECT COUNT(DISTINCT category) AS total_sale
FROM sales_staging;

/* lIST THE CATEGORY WE HAVE */
SELECT DISTINCT category AS total_sale
FROM sales_staging;

/*BUSINESS KEY PROBLEMS AND ANSWERS.

1. Write a SQL query to retrive all columns for sales modeon 2022-11-05*/
SELECT *
FROM sales_staging
WHERE sale_date = '2022-11-05';

/*2. Write a SQL query to retrieve all transactions where the category is 'Clothing'
 and the quantity sold is more than 4 in the month of Nov-2022:*/
 SELECT *
FROM sales_staging
WHERE category = 'Clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantiy >= 4;

/* 3. Write a SQL query to calculate the total sales (total_sale) for each category.:*/

SELECT category,
	sum(total_sale) as net_sale,
	count(*) as total_order
FROM sales_staging
GROUP BY category;

/* 4. Write a SQL query to find the average age of customers who purchased items from
 the 'Beauty' category.:*/
 
 SELECT avg(age) as avg_age
 FROM sales_staging
 WHERE category = 'Beauty'
 group by category;
 
 /* 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:*/
 
 SELECT *
 FROM sales_staging
 WHERE total_sale > 1000;
 
 /* 6. Write a SQL query to find the total number of transactions 
 (transaction_id) made by each gender in each category.:*/
 
 SELECT gender,
       category,
       COUNT(DISTINCT transactions_id) AS total_transactions
FROM sales_staging
GROUP BY gender, category;

/* 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year*/
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

/* 8.Write a SQL query to find the top 5 customers based on the highest total sales*/
select customer_id,
 sum(total_sale) as total_sales
 from sales_staging
 group by customer_id
 order by total_sales DESC
 LIMIT 5;
 
 /* 9.Write a SQL query to find the number of unique customers who purchased items from each category.:*/
 select 
	category,
	count(DISTINCT customer_id) as unique_customer
 from sales_staging
 group by category;
 
 /*Write a SQL query to create each shift and number of orders (Example Morning <12, 
 Afternoon Between 12 & 17, Evening >17): */
 
 SELECT 
	CASE 
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
		WHEN HOUR(sale_time) between  12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift,
    COUNT(*) AS total_orders
FROM sales_staging
GROUP BY shift;


/*END OF PROJECT*/