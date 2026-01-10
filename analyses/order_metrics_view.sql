-- create the "main" view of order level order information/stats, for other analyses to be run from


--Available tables: order_items, payments, orders, customers, products, sellers

--Get all relevent order-level information all in one place
    --1. gets order information: customer, total cost of the order across all payments, and order time
CREATE OR REPLACE VIEW order_info AS
WITH order_cost AS( 
    SELECT orders.order_id, customer_id, SUM(payment_value) AS ocost, order_purchase_timestamp
    FROM payments JOIN orders on payments.order_id = orders.order_id 
    GROUP BY orders.order_id
    -- Add customer information to each order, to enable customer analysis later
)   SELECT order_id, coc.customer_id, customer_unique_id, ocost, customer_state, order_purchase_timestamp
    FROM order_cost coc
    LEFT JOIN customers cu on coc.customer_id = cu.customer_id


