{{
    config(materialized='table')
}}


WITH seller_fulfillment AS (
    SELECT
        oi.seller_id,
        o.order_id,
        o.order_status,
        TIMESTAMP_DIFF(o.order_approved_at, o.order_purchase_timestamp, DAY) AS days_to_approval,
        TIMESTAMP_DIFF(o.order_delivered_timestamp, o.order_approved_at, DAY) AS days_to_delivery,
        TIMESTAMP_DIFF(CAST(o.order_delivered_timestamp AS TIMESTAMP), CAST(o.order_estimated_delivery_date AS TIMESTAMP), DAY) AS estimated_vs_actual_delivery_days
    FROM supplychain-437321.supplyInfo.df_Orders o
    JOIN supplychain-437321.supplyInfo.df_OrderItems oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    seller_id,
    COUNT(order_id) AS total_orders_delivered,
    ROUND(AVG(days_to_approval),0) AS avg_days_to_approval,
    ROUND(AVG(days_to_delivery), 0) AS avg_days_to_delivery,
    ROUND(AVG(estimated_vs_actual_delivery_days), 0) AS avg_estimated_vs_actual_delivery_days
FROM seller_fulfillment
GROUP BY seller_id
ORDER BY avg_days_to_delivery
