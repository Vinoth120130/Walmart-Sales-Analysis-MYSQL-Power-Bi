CREATE DATABASE IF NOT EXISTS walmart_sales;
USE walmart_sales;
CREATE TABLE IF NOT EXISTS sales_data(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY, -- Invoice unique Identifier
branch VARCHAR(30) NOT NULL, -- walmart branch
city VARCHAR(30) NOT NULL, -- where it is located
customer_type VARCHAR(50) NOT NULL, -- Member of Normal
gender VARCHAR(15) NOT NULL, -- customer gender
product_line VARCHAR(100) NOT NULL, -- Product categories
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL, -- quantity of product sold
VAT FLOAT NOT NULL, -- Value added tax for the purchase
total DECIMAL(10,2) NOT NULL, -- total cost of the purchase
`date` DATE NOT NULL, -- Purchase date
`time` TIME NOT NULL, -- purchase time
payment_method VARCHAR(15) NOT NULL, -- mode of mpaymen
cogs DECIMAL(7,2) NOT NULL, -- -- Cost of goods sold
gross_margine_percentage FLOAT NOT NULL,
gross_income DECIMAL(5,2) NOT NULL,
rating FLOAT NOT NULL -- customer rating
);

RENAME TABLE salesData TO sales_data;

Select * FROM sales_data;

-- Data Wrangling --
-- -------------------------------- Data Cleaning ---------------------------------------- --
Select DISTINCT(branch) FROM sales_data; -- There is no miss spelled variables
SELECT DISTINCT(city) FROM sales_data; -- There is no miss spelled variables
SELECT DISTINCT(gender) FROM sales_data; -- There is no miss spelled variables
SELECT DISTINCT(product_line) FROM sales_data; -- There is no miss spelled variables
SELECT DISTINCT(payment_method) FROM sales_data; -- There is no miss spelled variables

-- -------------------------------- Feature Engineering ---------------------------------------- --

SELECT MIN(`time`), MAX(`time`) FROM sales_data; -- It demonstrate that store open from 10.00 AM to 9.00 PM

-- ---------------------------- Creating column for time of day -------------------------------------

SELECT DISTINCT(time_of_day), COUNT(time_of_day) FROM sales_data
GROUP BY time_of_day;

SELECT `date`, DAYNAME(`date`) day_name
FROM sales_data;
-- ---------------------------- Creating column for day name -------------------------------------
ALTER TABLE sales_data
ADD COLUMN day_name VARCHAR(10) AFTER `time`;  -- Creating new column for day name

UPDATE sales_data
SET day_name = DAYNAME(`date`);

-- ---------------------------- Creating column for time_of_day -------------------------------------
ALTER TABLE sales_data
ADD COLUMN time_of_day VARCHAR(15) AFTER day_name;

UPDATE sales_data
SET time_of_day = (CASE
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
	END);

SELECT * FROM sales_data;

SELECT COUNT(*) FROM sales_data;

SELECT 
  (total - cogs) AS profit,
  ROUND((gross_income / total) * 100, 2) AS gross_margin_percentage
FROM sales_data;

SELECT customer_type, sum(total)
FROM sales_data
GROUP BY gender;


-- 1) Which product line generates the highest total revenue across all cities? --
SELECT product_line, SUM(total) as total FROM sales_data
GROUP BY product_line ORDER BY total desc;

-- Food and bevarages are the product that generate highest total revenue across all cities


-- 2) What is the average gross profit per product line?
SELECT product_line, AVG(gross_income) avg_profit FROM sales_data
GROUP BY product_line ORDER BY avg_profit DESC;

 /* Home and Lifestyle has an averge profit of 16.03 which is the highist 
 amouth other products followed by sports and travel 15.81 and Helth and beauty 15.41 */
 
 
-- 3) How does the sales performance of each product line vary by branch or city?
SELECT city, product_line, SUM(total) as total, 
ROW_NUMBER() OVER (PARTITION BY city ORDER BY SUM(total) DESC) as city_rank
FROM sales_data
GROUP BY city, product_line;

/* Each city shows distinct product preferences, with Sports and Travel dominating in Mandalay, 
Food and Beverages in Naypyitaw, and Home and Lifestyle in Yangon — guiding regional marketing and inventory strategies.
*/


