# Olist SQL Analysis

A structured SQL learning and interview-preparation project using the **Brazilian E-Commerce Public Dataset by Olist**.

## Dataset

Dataset: Brazilian E-Commerce Public Dataset by Olist — Kaggle:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The raw CSV files are intentionally **not committed to this repository**. Download the dataset separately and place the required CSV files in `data/` for local analysis.

## Project Goals

- Build practical SQL skills using a realistic relational e-commerce dataset.
- Translate business questions into SQL queries rather than practicing syntax in isolation.
- Finish with an interview-ready analysis that combines multiple SQL concepts.

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

```text
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
  README.md
```

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
