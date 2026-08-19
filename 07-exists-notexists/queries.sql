-- Business question: Which customers have placed at least one order?
-- SQL concepts: EXISTS, correlated subquery
 
SELECT
    customer_id,
    customer_city
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
 
 
-- Business question: Which sellers have never had an order item with a review score below 3?
-- SQL concepts: NOT EXISTS, correlated subquery across order_items and order_reviews
 
SELECT
    seller_id
FROM sellers s
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
    WHERE oi.seller_id = s.seller_id
    AND r.review_score < 3
);
 
 
-- Business question: Which products have never appeared in any order?
-- SQL concepts: NOT EXISTS, unmatched rows
 
SELECT
    product_id,
    product_category_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);
 
 
-- Business question: Which orders have at least one associated payment record?
-- SQL concepts: EXISTS, confirming a relationship exists
 
SELECT
    order_id,
    order_status
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM order_payments op
    WHERE op.order_id = o.order_id
);
 
 
-- Business question: Which orders have no review submitted at all?
-- SQL concepts: NOT EXISTS, missing review data
 
SELECT
    order_id,
    order_status
FROM orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM order_reviews r
    WHERE r.order_id = o.order_id
);
 
 
-- Business question: Which sellers have sold at least one product priced above 1000?
-- SQL concepts: EXISTS, correlated subquery with an additional condition
 
SELECT
    seller_id
FROM sellers s
WHERE EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.seller_id = s.seller_id
    AND oi.price > 1000
);