-- 4) Which product lines are most popular among different customer types (Member vs Normal)?
SELECT customer_type, product_line, SUM(quantity)
FROM sales_data
GROUP BY customer_type, product_line
ORDER BY customer_type, SUM(quantity) DESC;
/* For Member Customers
		1. Food and beverages (506)
        2. sports and travel (493)
        3. Home and lifestyle (490)
	For Normal Customers
		1. Electronic accessories (542)
        2. Fashion accesssories (463)
        3. Sports and travel (427)
        
Business Interpretation:
	- Menmber prefer product that support daily consumption and lifestyle enhancement
    - Normal customer are down to gadget and fashionable items, possibily indicating one-time or occasional purchases. 
*/


-- 5) Are there product lines that perform better during specific times of day or days of the week?
-- Product line performance during days of week --
SELECT day_name, product_line, SUM(quantity), SUM(total)
FROM sales_data
GROUP BY day_name, product_line ORDER BY SUM(total) DESC;

/* Day-wise Product Performance Insights:
• Electronic Accessories peak on Thursday, selling 213 units worth ~$12,435.
• Home and Lifestyle performs best on Sunday, generating ~$12,072 from 187 units sold.
• Food and Beverages sees strong sales mid-week, especially on Wednesday, with ~$11,188 in revenue.

These patterns suggest specific buying behaviors:
– Weekends are ideal for promoting lifestyle and household items.
– Midweek and Thursdays are optimal for targeting gadget/electronics buyers.

Recommendation: Optimize promotional campaigns and stock allocation based on peak product-day combinations.
*/

-- Product line performance during specific times of day --
SELECT time_of_day, product_line, SUM(quantity), SUM(total)
FROM sales_data
GROUP BY time_of_day, product_line
ORDER BY SUM(total) DESC;

/* 
 - Customers are more active in the Evening, especially for gadgets and consumables.
 - Afternoon is a strong secondary window, ideal for targeting fashion and wellness shoppers.
 - Morning may be underutilized, potentially due to customer availability or product-type relevance.
*/

-- 6) Which product lines have the highest return on cost (gross income ÷ COGS)?
SELECT product_line, SUM((gross_income/cogs)) as rt_cst
FROM sales_data
GROUP BY product_line
ORDER BY rt_cst DESC;

/* Among all product lines, the following show the highest return on cost (approx. 8.7% gross margin):
 - Fashion Accessories
 - Food and Beverages
 - Electronic Accessories
These product lines consistently generate higher gross income relative to their cost of goods sold (COGS), making them strong contributors to overall profitability.
*/

-- 7) Is there a product line with low average sales but high gross income?
SELECT product_line,
	SUM(quantity) AS total_units,
	AVG(total) AS avg_invoice,
	SUM(gross_income) AS total_gross_income
FROM sales_data
GROUP BY product_line
ORDER BY avg_invoice ASC, total_gross_income DESC;

/* This product line returned high gross income with low averge sales
 - Fashion accessories
 - Electronic accessories
 - Food and beb=verages
*/

-- 8) Which payment method is most frequently used for each product line?
WITH ranked_methods AS (
  SELECT product_line, 
         payment_method, 
         COUNT(*) AS payment_frq,
         ROW_NUMBER() OVER (PARTITION BY product_line ORDER BY COUNT(*) DESC) AS rn
  FROM sales_data
  GROUP BY product_line, payment_method
)
SELECT product_line, payment_method, payment_frq
FROM ranked_methods
WHERE rn = 1;

/*Most customers prefer digital payment options (Ewallet) across categories like Fashion Accessories, Home & Lifestyle, and Health & Beauty.
However, for Electronic Accessories and Sports & Travel, Cash remains dominant.
Food & Beverages stands out with Credit Card as the most used method, hinting at habitual mid-value purchases.
*/


-- 9) What is the average transaction value by branch?
SELECT branch, ROUND(AVG(total),2) avg_trans
FROM sales_data
GROUP BY branch
ORDER BY avg_trans DESC;

/*
Branch C has the highest average transaction value, suggesting:
 - Higher product pricing
 - Larger basket sizes
 - Possibly more premium product sales or high-value customer base

Branches B and A follow closely, but might benefit from basket-building promotions or cross-sell strategies to match branch C’s performance.
*/

-- 10) At what time of day does each branch generate peak sales?
SELECT branch, time_of_day ,SUM(total)
FROM sales_data
GROUP BY time_of_day, branch
ORDER BY SUM(total) DESC;

/*
 - Branch C shows the highest total sales during the Evening (~₹49,617), making it the most profitable time slot.
 - Branch B also peaks in the Evening, but the margin is lower than C.
 - Branch A follows the same trend — Evening leads in performance.
 - Across all branches, Evening time is the most consistent peak for revenue generation.
 - Morning is the least profitable period for all branches, with sales ranging from ~₹19,000 to ₹22,500.
*/






