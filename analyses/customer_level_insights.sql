
--what x% of customers make up what x% of sales?
WITH quantiled_custs AS(
    SELECT NTILE(20) OVER (ORDER BY realized_cost DESC) AS quantile,
        realized_cost, order_count, active_period
    FROM customer_info
), quantile_level AS (SELECT quantile, SUM(realized_cost) AS total_income, ROUND(AVG(realized_cost), 2) as avg_realized_spend,
        SUM(order_count) AS total_order_count, ROUND(AVG(order_count), 2) AS avg_order_count
    FROM quantiled_custs
    GROUP BY quantile
) SELECT quantile, total_income, ROUND(total_income/(SUM(total_income) OVER())*100.0, 2) AS quantile_pct,
        avg_realized_spend, total_order_count, avg_order_count,
        RANK() OVER(ORDER BY total_order_count DESC) AS total_orders_count_rank, 
        RANK() OVER(ORDER BY avg_realized_spend DESC) AS avg_spend_rank
    FROM quantile_level
    ORDER BY quantile

--what % of customers are repeat, and do repeat customers place larger orders?
WITH segment_level AS( 
    SELECT repeat_custs, COUNT(*) AS customer_count, 
        ROUND(AVG(avg_order_value), 2) AS avg_order_size,
        ROUND(AVG(active_period), 2) AS avg_active_period,
        ROUND(AVG(realized_cost), 2) AS avg_realized_spend, 
        ROUND(AVG(order_count), 2) AS avg_order_count
    FROM customer_info
    GROUP BY repeat_custs
)  SELECT repeat_custs, customer_count, avg_order_size, avg_active_period, avg_realized_spend, 
        avg_order_count,
        ROUND(customer_count/SUM(customer_count) OVER() *100, 2) AS sgmnt_pct
    FROM segment_level