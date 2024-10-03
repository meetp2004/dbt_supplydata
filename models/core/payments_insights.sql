{{
    config(materialized='table')
}}

WITH payment_summary AS (
    SELECT
        order_id,
        COUNT(payment_type) AS payment_count,
        MAX(payment_type) AS most_frequent_payment_type,
        SUM(payment_value) AS total_payment_value
    FROM supplychain-437321.supplyInfo.df_Payments
    GROUP BY order_id
)
SELECT
    p.order_id,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    ps.total_payment_value,
    ps.most_frequent_payment_type
FROM supplychain-437321.supplyInfo.df_Payments p
LEFT JOIN payment_summary ps
    ON p.order_id = ps.order_id