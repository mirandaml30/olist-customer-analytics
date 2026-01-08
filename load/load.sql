COPY customers
FROM '/data/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY orders
FROM '/data/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_items
FROM '/data/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY payments
FROM '/data/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY products
FROM '/data/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY sellers
FROM '/data/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;
