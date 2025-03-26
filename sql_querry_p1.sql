-- SQL Retail sales Analsis-P1
Create DATABASE sql_project_p11;
--create TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
              transactions_id INT PRIMARY KEY,
              sale_date DATE,
              sale_time TIME,
              customer_id INT,
              gender VARCHAR(15),
              age INT,
              category VARCHAR(15),
              quantity INT,
              price_per_unit FLOAT,
              cogs FLOAT,
              total_sale  FLOAT

            );
---Data cleaning

SELECT * FROM retail_sales	
SELECT
   COUNT(*)
FROM retail_sales   
-- Null values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL 
SELECT*FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE
   transactions_id IS NULL 
   OR
   sale_date IS NULL 
   OR 
   sale_time IS NULL 
   OR 
   gender IS NULL 
   OR 
   category IS NULL 
   OR 
   quantity IS NULL 
   OR 
   cogs  IS NULL 
   OR 
   total_sale IS NULL;

-- Delete    
  
  DELETE FROM retail_sales
   WHERE
   transactions_id IS NULL 
   OR
   sale_date IS NULL 
   OR 
   sale_time IS NULL 
   OR 
   gender IS NULL 
   OR 
   category IS NULL 
   OR 
   quantity IS NULL 
   OR 
   cogs  IS NULL 
   OR 
   total_sale IS NULL;

---Data exploration 
--How many sales we have 
SELECT COUNT(*) as Total_sale FROM retail_sales
--How many unique customers we have 
SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales 
-- How many unique category we have 
SELECT COUNT (DISTINCT category) as total_category FROM  retail_sales
-- The name of the distinct categorys we have 
SELECT DISTINCT category FROM retail_sales 


---Data analysis and Business key problems 
--Q1 write a query to retrieve all columns for sales made in '2022-11-05'
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05'
-- write a query to retrieve all transactions where the category is clothing and the quantity sold is greater than 3 in the month of  november 2022
SELECT 
*
FROM
retail_sales
WHERE 
category = 'Clothing'
   AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
   AND
quantity>=4
--write a sql querry to calculate the total sales (total_sale) for each category
SELECT 
category, 
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
-- Q.4 write a SQLquerry to find the average age of customers who purchased from the beauty category 
SELECT 
  ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
-- Q.5 write a SQL querry to find all transactions where the total_sale is greater than 1000 
SELECT * FROM retail_sales 
WHERE total_sale > 1000
--Q.6 write a sql querry to find the total number of transactions(transaction_id) made by each gender in each category 
SELECT 
category, 
gender, 
COUNT(*) as total_transactions 
FROM retail_sales
GROUP BY category, 
gender 
ORDER BY 1
-- Q.7 write a sql querry to calculate the average sale for each month, find out best selling month in each year 
SELECT * FROM 
(
    SELECT
	EXTRACT (YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month, 
	AVG(total_sale) as avg_sale, 
	RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)as rank
	FROM retail_sales
	GROUP BY 1,2
	) as t1
WHERE rank = 1	
	
--Q.8 write a sql querry to find the top 5 customers based on the highest total sale 
SELECT 
customer_id,
SUM(total_sale) as total_sales 
FROM retail_sales 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
--Q9 write a sql querry to find the unique customers who purchased items from each category 
SELECT 
category,
COUNT(DISTINCT customer_id) as count_of_unique_customer 
FROM retail_sales 
GROUP BY 1
--Q.10 write a sql querry to create each shift and number of orders (example : Morning < 12, Afternoon 12 et 17, evening > 17 ) (this querry allows us to have each hour and their total orders)

WITH hourly_sale
AS
(
SELECT*, 
CASE 
WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE  'Evening'
END as shift
FROM retail_sales 
)
SELECT
shift,
  COUNT (*) as total_orders
FROM hourly_sale
GROUP BY shift
-- End of project