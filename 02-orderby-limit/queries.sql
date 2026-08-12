-- Business question: What are the 5 most expensive products by price?
-- SQL concepts: ORDER BY DESC, LIMIT
 
SELECT
    product_id,
    price
FROM order_items
ORDER BY price DESC
LIMIT 5;
 
 
-- Business question: What are the 10 most recent orders placed?
-- SQL concepts: ORDER BY DESC on a date column, LIMIT
 
SELECT
    order_id,
    order_purchase_timestamp
FROM orders
ORDER BY order_purchase_timestamp DESC
LIMIT 10;
 
 
-- Business question: Which sellers are located closest to the start of the alphabet by city?
-- SQL concepts: ORDER BY ASC on text column
 
SELECT
    seller_id,
    seller_city,
    seller_state
FROM sellers
ORDER BY seller_city ASC;
 
 
-- Business question: Which orders had the longest delivery time from purchase to delivery?
-- SQL concepts: ORDER BY DESC, LIMIT, working with date columns
 
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM orders
ORDER BY order_delivered_customer_date DESC
LIMIT 10;
 
 
-- Business question: What are the lowest-priced freight (shipping) costs charged per item?
-- SQL concepts: ORDER BY ASC, multi-column sort with LIMIT
 
SELECT
    order_id,
    product_id,
    freight_value
FROM order_items
ORDER BY freight_value ASC, product_id ASC
LIMIT 10;