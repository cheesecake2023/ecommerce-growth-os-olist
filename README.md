# E-commerce Growth OS (Olist on BigQuery)

## Dashboard (Looker Studio)
<img width="1280" height="992" alt="image" src="https://github.com/user-attachments/assets/947455c3-0474-410f-9ce6-0b431b8a98ac" />

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

➡️ **Details:** See [Business Questions & Notes](docs/business-qs-and-notes.md) for the dataset table, metric specs, and action plan.

## So what? (executive takeaways)

- **Reliability is the leak:** Late deliveries were **9.9%** of delivered GMV in **Aug 2018** (≈ **$97,362 / $985,492**).  
- **CX tracks reliability:** When lateness spiked, scores dropped — **Sep 2018: 100% late → 1.98** avg review vs **Oct 2016: 0% late → 4.12** (**+2.14 pts**).  
- **Actionable target:** Cut late share by **2 pp** next month ⇒ ≈ **$19.7k** less GMV exposed to late delivery (0.02 × 985,492).

### What I’d do next
- **Tighten SLAs on top lanes** (seller_state → customer_state) and monitor `v_gmv_at_risk`.  
- **Proactive CX for predicted-late orders** (ETA breach signals).  
- **Category QA for cancellations** (slice `v_cancel_rate` by English category).



### ERD (logical)
```mermaid
erDiagram
  ORDERS ||--o{ ORDER_ITEMS : contains
  ORDERS }o--|| REVIEWS : has
  ORDERS }o--o{ PAYMENTS : has
  ORDER_ITEMS }o--|| PRODUCTS : references
  ORDER_ITEMS }o--|| SELLERS : sold_by
  ORDERS }o--|| CUSTOMERS : placed_by


