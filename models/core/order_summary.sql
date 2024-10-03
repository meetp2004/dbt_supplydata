{{
    config(materialized='table')
}}

WITH payment_summary AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment
    FROM supplychain-437321.supplyInfo.df_Payments
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_timestamp,
    o.order_estimated_delivery_date,
    p.total_payment
FROM supplychain-437321.supplyInfo.df_Orders o LEFT JOIN payment_summary p ON o.order_id = p.order_id