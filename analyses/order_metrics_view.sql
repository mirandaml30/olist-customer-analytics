-- create the "main" view of order level order information/stats, for other analyses to be run from


--Get all relevent order-level information all in one place
    /*1. collapse payments to be order-level: some orders were paid in multiple payments */
CREATE OR REPLACE VIEW order_info AS
WITH orders_cost AS( 
    SELECT order_id, SUM(payment_value) AS order_amount
    FROM payments
    GROUP BY order_id
    /*2.  get all order information: customer, total cost of the order across all payments
        from above "query", and order time, and order quarter */
), customer_order_costs AS( 
    SELECT o.order_id, customer_id, order_amount, order_purchase_timestamp,
        EXTRACT(QUARTER FROM order_purchase_timestamp) AS order_quarter
    FROM orders o JOIN orders_cost oc ON o.order_id = oc.order_id
    /*3. add customer information to each order*/
)   SELECT order_id, coc.customer_id, customer_unique_id, order_amount, customer_state, order_purchase_timestamp,
        order_quarter
    FROM customer_order_costs coc
    LEFT JOIN customers cu ON coc.customer_id = cu.customer_id


