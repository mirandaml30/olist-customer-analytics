--state-level income (over all time periods)
WITH state_level AS(
    SELECT customer_state, SUM(order_amount) AS total_income, COUNT(*) as order_count,
    ROUND(AVG(order_amount),2) AS average_order_amt
    FROM order_info
    GROUP BY customer_state
)   SELECT customer_state, total_income, average_order_amt, order_count,
    RANK() OVER(ORDER BY average_order_amt DESC) AS avg_order_rank,
    RANK() OVER(ORDER BY order_count DESC) AS order_count_rank,
    ROUND(total_income/(SUM(total_income) OVER())*100.0, 2) AS state_pct
FROM state_level
ORDER BY total_income DESC

--quarter-level income (over all time states)
WITH quarter_level AS(
    SELECT order_quarter, SUM(order_amount) AS total_income, COUNT(*) as order_count,
    ROUND(AVG(order_amount),2) AS average_order_amt
    FROM order_info
    GROUP BY order_quarter
)   SELECT order_quarter, total_income, average_order_amt, order_count,
    RANK() OVER(ORDER BY average_order_amt DESC) AS avg_order_rank,
    RANK() OVER(ORDER BY order_count DESC) AS order_count_rank,
    ROUND(total_income/(SUM(total_income) OVER())*100.0, 2) AS state_pct
FROM quarter_level
ORDER BY order_quarter