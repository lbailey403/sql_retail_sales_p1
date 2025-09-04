# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

--Data Analysis

--1. How many sales were made on 2022-11-05?
```sql
SELECT SUM(total_sale)
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

--2. Retrieve all the transactions made for clothing and for those where the quantity sold is more than 3 in the month of Nov-2022?
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

--3. How many transactions were made for clothing and transactions where the quantity sold is more than 3 in the month of Nov-2022?
```sql
SELECT COUNT(*) AS "Number of clothing transactions over 1 made in November"
FROM retail_sales
WHERE category = 'Clothing'
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

--4. What is the total sales for each category?
```sql
SELECT category, SUM(total_sale) AS "Total sales"
FROM retail_sales
GROUP BY category;
```

--5. What is the average age of customers who purchased items for the 'Beauty' category?
```sql
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty';
```

--6. Find all the transactions where the total_sale is greater than 1000
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

--What is the total number of transactions made by each gender in each category?
```sql
SELECT category, gender, COUNT(transactions_id) AS Total_transactions
FROM retail_sales
GROUP BY category, gender;
```

--7. What is the average sale for each month? And which is the best selling month in each year?
```sql
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
```

--8. Who are the top 5 customers based on the highest total sales?
```sql
SELECT customer_id, SUM(total_sale) as total_sales_over_time
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales_over_time DESC
LIMIT 5;
```

--9. Find the number of unique customers who purchased items from each category?
```sql
SELECT category, COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
GROUP BY category;
```

--10. Create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.


