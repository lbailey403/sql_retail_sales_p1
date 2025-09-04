--SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
(
				transactions_id int PRIMARY KEY,
				sale_date date,
				sale_time time,
				customer_id	int,
				gender varchar (15),
				age	int,
				category varchar (15),	
				quantiy	int,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
);

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
LIMIT 10;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;




--Data exploration

-- How many sales do we have?
SELECT COUNT (*) as total_sale FROM retail_sales;

--How many customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;





--Data Analysis

--How many sales were made on 2022-11-05?
SELECT SUM(total_sale)
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Retrieve all the transactions made for clothing and for those where the quantity sold is more than 3 in the month of Nov-2022?
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

--How many transactions were made for clothing and transactions where the quantity sold is more than 3 in the month of Nov-2022?
SELECT COUNT(*) AS "Number of clothing transactions over 1 made in November"
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- What is the total sales for each category?
SELECT category, SUM(total_sale) AS "Total sales"
FROM retail_sales
GROUP BY category;


-- What is the average age of customers who purchased items for the 'Beauty' category?
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty';

--Find all the transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

--What is the total number of transactions made by each gender in each category?
SELECT category, gender, COUNT(transactions_id) AS Total_transactions
FROM retail_sales
GROUP BY category, gender;

--What is the average sale for each month? And which is the best selling month in each year?
SELECT year, month, avg_sale FROM
(
SELECT
EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) as avg_sale,
RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;

--Who are the top 5 customers based on the highest total sales?
SELECT customer_id, SUM(total_sale) as total_sales_over_time
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales_over_time DESC
LIMIT 5;


--Find the number of unique customers who purchased items from each category?
SELECT category, COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
GROUP BY category;

--Create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
 CASE
   WHEN sale_time < '12:00:00' THEN 'Morning'
   WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
   ELSE 'Evening'
   END as Shift
 FROM retail_sales
)
SELECT shift, COUNT(transactions_id) as Total_orders
FROM hourly_sale
GROUP BY shift;

--END of project