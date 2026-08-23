-- Business question: How do sellers rank by total revenue generated?
-- SQL concepts: RANK, OVER, ORDER BY within window
 
SELECT
    seller_id,
    SUM(price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(price) DESC) AS revenue_rank
FROM order_items
GROUP BY seller_id;
 
 
-- Business question: What is the running total of payment revenue over time?
-- SQL concepts: SUM as a window function, running total with ORDER BY
 
SELECT
    order_id,
    payment_value,
    SUM(payment_value) OVER (ORDER BY order_id) AS running_total
FROM order_payments;
 
 
-- Business question: For each product category, how do individual products rank by price?
-- SQL concepts: PARTITION BY, RANK within groups
 
SELECT
    p.product_category_name,
    oi.product_id,
    oi.price,
    RANK() OVER (PARTITION BY p.product_category_name ORDER BY oi.price DESC) AS price_rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;
 
 
-- Business question: What is each order's payment value compared to the previous order's payment value?
-- SQL concepts: LAG, row-to-row comparison
 
SELECT
    order_id,
    payment_value,
    LAG(payment_value) OVER (ORDER BY order_id) AS previous_payment_value
FROM order_payments;
 
 
-- Business question: What is each order's payment value compared to the next order's payment value?
-- SQL concepts: LEAD, row-to-row comparison
 
SELECT
    order_id,
    payment_value,
    LEAD(payment_value) OVER (ORDER BY order_id) AS next_payment_value
FROM order_payments;
 
 
-- Business question: What is the row number of each order item within its seller's set of sales, ordered by price?
-- SQL concepts: ROW_NUMBER, PARTITION BY
 
SELECT
    seller_id,
    order_id,
    price,
    ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY price DESC) AS row_num
FROM order_items;
 
 
-- Business question: How does each seller's revenue compare to the platform's average seller revenue?
-- SQL concepts: AVG as a window function without PARTITION BY, comparing row value to overall average
 
SELECT
    seller_id,
    SUM(price) AS seller_revenue,
    AVG(SUM(price)) OVER () AS avg_seller_revenue_platform_wide
FROM order_items
GROUP BY seller_id;
 
 
-- Business question: What is the top 3 highest-priced order item per seller?
-- SQL concepts: DENSE_RANK, PARTITION BY, filtering window function results
 
SELECT *
FROM (
    SELECT
        seller_id,
        order_id,
        price,
        DENSE_RANK() OVER (PARTITION BY seller_id ORDER BY price DESC) AS price_rank
    FROM order_items
) ranked
WHERE price_rank <= 3;