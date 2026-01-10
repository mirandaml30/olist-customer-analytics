--create customer-level table from the orders table, with metrics and measures


/*1. collapse order-level table to unique-customer level, and compute a few more complex metrics now
to be re-used in the next cte, for the sake of clarity */
WITH cust_table AS(
SELECT customer_unique_id, AVG(order_amount) as avg_order_value, 
        COUNT(*) as order_count, SUM(order_amount) as realized_cost,
        MIN(order_purchase_timestamp) AS first_purchase_date,
        MAX(order_purchase_timestamp) AS last_purchase_date,
        EXTRACT(EPOCH FROM MAX(order_purchase_timestamp) - MIN(order_purchase_timestamp)) / 86400 as active_period,
        CASE
            WHEN COUNT(*) > 1 THEN 'Repeat'
            ELSE 'one-off'
        END AS repeat_custs
FROM order_info
--2. add various metrics, ranks, and segmentations to the customer-level table
GROUP BY customer_unique_id
)   SELECT customer_unique_id, avg_order_value, order_count, realized_cost,
    first_purchase_date, last_purchase_date, active_period, repeat_custs,
    RANK() OVER(ORDER BY realized_cost DESC) AS LTV_rank,
    RANK() OVER(PARTITION BY repeat_custs ORDER BY realized_cost DESC) AS segment_rank
    FROM cust_table
        