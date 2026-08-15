-- Business question: Which customer city placed each order?
-- SQL concepts: INNER JOIN, two tables
 
SELECT
    o.order_id,
    o.order_status,
    c.customer_city,
    c.customer_state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
 
 
-- Business question: What product was included in each order item, along with its price?
-- SQL concepts: INNER JOIN, order_items to products
 
SELECT
    oi.order_id,
    p.product_category_name,
    oi.price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;
 
 
-- Business question: Which seller fulfilled each order item, and which city are they based in?
-- SQL concepts: INNER JOIN, order_items to sellers
 
SELECT
    oi.order_id,
    s.seller_city,
    s.seller_state
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id;
 
 
-- Business question: For each order, who was the customer and what products did they buy?
-- SQL concepts: 3-table JOIN (orders, customers, order_items)
 
SELECT
    o.order_id,
    c.customer_city,
    oi.product_id,
    oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id;
 
 
-- Business question: For each order item, which product category was sold and which seller shipped it?
-- SQL concepts: 3-table JOIN (order_items, products, sellers)
 
SELECT
    oi.order_id,
    p.product_category_name,
    s.seller_state
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN sellers s ON oi.seller_id = s.seller_id;
 
 
-- Business question: What is the full order chain from customer to product to seller for each order item?
-- SQL concepts: 4-table JOIN (orders, customers, order_items, products)
 
SELECT
    o.order_id,
    c.customer_state,
    p.product_category_name,
    oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;
 
 
-- Business question: Which orders have no matching payment record?
-- SQL concepts: LEFT JOIN, filtering for unmatched rows with IS NULL
 
SELECT
    o.order_id,
    o.order_status
FROM orders o
LEFT JOIN order_payments op ON o.order_id = op.order_id
WHERE op.order_id IS NULL;
 
 
-- Business question: What payment type and review score did each order receive?
-- SQL concepts: JOIN across order_payments and order_reviews via orders
 
SELECT
    o.order_id,
    op.payment_type,
    r.review_score
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
JOIN order_reviews r ON o.order_id = r.order_id;
 