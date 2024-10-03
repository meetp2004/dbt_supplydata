{{
    config(materialized='table')
}}

WITH customer_orders AS (
    SELECT
        c.customer_id,
        COUNT(o.order_id) AS total_orders,
        SUM(p.payment_value) AS total_spent
    FROM supplychain-437321.supplyInfo.df_Customers c
    LEFT JOIN supplychain-437321.supplyInfo.df_Orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN supplychain-437321.supplyInfo.df_Payments p
        ON o.order_id = p.order_id
    GROUP BY c.customer_id
)
SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    co.total_orders,
    co.total_spent,
    co.total_spent / NULLIF(co.total_orders, 0) AS avg_order_value
FROM supplychain-437321.supplyInfo.df_Customers c
LEFT JOIN customer_orders co
    ON c.customer_id = co.customer_id