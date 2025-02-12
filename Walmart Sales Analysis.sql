CREATE DATABASE WalmartSales;

CREATE TABLE sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(30),
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percentage FLOAT(11,9) ,
    gross_income DECIMAL(10,2) NOT NULL,
    rating FLOAT(2,1) 
);

-- -----Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening.----
SELECT 
    time,
    (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN ' Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM
    sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
    
UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN ' Afternoon'
        ELSE 'Evening'
    END); 
    
-- Add a new column named `day_name` that contains the extracted days of the week
SELECT 
    date, DAYNAME(date)
FROM
    sales;

ALTER TABLE sales  ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET 
    day_name = DAYNAME(date);

-- -----Add a new column named `month_name` that contains the extracted months of the year-----
SELECT 
    date, MONTHNAME(date)
FROM
    sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales 
SET 
    month_name = MONTHNAME(date);
    
-- ---------------------GENERIC-----------------------

-- ----How many unique cities does the data have?------
SELECT DISTINCT city
FROM sales;

-- ------In which city is each branch?-----
SELECT DISTINCT city , branch
FROM sales;

-- -----------PRODUCT---------------

-- How many unique product lines does the data have?
SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;

-- What is the most common payment method?
SELECT 
    payment_method, COUNT(payment_method) AS cnt
FROM
    sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is the most selling product line?
SELECT 
    product_line, COUNT(product_line) AS count
FROM
    sales
GROUP BY product_line
ORDER BY count DESC;

-- What is the total revenue by month?
SELECT 
    month_name, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT 
    month_name, SUM(cogs) AS cogs
FROM
    sales
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT 
    product_line, SUM(total) AS total_revenue
FROM
    sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT 
    city, SUM(total) AS revenue
FROM
    sales
GROUP BY city
ORDER BY revenue DESC;

-- What product line had the largest VAT?
SELECT 
    product_line, AVG(VAT) AS avg_tax
FROM
    sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which branch sold more products than average product sold?
SELECT 
    branch, SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);
 
 -- What is the most common product line by gender?
SELECT 
    gender, product_line, COUNT(gender) AS cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY cnt DESC;
 
 -- What is the average rating of each product line?
SELECT 
    product_line, ROUND(AVG(rating), 2) AS rt
FROM
    sales
GROUP BY product_line
ORDER BY rt DESC;

 -- ---------------------SALES-----------------
 
 -- Number of sales made in each time of the day per weekday
SELECT 
    time_of_day, COUNT(*) AS tot_sales
FROM
    sales
WHERE
    day_name = 'Sunday'
GROUP BY time_of_day
ORDER BY tot_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT 
    customer_type, SUM(total) AS rev
FROM
    sales
GROUP BY customer_type
ORDER BY rev DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
    city, ROUND(AVG(VAT), 2) AS tax
FROM
    sales
GROUP BY city
ORDER BY tax DESC;

-- Which customer type pays the most in VAT?
SELECT 
    customer_type, ROUND(AVG(VAT), 2) AS pay_most
FROM
    sales
GROUP BY customer_type
ORDER BY pay_most DESC;

-- -----------------CUSTOMER--------------------
-- How many unique customer types does the data have?
SELECT DISTINCT
    (customer_type)
FROM
    sales;

-- What is the most common customer type?
SELECT 
    customer_type, COUNT(customer_type) AS counts
FROM
    sales
GROUP BY customer_type;

-- What is the gender distribution per branch?
SELECT 
    branch, COUNT(gender) AS total_gender
FROM
    sales
GROUP BY branch;

-- Which time of the day do customers give most ratings per branch?
UPDATE sales
SET time_of_day = LTRIM(time_of_day);

select *
from sales;

SELECT 
    time_of_day, AVG(rating) AS rating, branch
FROM
    sales
GROUP BY time_of_day , branch
ORDER BY 3 DESC;

-- Which day of the week has the best average ratings per branch?
SELECT 
    day_name, AVG(rating) AS rating, branch
FROM
    sales
GROUP BY day_name , branch
ORDER BY branch , rating DESC;


 





