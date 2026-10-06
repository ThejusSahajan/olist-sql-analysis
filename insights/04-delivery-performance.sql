-- Business Question:
-- How does delivery performance affect customer review scores?

-- Business Context:
-- Measure how often deliveries arrive late, then determine whether late
-- deliveries are associated with lower customer satisfaction, helping
-- identify the potential customer experience impact of delivery delays.

-- SQL Concepts:
-- CTEs, INNER JOIN, CASE expressions, aggregate functions, FILTER clause,
-- GROUP BY, type casting, window functions, and ROUND().


-- Query 1: Overall Late Delivery Rate
-- Population: all delivered orders (no review join).

SELECT
    COUNT(*) AS delivered_orders,

    COUNT(*) FILTER (
        WHERE order_delivered_customer_date >
              order_estimated_delivery_date
    ) AS late_orders,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date >
                  order_estimated_delivery_date
        )
        / COUNT(*),
        2
    ) AS late_delivery_rate_pct

FROM orders

WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- Query 2: Review Score by Delivery Status
-- Population: delivered orders that have a review (INNER JOIN order_reviews).
-- Note: counts review rows, so the late share here differs slightly
-- from the overall rate in Query 1.

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
-- 6.77% of delivered orders arrived after the estimated date.
-- Among reviewed delivered orders, on-time deliveries received an average
-- review score of 4.29/5, while late deliveries averaged only 2.27/5
-- (a 2.02-point gap). Late deliveries were strongly associated with
-- lower customer satisfaction.
-- (Late deliveries were 6.65% of reviewed orders, because delivered
-- orders without a review are excluded from Query 2.)
