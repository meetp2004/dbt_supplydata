{{
    config(materialized='table')
}}

WITH product_sales AS (
    SELECT
        oi.product_id,
        p.product_category_name,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        COUNT(oi.product_id) AS total_units_sold,
        SUM(oi.price) AS total_sales_value,
        AVG(oi.price) AS avg_selling_price,
        SUM(oi.shipping_charges) AS total_shipping_revenue,
        AVG(oi.shipping_charges) AS avg_shipping_charges
    FROM supplychain-437321.supplyInfo.df_OrderItems oi
    JOIN supplychain-437321.supplyInfo.df_Products p
        ON oi.product_id = p.product_id
    GROUP BY oi.product_id, p.product_category_name
)
SELECT
    product_id,
    product_category_name,
    total_orders,
    total_units_sold,
    total_sales_value,
    avg_selling_price,
    total_shipping_revenue,
    avg_shipping_charges
FROM product_sales
ORDER BY total_sales_value DESC