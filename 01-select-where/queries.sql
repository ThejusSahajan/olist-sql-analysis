-- Business question: What are the order statuses and purchase timestamps for all orders?
-- SQL concepts: SELECT, column selection
 
SELECT
    order_id,
    order_status,
    order_purchase_timestamp
FROM orders;
 
 
-- Business question: Which orders were cancelled?
-- SQL concepts: WHERE, equality filter
 
SELECT
    order_id,
    customer_id,
    order_status
FROM orders
WHERE order_status = 'canceled';
 
 
-- Business question: Which products weigh more than 5kg (5000g)?
-- SQL concepts: WHERE, numeric comparison
 
SELECT
    product_id,
    product_weight_g,
    product_category_name
FROM products
WHERE product_weight_g > 5000;
 
 
-- Business question: Which orders were placed in 2017?
-- SQL concepts: WHERE, date filtering with BETWEEN
 
SELECT
    order_id,
    order_purchase_timestamp
FROM orders
WHERE order_purchase_timestamp BETWEEN '2017-01-01' AND '2017-12-31';
 
 
-- Business question: Which reviews have no written comment?
-- SQL concepts: WHERE, NULL check
 
SELECT
    review_id,
    order_id,
    review_score
FROM order_reviews
WHERE review_comment_message IS NULL;
 