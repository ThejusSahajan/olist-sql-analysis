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