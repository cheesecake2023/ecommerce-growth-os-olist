# Business Questions & Notes (Olist on BigQuery)

This doc complements the README with the questions we answer, why they matter, and the exact views/outputs.

## 1) Key Business Questions (decision-oriented)

| Question | Why it matters | View / Output | Decision lever |
|---|---|---|---|
| Where is growth trending? | Understand seasonality and momentum | `v_gmv_monthly` | Category/seller focus, promo timing |
| Where do we miss ETA? | Reliability drives CX & retention | `v_on_time_rate` | SLAs, logistics, seller coaching |
| Where do cancellations spike? | Waste & churn risk | `v_cancel_rate` | Assortment/QA, inventory accuracy |
| Do on-time first orders lift 30-day repeat? | Justifies ops vs. discounting | `v_repeat_rate_30d` | Ops investment, onboarding comms |
| Is sentiment falling where lateness rises? | Tie ops to CX outcomes | `v_delay_vs_reviews`, `v_nps_proxy` | Proactive CS, policy, ETA comms |
| How much GMV is at risk due to lateness? | Prioritize what to fix first | `v_gmv_at_risk` | Fix top late lanes/categories |



## 2) Dataset Inventory (what we used)

| Table | Grain / Key | What it contains | Notes |
|---|---|---|---|
| `olist.orders` | 1 row / `order_id` | purchase/approved/delivered/estimated timestamps, status, `customer_id` | Delivery timing, cancellations |
| `olist.order_items` | 1 row / `order_id + order_item_id` | `price`, `freight_value`, `product_id`, `seller_id` | GMV, category, seller |
| `olist.order_reviews` | 1 row / `order_id` | `review_score` (1–5) | We use score only (language-agnostic) |
| `olist.order_payments` | 1+ rows / `order_id` | method, installments, value | Optional detail |
| `olist.customers` | 1 row / `customer_id` | city/state | Cohorts, geo cuts |
| `olist.sellers` | 1 row / `seller_id` | city/state | Lane analysis |
| `olist.products` | 1 row / `product_id` | category (PT) | Join to translation |
| `olist.product_category_name_translation` | 1 row / category | PT → English | English labels in charts |

## 3) Metric Specs (concise)

| Metric | Definition (short) | Time grain | Filters / Assumptions |
|---|---|---|---|
| GMV | Σ(`price + freight_value`) | Purchase month | Exclude `canceled` (or document if in-flight included) |
| On-time rate | % delivered with `delivered ≤ estimated` | Delivered month | Delivered only; filter absurd dates |
| Cancel rate | % with `status='canceled'` | Purchase month | — |
| Repeat 30d | New customers with 2nd order ≤ 30 days | Cohort (first purchase) | Delivered/in-flight per your rule |
| NPS proxy | %Promoters(4–5) − %Detractors(1–2) | Purchase month | Score only (no text) |
| GMV at risk | GMV of late-delivered ÷ delivered GMV | Purchase month | Late defined by delivered > estimated |

## 4) Assumptions & Data Quality

- Keys unique (`order_id`; `order_item_id` per order).  
- Date sanity: `delivered ≥ purchase`, `estimated ≥ purchase`.  
- Reviews: use `review_score` numeric only.  
- Categories: Portuguese mapped to English via translation table.  

## 5) Initial Findings (fill after you look at the views)

- Late deliveries represented {9.9}% of delivered GMV in {August 2018}, totaling ${97362.0} out of ${985492.0}. 
- In September 2018, the late-delivery rate was 100.0% and the average review score was 1.98; in October 2016, the late rate was 0.0% with an average score of 4.12—a +2.14-point difference, confirming that higher lateness coincides with lower customer scores.

## 6) Actions (prioritized)

| Action | Owner | Rationale | Expected impact | Next step |
|---|---|---|---|---|
| Tighten SLA on top 3 late lanes | Ops | High GMV at risk | +2 pp on-time → ~$<est> GMV | Pilot with top sellers |
| Proactive CS for predicted-late | CX | Reduce detractors | ↑ NPS / retention | Messaging test |
| QA for high-cancel categories | Supply | Stock/quality issues | ↓ cancel rate | Vendor audit |
