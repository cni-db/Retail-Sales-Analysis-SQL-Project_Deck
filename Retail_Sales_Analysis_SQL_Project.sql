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


-- EDA

-- How many sales do we have?
SELECT COUNT(*)
FROM Retail_Sales;
-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id)
FROM Retail_Sales;
-- How many unique category do we offer?
SELECT DISTINCT category
FROM Retail_Sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM Retail_Sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
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

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
	SUM(total_sale) AS net_sale
FROM Retail_Sales
GROUP BY category
ORDER BY net_sale DESC;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT AVG(age) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM Retail_Sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT DISTINCT category,
	gender,
	COUNT(*) AS num_trans
FROM Retail_Sales
GROUP BY category,gender
ORDER BY gender;

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


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	TOP 5 customer_id,
	SUM(total_sale) AS sum_total_sale
FROM Retail_Sales
GROUP BY customer_id
ORDER BY sum_total_sale DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, 
	COUNT(DISTINCT customer_id) AS unique_custcount
FROM Retail_Sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
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

-- Data Analysis & Business Key Problems on Beauty category

-- Write a SQL query to find out the average profit of each category.
SELECT 
	category,
	AVG(total_sale-(quantiy*cogs)) AS avg_profit
FROM Retail_Sales
GROUP BY category
ORDER BY avg_profit DESC;

--Write a SQL query to find the average age of customers of each gender that purchased from Beauty category.
SELECT 
	gender,
	AVG(age) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY gender;

--Write a SQL query to find the average age of the customer who spend the most money on Beauty category for each gender.
SELECT *
FROM Retail_Sales
WHERE category = 'Beauty';

--Write a SQL query to find out how much customer from each age groups have spend money on Beauty category.
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

--Expand the above SQL query to include gender
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

--Based on the above query, write a SQL query to find the total spending of each age group of each gender in Beauty category.
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

--pivot
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

--pivot
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