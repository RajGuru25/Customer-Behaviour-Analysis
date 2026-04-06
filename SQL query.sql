CREATE DATABASE customer_behavior;
USE customer_behavior;
DESCRIBE customer;
-- Q1 : Revenue by Gender
SELECT 
    gender,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer
GROUP BY gender;
-- Q2: High-Spending Discount Customers
SELECT 
    customer ,
    `Purchase Amount (USD)`
FROM customer
WHERE `Discount Applied` = 'Yes'
AND `Purchase Amount (USD)` > (
    SELECT AVG(`Purchase Amount (USD)`) FROM customer
);

-- Q3: Top 5 Products by Rating
SELECT 
    `Item Purchased`,
    ROUND(AVG(`Review Rating`),2) AS avg_rating
FROM customer
GROUP BY `Item Purchased`
ORDER BY avg_rating DESC
LIMIT 5;

-- Q4: Shipping Type Impact
SELECT 
    `Shipping Type`,
    ROUND(AVG(`Purchase Amount (USD)`),2) AS avg_purchase
FROM customer
GROUP BY `Shipping Type`;

-- Q5: Subscribers vs Non-Subscribers
SELECT 
    `Subscription Status`,
    COUNT(*) AS total_customers,
    ROUND(AVG(`Purchase Amount (USD)`),2) AS avg_spend,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer
GROUP BY `Subscription Status`;

-- Q6: Discount Dependency Products
SELECT 
    `Item Purchased`,
    ROUND(
        100 * SUM(CASE WHEN `Discount Applied`='Yes' THEN 1 ELSE 0 END)/COUNT(*),2
    ) AS discount_rate
FROM customer
GROUP BY `Item Purchased`
ORDER BY discount_rate DESC
LIMIT 5;

-- Q7: Customer Segmentation
SELECT 
    `Customer Segment`,
    COUNT(*) AS total_customers
FROM customer
GROUP BY `Customer Segment`;

-- Q8: Top 3 Products per Category
SELECT *
FROM (
    SELECT 
        `Category`,
        `Item Purchased`,
        COUNT(*) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY `Category`
            ORDER BY COUNT(*) DESC
        ) AS rank_num
    FROM customer
    GROUP BY `Category`, `Item Purchased`
) ranked
WHERE rank_num <= 3;

-- Q9: Repeat Buyers vs Subscription
SELECT 
    `Subscription Status`,
    COUNT(*) AS repeat_buyers
FROM customer
WHERE `Previous Purchases` > 5
GROUP BY `Subscription Status`;

-- Q10: Revenue by Age Group
SELECT 
    `Age Group`,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer
GROUP BY `Age Group`
ORDER BY total_revenue DESC;

-- Q11: Top Customers by CLV
SELECT 
    customer_id,
    clv
FROM customer
ORDER BY clv DESC
LIMIT 10;

-- Q12: Engagement Score by Customer Segment
SELECT 
    `Customer Segment`,
    ROUND(AVG(`Engagement Score`),2) AS avg_engagement
FROM customer
GROUP BY `Customer Segment`;