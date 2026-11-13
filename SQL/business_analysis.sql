
CREATE DATABASE sales_analysis;
USE sales_analysis;
SELECT DATABASE();

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
SHOW TABLES;

INSERT INTO customers VALUES
(1, 'Rahul', 'Regular', 'India'),
(2, 'Priya', 'Premium', 'India'),
(3, 'Amit', 'Regular', 'India'),
(4, 'Sneha', 'Premium', 'USA'),
(5, 'Rohan', 'Regular', 'USA');

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 60000),
(2, 'Phone', 'Electronics', 25000),
(3, 'Chair', 'Furniture', 5000),
(4, 'Table', 'Furniture', 12000),
(5, 'Headphones', 'Accessories', 3000);

INSERT INTO orders VALUES
(101, 1, '2026-01-10'),
(102, 2, '2026-01-12'),
(103, 3, '2026-02-05'),
(104, 4, '2026-02-15'),
(105, 5, '2026-03-01'),
(106, 1, '2026-03-10'),
(107, 2, '2026-03-15');

INSERT INTO order_items VALUES
(1, 101, 1, 1, 60000),
(2, 101, 5, 2, 3000),
(3, 102, 1, 2, 60000),
(4, 102, 2, 1, 25000),
(5, 103, 3, 2, 5000),
(6, 104, 2, 3, 25000),
(7, 104, 4, 2, 12000),
(8, 105, 5, 5, 3000),
(9, 106, 2, 2, 25000),
(10, 107, 1, 1, 60000);
SELECT * FROM customers;

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;

SELECT
    c.segment,
    SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.segment
HAVING SUM(oi.quantity * oi.unit_price) > 100000;

SELECT
    product_id,
    product_name,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

WITH CustomerSales AS (
    SELECT
        c.customer_id,customers
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM CustomerSales
WHERE total_sales > 50000;

WITH CustomerSales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.country,
        SUM(oi.quantity * oi.unit_price) AS total_spending
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name, c.country
)
SELECT
    customer_id,
    customer_name,
    country,
    total_spending,
    DENSE_RANK() OVER (
        PARTITION BY country
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM CustomerSales;
SELECT DATABASE();
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE sales;
DESCRIBE products;
DESCRIBE inventory;
DESCRIBE order_items;

SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS monthly_active_users
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY month;

SELECT
    DATE_FORMAT(registration_date, '%Y-%m') AS month,
    COUNT(customer_id) AS new_customers
FROM customers
GROUP BY DATE_FORMAT(registration_date, '%Y-%m')
ORDER BY month;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(s.total_amount) AS lifetime_value
FROM customers c
JOIN sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC;

SELECT
    p.category,
    SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
SELECT * FROM sales;
SELECT * FROM products;

INSERT INTO products VALUES
(201, 'Keyboard', 'Accessories', 500),
(202, 'Laptop', 'Electronics', 1200),
(203, 'Mobile', 'Electronics', 300),
(204, 'Monitor', 'Electronics', 2000),
(205, 'Mouse', 'Accessories', 800);

SELECT * FROM products;

SELECT
    p.category,
    SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

SELECT
    DATE_FORMAT(s.sale_date, '%Y-%m') AS month,
    SUM(s.total_amount) AS monthly_revenue
FROM sales s
GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m')
ORDER BY month;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(s.total_amount) AS lifetime_value
FROM customers c
JOIN sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC;

SELECT
    c.customer_name,
    SUM(s.total_amount) AS total_spending
FROM customers c
JOIN sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_name
ORDER BY total_spending DESC
LIMIT 5;

SELECT
    DATE_FORMAT(registration_date, '%Y-%m') AS month,
    COUNT(customer_id) AS new_customers
FROM customers
GROUP BY month
ORDER BY month;

SELECT
    c.city,
    SUM(s.total_amount) AS total_revenue
FROM customers c
JOIN sales s
ON c.customer_id = s.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;