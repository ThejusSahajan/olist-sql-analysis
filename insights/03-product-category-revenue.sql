-- Business Question:
-- Which product categories generate the most revenue?

-- Business Context:
-- Identify the highest-revenue product categories to understand
-- which product segments contribute most to overall sales.

-- SQL Concepts:
-- CTEs, INNER JOIN, GROUP BY, aggregate functions,
-- window functions, type casting, percentage calculation,
-- ORDER BY and LIMIT.

WITH category_revenue AS (

    SELECT
        COALESCE(p.product_category_name, 'Unknown') AS product_category,
        COUNT(DISTINCT oi.order_id) AS orders,
        SUM(oi.price)::numeric AS total_revenue

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        COALESCE(p.product_category_name, 'Unknown')
),

category_analysis AS (

    SELECT
        product_category,
        orders,
        ROUND(total_revenue, 2) AS total_revenue,
        ROUND(
            100.0 * total_revenue
            / SUM(total_revenue) OVER (),
            2
        ) AS revenue_percentage

    FROM category_revenue
)

SELECT
    product_category,
    orders,
    total_revenue,
    revenue_percentage

FROM category_analysis

ORDER BY total_revenue DESC
LIMIT 10;

-- Key Finding:
-- Beleza_saude was the highest-revenue product category,
-- generating 1,258,681.34 in revenue and contributing 9.26%
-- of total revenue.
-- The top three categories together contributed 25.76%
-- of total revenue.  