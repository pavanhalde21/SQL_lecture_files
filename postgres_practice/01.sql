-- =========================
-- DROP TABLES IF THEY EXIST
-- =========================
DROP TABLE IF EXISTS orders_table;
DROP TABLE IF EXISTS customers_table;
DROP TABLE IF EXISTS Q1_Loan_Applicants;
DROP TABLE IF EXISTS Q2_Loan_Applicants;

-- =========================
-- CREATE CUSTOMERS TABLE
-- =========================
CREATE TABLE customers_table (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone CHAR(10) UNIQUE,
    age INT CHECK (age > 18),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- CREATE ORDERS TABLE
-- =========================
CREATE TABLE orders_table (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_name VARCHAR(250),
    order_price DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers_table (customer_id)
);

-- =========================
-- INSERT INTO CUSTOMERS
-- =========================
INSERT INTO customers_table (customer_id, name, phone, age, created_at)
VALUES
    (102, 'Ram', '9876543210', 21, '2025-01-22 07:34:56'),
    (105, 'Bharat', '8765432109', 20, '2025-01-20 18:30:55'),
    (107, 'Laxman', '7654321098', 19, '2025-02-23 12:34:56'),
    (117, 'Satrughna', '6543210987', 19, '2024-12-21 19:29:22');

-- =========================
-- INSERT INTO ORDERS
-- =========================
INSERT INTO orders_table (order_id, customer_id, order_name, order_price)
VALUES
    (1001, 102, 'iPhone 16', 80000),
    (1002, 117, 'LG TV', 50000),
    (1003, 105, 'Sapiens Book', 300),
    (1004, 107, 'Table', 2000),
    (1005, 102, 'earbuds', 5000),
    (1006, 105, 'Dictionary', 100),
    (1007, 107, 'Office Chair', 3000);

-- =========================
-- BASIC SELECTS & FILTERS
-- =========================
SELECT * FROM customers_table;
SELECT * FROM orders_table;

SELECT order_name, order_price 
FROM orders_table
WHERE order_price > 40000;

-- =========================
-- UPDATE EXAMPLE
-- =========================
UPDATE orders_table
SET order_price = 75000
WHERE order_name = 'iPhone 16';

-- =========================
-- DELETE EXAMPLES
-- =========================
DELETE FROM orders_table
WHERE order_name = 'iPhone 16'
   OR order_id = 1004;

-- =========================
-- AGGREGATION & GROUP BY
-- =========================
SELECT customer_id, SUM(order_price) AS total_price 
FROM orders_table
GROUP BY customer_id;

SELECT customer_id, SUM(order_price) AS total_price 
FROM orders_table
GROUP BY customer_id
HAVING SUM(order_price) > 4000;

SELECT customer_id, COUNT(*) AS num_of_orders 
FROM orders_table
GROUP BY customer_id;

-- =========================
-- CREATE Q1 & Q2 LOAN TABLES
-- =========================
CREATE TABLE Q1_Loan_Applicants (
    application_id VARCHAR(10),
    loan_type VARCHAR(50)
);

INSERT INTO Q1_Loan_Applicants (application_id, loan_type)
VALUES
    ('A101', 'Home'),
    ('A102', 'Car'),
    ('A103', 'Personal'),
    ('A104', 'Business'),
    ('A105', 'Personal');

CREATE TABLE Q2_Loan_Applicants (
    application_id VARCHAR(10),
    loan_type VARCHAR(50)
);

INSERT INTO Q2_Loan_Applicants (application_id, loan_type)
VALUES
    ('A101', 'Personal'),
    ('A103', 'Car'),
    ('A107', 'Home'),
    ('A105', 'Personal');

-- =========================
-- SET OPERATIONS
-- =========================
-- UNION
SELECT application_id, loan_type FROM Q1_Loan_Applicants
UNION
SELECT application_id, loan_type FROM Q2_Loan_Applicants;

-- UNION ALL
SELECT application_id, loan_type FROM Q1_Loan_Applicants
UNION ALL
SELECT application_id, loan_type FROM Q2_Loan_Applicants;

-- INTERSECT
SELECT application_id, loan_type  
FROM Q1_Loan_Applicants
INTERSECT  
SELECT application_id, loan_type  
FROM Q2_Loan_Applicants;

-- EXCEPT (PostgreSQL)
SELECT application_id, loan_type  
FROM Q1_Loan_Applicants
EXCEPT    
SELECT application_id, loan_type  
FROM Q2_Loan_Applicants;
