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


