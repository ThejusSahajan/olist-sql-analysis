-- Business question: Which products are priced above the platform's average price?
-- SQL concepts: Subquery in WHERE, scalar comparison
 
SELECT
    product_id,
    price
FROM order_items
WHERE price > (SELECT AVG(price) FROM order_items);
 
 
-- Business question: Which customers have placed at least one order with a payment above 500?
-- SQL concepts: Subquery with IN, filtering against a list of values
 
SELECT
    customer_id
FROM orders
WHERE order_id IN (
    SELECT order_id
    FROM order_payments
    WHERE payment_value > 500
);
 
 
-- Business question: Which products have never been ordered?
-- SQL concepts: Subquery with NOT IN, unmatched rows
 
SELECT
    product_id,
    product_category_name
FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM order_items
);
 
 
-- Business question: Which sellers have never received a review score below 3?
-- SQL concepts: Subquery with NOT IN, joining review data indirectly through order_items
 
SELECT
    seller_id
FROM sellers
WHERE seller_id NOT IN (
    SELECT oi.seller_id
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
    WHERE r.review_score < 3
);
 
 
-- Business question: What is each order's payment value compared to the overall average payment value?
-- SQL concepts: Scalar subquery in SELECT
 
SELECT
    order_id,
    payment_value,
    (SELECT AVG(payment_value) FROM order_payments) AS overall_average_payment
FROM order_payments;
 
 
-- Business question: What are the top-selling product categories, based on a derived summary table?
-- SQL concepts: Subquery in FROM (derived table)
 
SELECT
    category_summary.product_category_name,
    category_summary.total_sold
FROM (
    SELECT
        p.product_category_name,
        COUNT(oi.order_item_id) AS total_sold
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
) AS category_summary
WHERE category_summary.total_sold > 50;
 
 
-- Business question: Which orders had a freight value higher than the average freight value across all order items?
-- SQL concepts: Subquery in WHERE using a related table's aggregate
 
SELECT
    oi.order_id,
    oi.freight_value,
    p.product_category_name
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.freight_value > (
    SELECT AVG(freight_value)
    FROM order_items
);