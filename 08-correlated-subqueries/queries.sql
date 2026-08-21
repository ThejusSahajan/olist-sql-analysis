-- Business question: Which order items are priced above the average price within their own product category?
-- SQL concepts: Correlated subquery in WHERE, comparing to a group-specific average
 
SELECT
    oi.order_id,
    oi.product_id,
    oi.price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.price > (
    SELECT AVG(oi2.price)
    FROM order_items oi2
    JOIN products p2 ON oi2.product_id = p2.product_id
    WHERE p2.product_category_name = p.product_category_name
);
 
 
-- Business question: For each seller, what is their highest-priced item sold, shown alongside their listing?
-- SQL concepts: Correlated subquery in SELECT, per-row scalar lookup
 
SELECT
    s.seller_id,
    (
        SELECT MAX(oi.price)
        FROM order_items oi
        WHERE oi.seller_id = s.seller_id
    ) AS highest_price_sold
FROM sellers s;
 
 
-- Business question: Which customers have placed more orders than the average number of orders per customer?
-- SQL concepts: Correlated subquery comparing row count to an outer aggregate
 
SELECT
    c.customer_id,
    (
        SELECT COUNT(o.order_id)
        FROM orders o
        WHERE o.customer_id = c.customer_id
    ) AS order_count
FROM customers c
WHERE (
    SELECT COUNT(o.order_id)
    FROM orders o
    WHERE o.customer_id = c.customer_id
) > (
    SELECT AVG(order_count) FROM (
        SELECT COUNT(order_id) AS order_count
        FROM orders
        GROUP BY customer_id
    ) sub
);
 
 
-- Business question: Which products are the most expensive item within their own category?
-- SQL concepts: Correlated subquery, identifying a per-group maximum
 
SELECT
    p.product_id,
    p.product_category_name,
    oi.price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.price = (
    SELECT MAX(oi2.price)
    FROM order_items oi2
    JOIN products p2 ON oi2.product_id = p2.product_id
    WHERE p2.product_category_name = p.product_category_name
);
 
 
-- Business question: Which sellers have an average review score below their own state's average review score?
-- SQL concepts: Correlated subquery comparing group averages across two dimensions
 
SELECT
    s.seller_id,
    s.seller_state
FROM sellers s
WHERE (
    SELECT AVG(r.review_score)
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
    WHERE oi.seller_id = s.seller_id
) < (
    SELECT AVG(r2.review_score)
    FROM sellers s2
    JOIN order_items oi2 ON oi2.seller_id = s2.seller_id
    JOIN order_reviews r2 ON oi2.order_id = r2.order_id
    WHERE s2.seller_state = s.seller_state
);
 
 
-- Business question: Which orders had a freight value higher than the average freight value for orders from the same customer state?
-- SQL concepts: Correlated subquery across three related tables
 
SELECT
    o.order_id,
    oi.freight_value,
    c.customer_state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.freight_value > (
    SELECT AVG(oi2.freight_value)
    FROM orders o2
    JOIN customers c2 ON o2.customer_id = c2.customer_id
    JOIN order_items oi2 ON o2.order_id = oi2.order_id
    WHERE c2.customer_state = c.customer_state
);