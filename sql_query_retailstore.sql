-- Data Cleaning
SELECT count(*) FROM sql_projects.retail_sales;

SELECT * FROM retail_sales ;

SELECT * FROM retail_sales
where 
transactions_id IS NULL OR
sale_date IS NULL OR
sale_time IS NULL OR
customer_id IS NULL OR
gender IS NULL OR
age IS NULL OR
category IS NULL OR
quantity IS NULL OR
price_per_unit IS NULL OR
cogs IS NULL OR
total_sale IS NULL ;

-- Data Exploration

-- How many sales we have ?
SELECT COUNT(*) as total_sale FROM retail_sales;
-- 1987

-- How many customers we have?
SELECT COUNT( DISTINCT customer_id) FROM retail_sales;
-- 155

-- How many number of category we have?
SELECT COUNT(distinct category) FROM retail_sales;
-- 3

-- Name these unique Category?
SELECT DISTINCT category FROM retail_sales;
-- Beauty, Clothing, Electronics

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS
-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
where sale_date='2022-11-05'; 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than or equal to 4 in the month of Nov-2022?
SELECT * FROM retail_sales
where category='clothing' and quantity>=4 and 
      month(sale_date)=11 and year(sale_date)=2022;
      
-- Q.3 Write a SQL query to calculate the total sales(total_sale) for each category?
SELECT category, sum(total_sale) as net_sale FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items
-- from the 'Beauty' category.
SELECT AVG(age) FROM retail_sales
WHERE category='Beauty';

-- Q.5 Write a SQL Query to find all transactions where the Total_sale is greater than 1000.
SELECT * FROM retail_sales
where total_sale>1000;

-- Q.6 Write a SQL Query to find the total number of transactions(transactions_id) made by each 
-- gender in each category?
with m as 
(select category, count(*) as male from retail_sales
where gender='male'
group by category),
f as 
(select category, count(*) as female from retail_sales
where gender='female'
group by category)
select m.category, male, female from m join f on m.category=f.category;

-- Q.7 Write a SQL Query to calculate the sum of sales for each month. Find out best selling month in each
-- year?
with monthly_sales as 
(select year(sale_date) as syear, month(sale_date) as smonth, sum(total_sale) as total_sales from retail_sales
group by year(sale_date), month(sale_date)
order by year(sale_date), month(sale_date) asc)
SELECT syear, smonth, total_sales
FROM
(select syear, smonth, total_sales, max(total_sales) over (partition by syear) as max_sales
from monthly_sales) as rankedsales
WHERE total_sales=max_sales
ORDER BY syear,smonth;

-- Q.7 Write a SQL Query to calculate the average sale for each month. Find out best selling month in each
-- year?
SELECT year, month, avg_sale
FROM 
	( SELECT * FROM (
		select year(sale_date) as year, 
			   month (sale_date) as month,
			   avg(total_sale) as avg_sale,
			   rank() over (partition by year(sale_date) order by avg(total_sale) desc) as rankof
		FROM retail_sales
		group by 1,2) AS t1
	WHERE rankof=1 ) AS t2
ORDER BY 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales?
select customer_id, sum(total_sale) from retail_sales
group by customer_id
order by 2 desc 
Limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items for each category.
select category, COUNT(distinct customer_id) as cnt_unique_cust from retail_sales
GROUP BY 1;

-- Q.10 Write a SQL Query to create each shift and number of orders
-- ( ex. Morning <=12, Afternoon Between 12 & 17, Evening >17)?
SELECT count(*) as total_orders,
	 case when hour(sale_time) <= 12 then 'Morning'
          when hour(sale_time) between 12 and 17 then 'Afternoon'
          when hour(sale_time) > 17 then 'Evening'
          end as shift
FROM retail_sales
GROUP BY 2;

-- END OF PROJECT
