-- Business question: Which product categories generated more than 50 total order items?
-- SQL concepts: Basic CTE, replacing a subquery in FROM
 
WITH category_totals AS (
    SELECT
        p.product_category_name,
        COUNT(oi.order_item_id) AS total_items
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
SELECT *
FROM category_totals
WHERE total_items > 50;
 
 
-- Business question: Which sellers earn above the platform's average seller revenue?
-- SQL concepts: CTE feeding into a WHERE comparison against an aggregate
 
WITH seller_revenue AS (
    SELECT
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)
SELECT *
FROM seller_revenue
WHERE total_revenue > (SELECT AVG(total_revenue) FROM seller_revenue);
 
 
-- Business question: What is the average payment value per payment type, ranked from highest to lowest?
-- SQL concepts: CTE combined with a window function
 
WITH payment_summary AS (
    SELECT
        payment_type,
        AVG(payment_value) AS avg_payment
    FROM order_payments
    GROUP BY payment_type
)
SELECT
    payment_type,
    avg_payment,
    RANK() OVER (ORDER BY avg_payment DESC) AS payment_rank
FROM payment_summary;
 
 
-- Business question: Which customers placed orders with a total payment value above their own state's average?
-- SQL concepts: Multiple chained CTEs
 
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_state,
        SUM(op.payment_value) AS total_paid
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_payments op ON o.order_id = op.order_id
    GROUP BY c.customer_id, c.customer_state
),
state_averages AS (
    SELECT
        customer_state,
        AVG(total_paid) AS avg_state_payment
    FROM customer_totals
    GROUP BY customer_state
)
SELECT
    ct.customer_id,
    ct.customer_state,
    ct.total_paid
FROM customer_totals ct
JOIN state_averages sa ON ct.customer_state = sa.customer_state
WHERE ct.total_paid > sa.avg_state_payment;
 
 
-- Business question: What is the review score distribution, expressed as a percentage of total reviews?
-- SQL concepts: CTE for a total count, used in a percentage calculation
 
WITH total_reviews AS (
    SELECT COUNT(*) AS total FROM order_reviews
)
SELECT
    r.review_score,
    COUNT(*) AS score_count,
    ROUND(COUNT(*) * 100.0 / t.total, 2) AS percentage
FROM order_reviews r, total_reviews t
GROUP BY r.review_score, t.total
ORDER BY r.review_score;
 
 
-- Business question: Which products rank in the top 3 by revenue within their category?
-- SQL concepts: CTE combined with PARTITION BY window function, then filtered
 
WITH product_revenue AS (
    SELECT
        p.product_category_name,
        oi.product_id,
        SUM(oi.price) AS product_revenue,
        RANK() OVER (PARTITION BY p.product_category_name ORDER BY SUM(oi.price) DESC) AS revenue_rank
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name, oi.product_id
)
SELECT *
FROM product_revenue
WHERE revenue_rank <= 3;