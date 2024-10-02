-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
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
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
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
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales 
where 
category = 'Clothing' 
AND 
EXTRACT (YEAR FROM SALE_DATE) = 2022
AND
EXTRACT (MONTH FROM SALE_DATE) =  11
AND
QUANTITY >= 4;



-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT CATEGORY,SUM(TOTAL_SALE) 
FROM RETAIL_SALES  
GROUP BY CATEGORY ;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT CATEGORY,AVG(AGE) FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'
GROUP BY CATEGORY;



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(transaction_id) 
from retail_sales
group by 1,2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
year,
MONTH,
avg_sale
FROM
(
select 
EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
avg(total_sale) AS AVG_SALE,
rank() over (PARTITION BY EXTRACT(MONTH FROM SALE_DATE)ORDER BY AVG(TOTAL_SALE)) as rank 
from retail_sales 
group by 1,2
ORDER BY 2
) 
WHERE rank = 1
order by 1,3 desc;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) 
from retail_sales
group by customer_id
order by 2 desc
limit 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
count( distinct customer_id) 
from retail_sales
group by category;
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with cte as
(
select *,
case 
when extract(hour from sale_time) <= 10
then 'Morning'
when extract(hour from sale_time) >= 12 and extract(hour from sale_time) <=17
then 'Afternoon'
when extract(hour from sale_time) > 17 
then 'Evening'
end as shift
from retail_sales
)
select count(*),shift from cte
group by 2;




