# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis

**Level**: Beginner  
 
**Database**: `Retail_Sales_db`
 
**SQL version**: Microsoft SQL Server

This project demonstrates SQL skills used by data analysts to explore, clean, and analyze retail sales data. It includes maintaining a retail sales database, performing EDA, and answering key business questions via SQL queries. The project focuses on exploring, cleaning, and analyzing retail sales data. A sample presentation was delivered to leadership at The Retail Company.

## Objectives

1. **Set up a retail sales database**: 📊Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: 🧹Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: 👓Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: 👔Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_Sales_db`.
- **Table Import**: A table named `Retail_Sales` is imported to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.


### 2. Data Exploration & Cleaning

- **Record Count**: 📈Determine the total number of records in the dataset.
- **Customer Count**: 📉Find out how many unique customers are in the dataset.
- **Category Count**: 📈Identify all unique product categories in the dataset.
- **Null Value Check**: 📉Check for any null values in the dataset and delete records with missing data.

```sql
-- Verify Data

SELECT COUNT(*)
FROM Retail_Sales;

SELECT TOP 10 *
FROM Retail_Sales;

-- Check if any data is missing

SELECT *
FROM Retail_Sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
--Because I imported, the null becomes 0
SELECT *
FROM Retail_Sales
WHERE transactions_id = 0
	OR sale_date = '0'
	OR sale_time = '0'
	OR customer_id = 0
	OR gender = '0'
	OR age = 0
	OR category = '0'
	OR quantiy = 0
	OR price_per_unit = 0
	OR cogs = 0
	OR total_sale = 0;

-- Remove the Null/0 rows and validate the rows
DELETE FROM Retail_Sales
WHERE age = 0;
DELETE FROM Retail_Sales
WHERE quantiy = 0;
DELETE FROM Retail_Sales
WHERE price_per_unit = 0;
DELETE FROM Retail_Sales
WHERE cogs = 0;
DELETE FROM Retail_Sales
WHERE total_sale = 0;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM Retail_Sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM (
	SELECT *
	FROM Retail_Sales
	WHERE YEAR(sale_date) = 2022
	) AS sale_2022
WHERE MONTH(sale_date) = 11
	AND category = 'Clothing'
	AND quantiy >= 4
ORDER BY total_sale DESC;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category,
	SUM(total_sale) AS net_sale
FROM Retail_Sales
GROUP BY category
ORDER BY net_sale DESC;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT AVG(age) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM Retail_Sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT DISTINCT category,
	gender,
	COUNT(*) AS num_trans
FROM Retail_Sales
GROUP BY category,gender
ORDER BY gender;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
	sale_year,
	sale_month,
	avg_sale
FROM (
	SELECT 
		YEAR(sale_date) AS sale_year,
		MONTH(sale_date) AS sale_month,
		ROUND(AVG(total_sale),2) AS avg_sale,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sale_rank
	FROM Retail_Sales
	GROUP BY YEAR(sale_date),MONTH(sale_date)
	) AS sale_by_year
WHERE sale_rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
	TOP 5 customer_id,
	SUM(total_sale) AS sum_total_sale
FROM Retail_Sales
GROUP BY customer_id
ORDER BY sum_total_sale DESC;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, 
	COUNT(DISTINCT customer_id) AS unique_custcount
FROM Retail_Sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT DISTINCT sale_shift, 
	COUNT(*) AS total_order
FROM (
	SELECT *,
	 CASE WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
	 WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening' 
	 END AS sale_shift
	FROM Retail_Sales) 
	AS shift_sale
GROUP BY sale_shift;
```

### 4. Data Analysis & Findings in the Beauty Category

The following SQL queries were developed to answer specific business questions:

**Write a SQL query to find out the average profit of each category**:
```sql
SELECT 
	category,
	AVG(total_sale-(quantiy*cogs)) AS avg_profit
FROM Retail_Sales
GROUP BY category
ORDER BY avg_profit DESC;
## Findings
```

**Write a SQL query to find the average age of customers of each gender that purchased from the Beauty category**:
```sql
SELECT 
	gender,
	AVG(age) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY gender;
```

**Write a SQL query to find the average age of the customer who spends the most money on the Beauty category for each gender.**:
```sql
SELECT 
	gender,
	AVG(age) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY gender;
```

**Write an SQL query to find out how much customers from each age group have spent money on the Beauty category.**:
```sql
SELECT 
	age_group,
	COUNT(age) AS cust_count
FROM(
	SELECT 
	*,
	CASE WHEN age BETWEEN 10 AND 20 THEN 'Under 20'
	WHEN age BETWEEN 20 AND 30 THEN 'Under 30'
	WHEN age BETWEEN 30 AND 40 THEN 'Under 40'
	WHEN age BETWEEN 40 AND 50 THEN 'Under 50'
	WHEN age BETWEEN 50 AND 60 THEN 'Under 60'
	ELSE 'Over 60'
	END
	AS age_group
	FROM Retail_Sales
	) AS t1
WHERE category = 'Beauty'
GROUP BY age_group
ORDER BY cust_count DESC;
```

**Based on the above query, write an SQL query to find out the gender breakdown for each age group.**:
```sql
SELECT 
	age_group,
	gender,
	COUNT(age) AS cust_count
FROM(
	SELECT 
	*,
	CASE WHEN age BETWEEN 0 AND 19 THEN 'Under 20'
	WHEN age BETWEEN 20 AND 29 THEN 'Under 30'
	WHEN age BETWEEN 30 AND 39 THEN 'Under 40'
	WHEN age BETWEEN 40 AND 49 THEN 'Under 50'
	WHEN age BETWEEN 50 AND 59 THEN 'Under 60'
	ELSE 'Over 60'
	END
	AS age_group
	FROM Retail_Sales
	) AS t1
