SELECT
  DATE_TRUNC(DATE(o.order_delivered_customer_date), MONTH) AS month,
  AVG(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END)
    AS on_time_rate
FROM `an-analytics-portfolio.olist.orders` o
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;
