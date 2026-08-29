# Olist SQL Analysis

A structured SQL learning and interview-preparation project using the **Brazilian E-Commerce Public Dataset by Olist**.

## Dataset

Dataset: Brazilian E-Commerce Public Dataset by Olist — Kaggle:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The raw CSV files are intentionally **not committed to this repository**. Download the dataset separately and place the required CSV files in `data/` for local analysis.

## Tables Used

| Table | Description |
|-------|-------------|
| `orders` | Order-level status and timestamps |
| `customers` | Customer location and identifiers |
| `order_items` | Line-item level product, price, and seller data |
| `order_payments` | Payment type and value per order |
| `order_reviews` | Customer review scores and comments |
| `products` | Product category and attributes |
| `sellers` | Seller location and identifiers |
| `product_category_name_translation` | English translations of product categories |
| `geolocation` | Zip-code-based geographic reference data |

## Project Goals

- Build practical SQL skills using a realistic relational e-commerce dataset.
- Translate business questions into SQL queries rather than practicing syntax in isolation.
- Finish with an interview-ready analysis that combines multiple SQL concepts.

## Key Findings

- **Repeat Purchase Rate:** Only 3.13% of customers placed more than one order, highlighting a low level of repeat purchasing and a clear customer-retention opportunity. Repeat customers generated R$778,821.97 in revenue.
- **Seller Revenue Concentration:** The top 10 sellers generated R$1.79M in revenue, representing 13.15% of total seller revenue — useful for assessing seller concentration and dependency risk.
- **Top Product Category:** Beauty & Health leads all categories, generating approximately R$1.26M (9.26% of total revenue).
- **Delivery Performance Impact:** On-time deliveries averaged a 4.29/5 review score, compared to 2.27/5 for late deliveries — showing a strong link between delivery performance and customer satisfaction.

Full queries and business context for each finding are in [`insights/`](./insights).

## Structured Learning Progression

| # | Topic | Focus |
|---|---|---|
| 01 | SELECT + WHERE | Filtering and basic exploration |
| 02 | ORDER BY + LIMIT | Sorting and top-N analysis |
| 03 | Aggregate Functions | COUNT, SUM, AVG, MIN, MAX |
| 04 | GROUP BY + HAVING | Group-level business analysis |
| 05 | JOINs | Combining related Olist tables |
| 06 | Subqueries | Scalar, IN and NOT IN subqueries |
| 07 | EXISTS + NOT EXISTS | Existence-based filtering |
| 08 | Correlated Subqueries | Row-dependent subqueries |
| 09 | Window Functions | Ranking and analytical calculations |
| 10 | CTEs | Building readable multi-step queries |
| 11 | Final Analysis | Interview-level end-to-end business analysis |

## Business Questions

Queries are framed around realistic e-commerce questions, including:

- Customer behavior and repeat purchasing
- Revenue and order analysis
- Top products and sellers
- Revenue by location
- Delivery performance
- Customers without orders
- High-frequency customers
- Ranking and comparative analysis

## Repository Structure

olist-sql-analysis/
  data/
  01-select-where/
  02-orderby-limit/
  03-aggregate-functions/
  04-groupby-having/
  05-joins/
  06-subqueries/
  07-exists-notexists/
  08-correlated-subqueries/
  09-window-functions/
  10-ctes/
  11-final-analysis/
  insights/
    01-customer-retention.sql
    02-seller-revenue-concentration.sql
    03-product-category-revenue.sql
    04-delivery-performance.sql
  README.md

## Query Documentation Standard

Every SQL file begins with a short comment describing the **business question** the query answers. The SQL is written to demonstrate a specific technique while remaining useful for the final analysis.

## Commit Convention

Use:

```text
Add: [topic] queries - [what it covers]
```

Example:

```text
Add: correlated subqueries - customers with more than 5 orders
```

## Raw Data Policy

Do not commit the raw Olist CSV files. Keep the repository focused on SQL analysis and documentation; users can download the dataset from Kaggle using the source above.
