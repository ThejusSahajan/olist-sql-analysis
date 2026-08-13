- Business question: How many total orders have been placed?
-- SQL concepts: COUNT
 
SELECT
    COUNT(order_id) AS total_orders
FROM orders;
 
 
-- Business question: What is the total revenue collected from all payments?
-- SQL concepts: SUM
 
SELECT
    SUM(payment_value) AS total_revenue
FROM order_payments;
 
 
-- Business question: What is the average review score given by customers?
-- SQL concepts: AVG
 
SELECT
    AVG(review_score) AS average_review_score
FROM order_reviews;
 
 
-- Business question: What are the cheapest and most expensive product prices sold?
-- SQL concepts: MIN, MAX in a single query
 
SELECT
    MIN(price) AS cheapest_price,
    MAX(price) AS most_expensive_price
FROM order_items;
 
 
-- Business question: How many unique sellers are there on the platform?
-- SQL concepts: COUNT with DISTINCT
 
SELECT
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM sellers;
 
 
-- Business question: What is the average freight (shipping) cost across all order items?
-- SQL concepts: AVG on a different numeric column
 
SELECT
    AVG(freight_value) AS average_freight_cost
FROM order_items;