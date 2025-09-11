SELECT
  DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS month,
  ROUND(SUM(oi.price + oi.freight_value), 2) AS gmv
FROM `an-analytics-portfolio.olist.orders` o
JOIN `an-analytics-portfolio.olist.order_items` oi USING (order_id)
WHERE o.order_status IN ('delivered','shipped','invoiced','processing','created')
GROUP BY 1
ORDER BY 1;
