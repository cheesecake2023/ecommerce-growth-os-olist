WITH firsts AS (
  SELECT
    customer_id,
    MIN(order_purchase_timestamp) AS first_dt
  FROM `an-analytics-portfolio.olist.orders`
  WHERE order_status IN ('delivered','shipped','invoiced','processing','created')
  GROUP BY 1
),
repeats AS (
  SELECT
    o.customer_id,
    MIN(o.order_purchase_timestamp) AS second_dt
  FROM `an-analytics-portfolio.olist.orders` o
  JOIN firsts f USING (customer_id)
  WHERE o.order_purchase_timestamp > f.first_dt
    AND o.order_purchase_timestamp <= TIMESTAMP_ADD(f.first_dt, INTERVAL 30 DAY)
  GROUP BY 1
)
SELECT
  DATE_TRUNC(DATE(f.first_dt), MONTH) AS cohort_month,
  COUNT(*) AS new_customers,
  COUNT(r.customer_id) AS repeat_within_30d,
  SAFE_DIVIDE(COUNT(r.customer_id), COUNT(*)) AS repeat_rate_30d
FROM firsts f
LEFT JOIN repeats r USING (customer_id)
GROUP BY 1
ORDER BY 1;
