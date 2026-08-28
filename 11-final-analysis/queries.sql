-- Business question: For each order, show the customer state, product category, seller state, payment type, and review score in one integrated view.
-- SQL concepts: Multi-table JOIN across customers, orders, order_items, products, sellers, order_payments, order_reviews
 
SELECT
    o.order_id,
    c.customer_state,
    p.product_category_name,
    s.seller_state,
    op.payment_type,
    r.review_score
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN sellers s ON oi.seller_id = s.seller_id
JOIN order_payments op ON o.order_id = op.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id;
 
 
-- Business question: How many days does delivery take on average per customer state, and how does each order compare to that average?
-- SQL concepts: Date functions (date subtraction), CTE, window function, JOIN
 
WITH delivery_times AS (
    SELECT
        o.order_id,
        c.customer_state,
        (o.order_delivered_customer_date - o.order_purchase_timestamp) AS delivery_days,
        AVG(o.order_delivered_customer_date - o.order_purchase_timestamp)
            OVER (PARTITION BY c.customer_state) AS avg_state_delivery_days
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT *
FROM delivery_times
WHERE delivery_days > avg_state_delivery_days;
 
 
-- Business question: How should each customer be segmented based on their total spending?
-- SQL concepts: CASE WHEN, CTE, aggregation, COALESCE for missing payment data
 
WITH customer_spend AS (
    SELECT
        c.customer_id,
        COALESCE(SUM(op.payment_value), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_payments op ON o.order_id = op.order_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    total_spent,
    CASE
        WHEN total_spent = 0 THEN 'No Purchases'
        WHEN total_spent < 100 THEN 'Low Spender'
        WHEN total_spent BETWEEN 100 AND 500 THEN 'Mid Spender'
        ELSE 'High Spender'
    END AS customer_segment
FROM customer_spend;
 
 
-- Business question: Build a seller performance scorecard ranking sellers by revenue within their state, with a performance label.
-- SQL concepts: CTE, window function (PARTITION BY + RANK), CASE WHEN, aggregation
 
WITH seller_performance AS (
    SELECT
        s.seller_id,
        s.seller_state,
        SUM(oi.price) AS total_revenue,
        RANK() OVER (PARTITION BY s.seller_state ORDER BY SUM(oi.price) DESC) AS state_rank
    FROM sellers s
    JOIN order_items oi ON s.seller_id = oi.seller_id
    GROUP BY s.seller_id, s.seller_state
)
SELECT
    seller_id,
    seller_state,
    total_revenue,
    state_rank,
    CASE
        WHEN state_rank = 1 THEN 'Top Seller in State'
        WHEN state_rank <= 3 THEN 'Strong Performer'
        ELSE 'Standard Performer'
    END AS performance_label
FROM seller_performance;
 
 
-- Business question: Generate a clean monthly sales report showing month name and total revenue.
-- SQL concepts: Date functions (TO_CHAR/DATE_TRUNC), string formatting, aggregation
 
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'Month YYYY') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(op.payment_value) AS total_revenue
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'Month YYYY'), DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp);
 
 
-- Business question: Which product categories have missing translations, and how should they display in an English report?
-- SQL concepts: LEFT JOIN, COALESCE for NULL handling, string function (UPPER), product_category_name_translation table
 
SELECT
    p.product_category_name,
    COALESCE(UPPER(t.product_category_name_english), 'CATEGORY NOT TRANSLATED') AS display_category
FROM products p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english;
 
 
-- Business question: Which Brazilian states have the highest concentration of registered sellers, based on geolocation zip prefixes?
-- SQL concepts: JOIN with geolocation (stretch query), aggregation, DISTINCT
 
SELECT
    g.geolocation_state,
    COUNT(DISTINCT s.seller_id) AS seller_count
FROM sellers s
JOIN geolocation g
    ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_state
ORDER BY seller_count DESC;


-- Business question:
-- How does repeat purchasing contribute to the customer base and revenue?

-- Business Context:
-- Compare one-time and repeat customers to understand customer
-- retention and the revenue contribution of repeat purchasing.

-- SQL Concepts:
-- CTEs, JOINs, COUNT(DISTINCT), GROUP BY, CASE expressions,
-- aggregate functions, and percentage calculations.

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),

customer_revenue AS (
    SELECT
        c.customer_unique_id,
        co.order_count,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN customer_orders co
        ON c.customer_unique_id = co.customer_unique_id
    GROUP BY
        c.customer_unique_id,
        co.order_count
)

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type,

    COUNT(*) AS customers,

    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage,

    ROUND(
        SUM(total_revenue)::numeric,
        2
    ) AS total_revenue

FROM customer_revenue

GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END

ORDER BY total_revenue DESC;

-- Key Finding:
-- 96.87% of customers made only one purchase,
-- while 3.13% were repeat customers.
-- Repeat customers generated 778,821.97 in revenue.


-- Business question:
-- What percentage of total revenue is generated by the top 10 sellers?

-- Business Context:
-- Identify how concentrated seller revenue is by measuring the contribution
-- of the highest-revenue sellers to overall seller revenue.

-- SQL Concepts:
-- CTEs, JOINs, aggregate functions, window functions (RANK),
-- subqueries, filtering, and percentage calculations.


WITH seller_revenue AS (
    SELECT
        seller_id,
        SUM(price)::numeric AS revenue
    FROM order_items
    GROUP BY seller_id
),

ranked_sellers AS (
    SELECT
        seller_id,
        revenue,
        RANK() OVER (
            ORDER BY revenue DESC
        ) AS seller_rank
    FROM seller_revenue
)

SELECT
    COUNT(*) AS top_10_sellers,

    ROUND(
        SUM(revenue),
        2
    ) AS top_10_revenue,

    ROUND(
        100 * SUM(revenue)
        / (SELECT SUM(revenue) FROM seller_revenue),
        2
    ) AS revenue_percentage

FROM ranked_sellers
WHERE seller_rank <= 10;

-- Key Finding:
-- The top 10 sellers generated 1,787,241.74 in revenue,
-- representing 13.15% of total seller revenue.