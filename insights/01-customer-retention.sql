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
        co.customer_unique_id,
        co.order_count,
        COALESCE(SUM(oi.price)::numeric, 0) AS total_revenue
    FROM customer_orders co
    JOIN customers c
        ON c.customer_unique_id = co.customer_unique_id
    JOIN orders o
        ON o.customer_id = c.customer_id
    LEFT JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY co.customer_unique_id, co.order_count
)

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type,

    COUNT(*) AS customers,

    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS customer_percentage,

    ROUND(SUM(total_revenue), 2) AS total_revenue

FROM customer_revenue
GROUP BY 1
ORDER BY total_revenue DESC;

-- Key Finding:
-- 96.88% of customers made only one purchase,
-- while 3.12% were repeat customers.
-- Repeat customers generated 778,821.97 in revenue.
