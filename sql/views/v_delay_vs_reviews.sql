-- Late deliveries vs. review scores (by delivered month)
WITH delivered AS (
  SELECT
    order_id,
    DATE_TRUNC(DATE(order_delivered_customer_date), MONTH) AS month,
    CASE
      WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
      ELSE 0
    END AS late_flag
  FROM `an-analytics-portfolio.olist.orders`
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
),
reviews AS (
  SELECT
    order_id,
    CAST(review_score AS INT64) AS review_score
  FROM `an-analytics-portfolio.olist.reviews`  
  WHERE review_score IS NOT NULL
)
SELECT
  d.month,
  AVG(d.late_flag)                     AS late_rate,
  AVG(CAST(r.review_score AS FLOAT64)) AS avg_review_score
FROM delivered d
JOIN reviews r USING (order_id)
GROUP BY 1
ORDER BY 1;
