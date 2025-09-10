# E-commerce Growth OS (Olist on BigQuery)

**TL;DR**  
I built a decision-ready KPI layer in BigQuery for a marketplace: GMV, On-time Delivery, Cancellations, 30-day Repeat, and an NPS proxy—plus diagnostics that show how delivery reliability impacts customer sentiment and GMV at risk.

## Why this project
Leaders need a trustworthy view of growth leaks (late deliveries, cancellations, weak repeats) and a way to prioritize fixes (lanes, categories, seller cohorts). Olist is realistic, public, and reproducible.

## Data & Environment
- Warehouse: **BigQuery** (project: `an-analytics-portfolio`)
- Datasets: `olist` (raw), `olist_mart` (modeled views)
- Tables used: `orders`, `order_items`, `order_reviews`, `order_payments`, `customers`, `sellers`, `products`, `product_category_name_translation`

## Modeling (high level)
- **Facts:**  
  - `f_orders` (grain: `order_id`) — statuses & delivery timing  
  - `f_order_items` (grain: `order_id + order_item_id`) — GMV (price + freight), category, seller
- **Dimensions:** `d_customer`, `d_seller`, `d_product`, `d_date`
- **Reviews:** joined at order grain (use numeric `review_score` only)
- **Principle:** keep raw ingest resilient; enforce typing & business rules in the **metric layer** (views)

### ERD (logical)
```mermaid
erDiagram
  ORDERS ||--o{ ORDER_ITEMS : contains
  ORDERS }o--|| REVIEWS : has
  ORDERS }o--o{ PAYMENTS : has
  ORDER_ITEMS }o--|| PRODUCTS : references
  ORDER_ITEMS }o--|| SELLERS : sold_by
  ORDERS }o--|| CUSTOMERS : placed_by

## Metric Catalog (definitions I used)

| Metric | Definition | Grain (time) | Main cuts (dimensions) | Notes & assumptions |
|---|---|---|---|---|
| **GMV** | Sum of item price + freight for qualifying items | Month (by purchase date) | category (English), seller_state, customer_state | Exclude `canceled`. You can report both **in-flight** (created/processing/shipped) and **delivered-only**; call out which you used in Findings. |
| **On-time delivery rate** | % of **delivered** orders where delivered_date ≤ estimated_date | Month (by delivered date) | seller_state, customer_state, category (English) | Only `order_status='delivered'`. Filter obviously bad timestamps if any. |
| **Cancellation rate** | % of orders with `order_status='canceled'` | Month (by purchase date) | category (English), seller_state | Signals stock/ops issues earlier in the funnel. |
| **30-day repeat rate** | % of **new-customer cohorts** who place a 2nd order within 30 days | Cohort month (first purchase) | acquisition month, customer_state | Early retention signal; cohort logic documented. |
| **NPS proxy** | %Promoters (scores 4–5) − %Detractors (1–2) using numeric review_score | Month (by purchase date) | category (English), seller_state | Language-agnostic; we use the numeric score only. |
| **GMV at risk (late)** | GMV of **late-delivered** orders ÷ GMV of delivered orders | Month (by purchase date) | seller→customer lane, category (English) | Prioritizes ops work on high-impact lanes. |

