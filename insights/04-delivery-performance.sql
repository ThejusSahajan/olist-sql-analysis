-- Business Question:
-- How does delivery performance affect customer review scores?

-- Business Context:
-- Determine whether late deliveries are associated with lower customer
-- satisfaction, helping identify the potential customer experience impact
-- of delivery delays.

-- SQL Concepts:
-- CTEs, INNER JOIN, CASE expressions, aggregate functions,
-- GROUP BY, type casting, window functions, and ROUND().

WITH delivery_analysis AS (

    SELECT
        o.order_id,
        r.review_score,

        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 'Late'
            ELSE 'On Time'
        END AS delivery_status

    FROM orders o

    INNER JOIN order_reviews r
        ON o.order_id = r.order_id

    WHERE o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)

SELECT
    delivery_status,
    COUNT(*) AS orders,
    ROUND(AVG(review_score)::numeric, 2) AS average_review_score,

    ROUND(
        100::numeric * COUNT(*)
        / SUM(COUNT(*)) OVER (),
        2
    ) AS order_percentage

FROM delivery_analysis

GROUP BY delivery_status

ORDER BY average_review_score DESC;

-- Key Finding:
-- On-time deliveries received an average review score of 4.29/5,
-- while late deliveries averaged only 2.27/5.
-- Although late deliveries represented only 6.65% of orders,
-- they were strongly associated with lower customer satisfaction.