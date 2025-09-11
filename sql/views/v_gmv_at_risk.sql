-- GMV at risk (late deliveries) by purchase month
WITH late_orders AS (
  SELECT
    order_id
  FROM `an-analytics-portfolio.olist.orders`
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_delivered_customer_date > order_estimated_delivery_date
)
SELECT
  DATE_TRUNC(DATE(o.order_purchase_timestamp), MONTH) AS month,
  -- GMV from late-delivered orders (price + freight)
  ROUND(SUM(CASE WHEN lo.order_id IS NOT NULL THEN (oi.price + oi.freight_value) ELSE 0 END), 2) AS gmv_late,
  -- GMV from all delivered orders in the month (denominator)
  ROUND(SUM(CASE WHEN o.order_status = 'delivered' THEN (oi.price + oi.freight_value) ELSE 0 END), 2) AS gmv_delivered,
  SAFE_DIVIDE(
    SUM(CASE WHEN lo.order_id IS NOT NULL THEN (oi.price + oi.freight_value) END),
    SUM(CASE WHEN o.order_status = 'delivered' THEN (oi.price + oi.freight_value) END)
  ) AS share_gmv_late,
  -- helpful counts
  COUNT(DISTINCT CASE WHEN lo.order_id IS NOT NULL THEN o.order_id END) AS late_orders,
  COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id END) AS delivered_orders
FROM `an-analytics-portfolio.olist.orders` o
JOIN `an-analytics-portfolio.olist.order_items` oi USING (order_id)
LEFT JOIN late_orders lo USING (order_id)
GROUP BY 1
ORDER BY 1;
