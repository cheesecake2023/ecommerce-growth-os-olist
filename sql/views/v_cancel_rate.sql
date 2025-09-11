SELECT
  DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS month,
  AVG(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS cancel_rate
FROM `an-analytics-portfolio.olist.orders` o
GROUP BY 1
ORDER BY 1;
