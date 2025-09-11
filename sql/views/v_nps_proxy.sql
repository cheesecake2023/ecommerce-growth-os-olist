SELECT
  DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS month,
  -- NPS proxy = %Promoters - %Detractors
  AVG(CASE WHEN CAST(r.review_score AS INT64) >= 4 THEN 1 ELSE 0 END)
  - AVG(CASE WHEN CAST(r.review_score AS INT64) <= 2 THEN 1 ELSE 0 END) AS nps_proxy
FROM `an-analytics-portfolio.olist.orders` o
JOIN `an-analytics-portfolio.olist.reviews` r
  ON o.order_id = r.order_id
GROUP BY 1
ORDER BY 1;
