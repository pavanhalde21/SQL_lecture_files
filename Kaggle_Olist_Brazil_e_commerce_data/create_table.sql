-- Create a new schema to organize all Olist Brazil E-Commerce related tables
CREATE SCHEMA olist_brazil_e_commerce;

-- Customers table
CREATE TABLE olist_brazil_e_commerce.customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix NUMERIC(38,0),
    customer_city TEXT,
    customer_state TEXT
);

SELECT * FROM olist_brazil_e_commerce.customers;

-- Geolocation table
CREATE TABLE olist_brazil_e_commerce.geolocation (
    geolocation_zip_code_prefix NUMERIC(38,0),
    geolocation_lat NUMERIC(38,15),
    geolocation_lng NUMERIC(38,15),
    geolocation_city TEXT,
    geolocation_state TEXT
);

SELECT * FROM olist_brazil_e_commerce.geolocation;

-- Orders table
CREATE TABLE olist_brazil_e_commerce.orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

SELECT * FROM olist_brazil_e_commerce.orders;

-- Order Items table
CREATE TABLE olist_brazil_e_commerce.order_items (
    order_id TEXT,
    order_item_id NUMERIC(38,0),
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price NUMERIC(38,2),
    freight_value NUMERIC(38,2)
);

SELECT * FROM olist_brazil_e_commerce.order_items;

-- Order Payments table
CREATE TABLE olist_brazil_e_commerce.order_payments (
    order_id TEXT,
    payment_sequential NUMERIC(38,0),
    payment_type TEXT,
    payment_installments NUMERIC(38,0),
    payment_value NUMERIC(38,2)
);

SELECT * FROM olist_brazil_e_commerce.order_payments;

-- Order Reviews table
CREATE TABLE olist_brazil_e_commerce.order_reviews (
    review_id TEXT,
    order_id TEXT,
    review_score NUMERIC(38,0),
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

SELECT * FROM olist_brazil_e_commerce.order_reviews;

-- Example: Import CSV data into order_reviews table
-- \copy olist_brazil_e_commerce.order_reviews 
-- FROM '/Users/pavanhalde/Documents/CS/_02_CS/01_SQL/Kaggle_Olist_Brazil_e_commerce_data/olist_order_reviews_dataset.csv' 
-- DELIMITER ',' CSV HEADER;

-- Products table
CREATE TABLE olist_brazil_e_commerce.products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght NUMERIC(38,0),
    product_description_lenght NUMERIC(38,0),
    product_photos_qty NUMERIC(38,0),
    product_weight_g NUMERIC(38,0),
    product_length_cm NUMERIC(38,0),
    product_height_cm NUMERIC(38,0),
    product_width_cm NUMERIC(38,0)
);

SELECT * FROM olist_brazil_e_commerce.products;

-- Product Category Name Translation table
CREATE TABLE olist_brazil_e_commerce.product_category_name_translation (
    c1 TEXT,
    c2 TEXT
);

SELECT * FROM olist_brazil_e_commerce.product_category_name_translation;

-- Sellers table
CREATE TABLE olist_brazil_e_commerce.sellers (
    seller_id TEXT,
    seller_zip_code_prefix NUMERIC(38,0),
    seller_city TEXT,
    seller_state TEXT
);

SELECT * FROM olist_brazil_e_commerce.sellers;