WHERE category = 'Beauty'
GROUP BY age_group,gender
ORDER BY cust_count DESC;
```

**Based on the above query, write an SQL query to find the total spending of each age group of each gender in the  Beauty category.**:
```sql
WITH sale_by_age_group AS
	(
	SELECT 
	*,
	CASE WHEN age BETWEEN 0 AND 19 THEN 'Under 20'
	WHEN age BETWEEN 20 AND 29 THEN 'Under 30'
	WHEN age BETWEEN 30 AND 39 THEN 'Under 40'
	WHEN age BETWEEN 40 AND 49 THEN 'Under 50'
	WHEN age BETWEEN 50 AND 59 THEN 'Under 60'
	ELSE 'Over 60'
	END
	AS age_group
	FROM Retail_Sales
	)

SELECT 
	age_group,
	gender,
	SUM(total_sale) AS total_amount
FROM sale_by_age_group
WHERE category = 'Beauty'
GROUP BY age_group,gender
ORDER BY total_amount DESC;
```

**Write an SQL query to find the number of customers from each gender that make purchases during the sale shift in the Beauty category.**:
```sql
SELECT DISTINCT sale_shift, 
	gender,
	COUNT(*) AS total_order
FROM (
	SELECT *,
	 CASE WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
	 WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening' 
	 END AS sale_shift
	FROM Retail_Sales) 
	AS shift_sale
WHERE age BETWEEN 20 AND 49
GROUP BY sale_shift,gender;
```

**Pivot the necessary SQL query to create charts for the deck.**

Total number of transactions (transaction_id) made by each gender in each category
```sql
WITH gender_category AS
	(SELECT DISTINCT category,
		gender,
		COUNT(*) AS num_trans
	FROM Retail_Sales
	GROUP BY category,gender)

SELECT * 
FROM gender_category
PIVOT (
	sum(num_trans)
	FOR gender in (Female,Male)
	)
AS pivottable;
```

Total number of transactions (transaction_id) made by each age group broken down by gender in the Beauty category.
```sql
WITH sale_beauty 
AS (
	SELECT 
	age_group,
	gender,
	COUNT(age) AS cust_count
	FROM(
		SELECT 
		*,
		CASE WHEN age BETWEEN 0 AND 19 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN 'Under 30'
		WHEN age BETWEEN 30 AND 39 THEN 'Under 40'
		WHEN age BETWEEN 40 AND 49 THEN 'Under 50'
		WHEN age BETWEEN 50 AND 59 THEN 'Under 60'
		ELSE 'Over 60'
		END
		AS age_group
		FROM Retail_Sales
		) AS t1
	WHERE category = 'Beauty'
	GROUP BY age_group,gender
	ORDER BY cust_count
	)
SELECT *
FROM sale_beauty
PIVOT (
	SUM(cust_count) FOR gender IN (female,male)
	) AS Pivot_beauty;
```

Total spending of each age group of each gender in the  Beauty category.
```sql
WITH saleamount_beauty_gender AS
	(SELECT 
		age_group,
		gender,
		SUM(total_sale) AS total_amount
	FROM (
		SELECT 
		*,
		CASE WHEN age BETWEEN 0 AND 19 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN 'Under 30'
		WHEN age BETWEEN 30 AND 39 THEN 'Under 40'
		WHEN age BETWEEN 40 AND 49 THEN 'Under 50'
		WHEN age BETWEEN 50 AND 59 THEN 'Under 60'
		ELSE 'Over 60'
		END
		AS age_group
		FROM Retail_Sales
	) AS age_totalamount
	WHERE category = 'Beauty'
	GROUP BY age_group,gender
	)
SELECT *
FROM saleamount_beauty_gender
PIVOT (
	SUM(total_amount) FOR gender IN (female,male)
	) AS Pivot_beauty_amount;
```

The number of customers from each gender that make purchases during the sale shift in the Beauty category.
```sql
WITH gender_shift 
	AS(
	SELECT DISTINCT sale_shift, 
		gender,
		COUNT(*) AS total_order
	FROM (
		SELECT *,
		 CASE WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
		 WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening' 
		 END AS sale_shift
		FROM Retail_Sales) 
		AS shift_sale
	WHERE age BETWEEN 20 AND 49
		AND category = 'Beauty'
	GROUP BY sale_shift,gender
	)
SELECT *
FROM gender_shift
PIVOT(
SUM(total_order) FOR gender IN (female, male)
) AS shift_pivot;
```

- **Customer Demographics**: 🏘️The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: 💰Several transactions had a total sale amount greater than 1000, indicating premium purchases. Interestingly, the male customer group aged 20 to 40 is spending on part on higher than their female counterparts in the beauty category.
- **Sales Trends**: 📈Monthly analysis shows variations in sales, helping identify peak seasons. We identify that the average net profit from the Beauty category is higher than the other two categories.
- **Customer Insights**: 💯The analysis identifies the top-spending customers and the most popular product categories. We found that male customers in the beauty category are a potential customer group that the retailer should focus on. 


## Conclusion

This introductory SQL project for data analysts delivers actionable insights into sales patterns, customer behavior, and product performance. It covers essential skills including data cleaning, EDA, and developing business-driven SQL queries, empowering data-driven decision-making.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Import the file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `Retail_Sales_Analysis_SQL_Project.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Chen Ni

This project showcases my SQL skills for data analyst positions and is part of my portfolio. I welcome any questions, feedback, or opportunities to collaborate.

### Shoutout to [najirh](https://github.com/najirh) for creating this awesome beginner-friendly SQL project!

- **LinkedIn**: [Chen Ni](https://www.linkedin.com/in/chenni1998/)
- **Portfolio**: [Work in Progress](https://cni-db.github.io/Portfolio.github.io/)
