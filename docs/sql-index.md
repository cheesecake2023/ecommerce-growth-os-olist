# SQL Index (Olist on BigQuery)

This page maps **business questions → BigQuery view → SQL file** so reviewers can jump straight to the logic.

| Business question | View (BigQuery) | SQL file |
|---|---|---|
| Where is growth trending? | `olist_mart.v_gmv_monthly` | [`sql/views/v_gmv_monthly.sql`](../sql/views/v_gmv_monthly.sql) |
| Where do we miss ETA? | `olist_mart.v_on_time_rate` | [`sql/views/v_on_time_rate.sql`](../sql/views/v_on_time_rate.sql) |
| Where do cancellations spike? | `olist_mart.v_cancel_rate` | [`sql/views/v_cancel_rate.sql`](../sql/views/v_cancel_rate.sql) |
| Do on-time first orders lift 30-day repeat? | `olist_mart.v_repeat_rate_30d` | [`sql/views/v_repeat_rate_30d.sql`](../sql/views/v_repeat_rate_30d.sql) |
| Is sentiment falling where lateness rises? | `olist_mart.v_delay_vs_reviews` & `olist_mart.v_nps_proxy` | [`sql/views/v_delay_vs_reviews.sql`](../sql/views/v_delay_vs_reviews.sql), [`sql/views/v_nps_proxy.sql`](../sql/views/v_nps_proxy.sql) |
| How much GMV is at risk due to lateness? | `olist_mart.v_gmv_at_risk` | [`sql/views/v_gmv_at_risk.sql`](../sql/views/v_gmv_at_risk.sql) |

> BigQuery project: `an-analytics-portfolio`  
> Datasets: `olist` (raw), `olist_mart` (modeled views)
