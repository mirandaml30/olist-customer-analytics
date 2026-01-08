-- code containing the SQL queries for analysis of customer lifetime value


--Available tables: order_items, payments, orders, customers, products, sellers

--find average purchase value (average order $ per customer)
    --1. gets a "sub table" of the total cost of each order
WITH order_cost AS( 
    SELECT order_id, SUM(payment_value) AS ocost
    FROM payments
    GROUP BY order_id
    --2. adds customer id and purchase date to the above orders/cost table
), cust_order_cost AS( 
    SELECT customer_id, o.order_id, ocost, order_purchase_timestamp
    FROM orders o JOIN order_cost oc
        ON o.order_id = oc.order_id
    /*3. collapses table from order-level to unique customer level, and for each customer adds
    average dollar purchase amount, number of purchases, first and last purchase dates,
    and the active period of each customer.*/
), customer_metrics AS(
     SELECT customer_unique_id, AVG(ocost) as avg_order_value, COUNT(*) as order_count,
        MIN(order_purchase_timestamp) AS first_purchase_date,
        MAX(order_purchase_timestamp) AS last_purchase_date,
        MAX(order_purchase_timestamp) - MIN(order_purchase_timestamp) as active_period
    FROM cust_order_cost coc
    LEFT JOIN customers cu on coc.customer_id = cu.customer_id
    GROUP BY customer_unique_id -- some people have multiple customer_ids (multiple orders), so group by people
), SELECT customer_unique_id, avg_order_value, order_count, active_period
--find customer purchase frequency
