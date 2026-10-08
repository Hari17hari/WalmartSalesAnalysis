create database  projects

select * from WalmartSales 

EXEC sp_rename 'WalmartSales.tax_5', 'vat', 'COLUMN';

-----------------------------------------------------
-- ----------Feature Engineering --------------------

-- Adding  time_of_day
SELECT 
	time,
	CASE 
		WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
		WHEN TIME BETWEEN '12:00:01' AND '04:00:00' THEN 'afternooon'
		ELSE 'evening'
	END as 'time_of_day'
from WalmartSales;

alter table WalmartSales add  time_of_day varchar(20);

update WalmartSales
set time_of_day = (
					CASE 
						WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
						WHEN TIME BETWEEN '12:00:01' AND '04:00:00' THEN 'afternooon'
						ELSE 'evening'
					END 
				)


-- Adding day_name
SELECT 
	date,
	DATENAME(weekday,date) as day_name
	from WalmartSales;

ALTER TABLE WalmartSales ADD day_name varchar(20);

update WalmartSales
SET day_name = DATENAME(weekday,date);


--Adding month_name
select 
	date,
	DATENAME(Month,date) as month_name
from WalmartSales;
				
alter table WalmartSales add month_name varchar(15);

update WalmartSales
set month_name = datename(month,date);
	
-----------------------------------------------------


--Business Questions 

--How many unique cities does the data have?

SELECT Distinct City from WalmartSales;

--In which city is each branch?
select Distinct city,branch from WalmartSales;



-------------------------------------------------------
--                                                    |
------------------- Product ---------------------------
--                                                    |
-------------------------------------------------------

--How many unique product lines does the data have?
select distinct Product_line from WalmartSales;
--What is the most common payment method?

select top 1
	payment,
	count(*) as payment_count
	from WalmartSales
group by payment
order by payment_count desc;



--What is the most selling product line?
select 
	sum(quantity) as qty,
	product_line 
	from WalmartSales
group by product_line
order by qty desc;

--What is the total revenue by month?

select
	month_name as month,
	sum(total) as total_revenue
	from WalmartSales
group by month_name
order by total_revenue desc;
--What month had the largest COGS?
select 
	month_name as month,
	sum(cogs) as costOfGoods
	from WalmartSales
group by month_name
order by costOfGoods desc;




select * from WalmartSales;
--What product line had the largest revenue?
select
	product_line,
	sum(total) as total_revenue
	from WalmartSales
group by product_line
order by total_revenue desc;
--What is the city with the largest revenue?
select 
	city,
	sum(total) as total_revenue
	from WalmartSales
group by city
order by total_revenue desc;

----What product line had the largest VAT?
select
	product_line,
	avg(vat) as tax
	from WalmartSales
group by product_line
order by tax desc;
--Fetch each product line and add a column to those product line showing 
--"Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM WalmartSales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM WalmartSales
GROUP BY product_line;


select * from WalmartSales;
	
--Which branch sold more products than average product sold?
select 
	branch,
	sum(quantity) as qty
from WalmartSales
group by branch;

select * from WalmartSales
--What is the most common product line by gender?
select
	gender,
	product_line,
	count(gender) as total_cnt
from WalmartSales
group by gender,product_line
order by total_cnt desc;

--What is the average rating of each product line?
select 
	product_line,
	round(avg(rating),2) as avg_rating
from WalmartSales
group by Product_line;




-------------------------------------------------------
--                                                    |
------------------- Sales -----------------------------
--                                                    |
-------------------------------------------------------


select * from WalmartSales;
--Number of sales made in each time of the day per weekday
select
	time_of_day,
	count(total) as total_sales
from WalmartSales
where day_name <> 'sunday'  -- (Evening time has highest no. of sales)
group by time_of_day
order by total_sales desc;


--Which of the customer types brings the most revenue?
select
	customer_type,
	sum(total) as total_revenue
from WalmartSales
group by Customer_type
order by total_revenue desc;
--Which city has the largest tax percent/ VAT (Value Added Tax)?
select
	city,
	avg(vat) as tax
from WalmartSales
group by city
order by tax desc;
--Which customer type pays the most in VAT?
select 
	customer_type,
	sum(vat) as tax
from WalmartSales
group by customer_type
order by tax desc;


-------------------------------------------------------
--                                                    |
------------------- Customers -------------------------
--                                                    |
-------------------------------------------------------

select * from WalmartSales;
--How many unique customer types does the data have?
select 
	distinct customer_type 
from WalmartSales;
--How many unique payment methods does the data have?
select 
	distinct payment 
from WalmartSales;
--What is the most common customer type?
select
customer_type,
	count(Customer_type) as cnt
from WalmartSales
group by Customer_type
order by cnt desc;

--Which customer type buys the most?
select
	customer_type,
	sum(total) as max_buy
from WalmartSales
group by Customer_type
order by max_buy desc;
--What is the gender of most of the customers?
select
	gender,
	count(gender) as gnd
from WalmartSales
group by gender
order by gnd desc;
--What is the gender distribution per branch?
select
	branch,
	count(gender) as gnd
from WalmartSales
group by branch
order by gnd desc;
--Which time of the day do customers give most ratings?
select
	time_of_day,
	count(rating) rtng
from WalmartSales
group by time_of_day
order by rtng desc;
--Which time of the day do customers give most ratings per branch?
select
	branch,
	time_of_day,
	count(rating) rtng
from WalmartSales
group by branch,time_of_day
order by rtng desc;
--Which day fo the week has the best avg ratings?
select top 1
	day_name,
	cast(round(avg(rating),2) as decimal(10,2)) as avg_rating
from WalmartSales
group by day_name
order by avg_rating desc;
--Which day of the week has the best average ratings per branch?
select 
	branch,
	day_name,
	cast(round(avg(rating),2) as decimal(10,2)) as avg_rating
from WalmartSales
group by branch,day_name
order by avg_rating desc;



