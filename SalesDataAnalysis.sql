-- Create Sales Transactions Table
CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    customer_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL(10, 2),
    sales_rep_id INT,
    region_id INT
);

-- Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100)
);

-- Create Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Create Regions Table
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50)
);

-- Create Sales Representatives Table
CREATE TABLE sales_representatives (
    sales_rep_id INT PRIMARY KEY,
    sales_rep_name VARCHAR(100)
);


-- Insert Data into Regions
INSERT INTO regions (region_id, region_name) VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West');

-- Insert Data into Products
INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Headphones', 'Electronics', 199.99),
(3, 'Coffee Maker', 'Home Appliances', 89.99),
(4, 'Desk Chair', 'Furniture', 149.99);

-- Insert Data into Sales Representatives
INSERT INTO sales_representatives (sales_rep_id, sales_rep_name) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Charlie Davis');

-- Insert Data into Customers
INSERT INTO customers (customer_id, customer_name, customer_email) VALUES
(1, 'John Doe', 'john.doe@example.com'),
(2, 'Jane Roe', 'jane.roe@example.com'),
(3, 'Jim Brown', 'jim.brown@example.com'),
(4, 'Lucy Green', 'lucy.green@example.com');

-- Insert Data into Sales Transactions
INSERT INTO sales_transactions (transaction_id, transaction_date, customer_id, product_id, quantity, total_amount, sales_rep_id, region_id) VALUES
(1, '2024-01-15', 1, 1, 1, 999.99, 1, 1),
(2, '2024-02-20', 2, 2, 2, 399.98, 2, 2),
(3, '2024-03-10', 3, 3, 1, 89.99, 1, 3),
(4, '2024-04-05', 4, 4, 1, 149.99, 3, 4),
(5, '2024-05-12', 1, 2, 3, 599.97, 2, 1),
(6, '2024-06-15', 2, 1, 1, 999.99, 3, 2);


-- Total Sales, Average Order Value, and Growth Rate by Region
WITH sales_summary AS (
    SELECT
        s.region_id,
        r.region_name,
        SUM(s.total_amount) AS total_sales,
        AVG(s.total_amount / s.quantity) AS avg_order_value,
        COUNT(s.transaction_id) AS number_of_orders
    FROM sales_transactions s
    JOIN regions r ON s.region_id = r.region_id
    GROUP BY s.region_id, r.region_name
),
growth_rates AS (
    SELECT
        region_name,
        total_sales,
        LAG(total_sales, 1) OVER (ORDER BY region_id) AS previous_sales,
        (total_sales - LAG(total_sales, 1) OVER (ORDER BY region_id)) / LAG(total_sales, 1) OVER (ORDER BY region_id) * 100 AS growth_rate
    FROM sales_summary
)
SELECT * FROM growth_rates;


-- Sales Performance by Product Category
SELECT
    p.category,
    SUM(s.total_amount) AS total_sales,
    AVG(s.total_amount / s.quantity) AS avg_order_value,
    COUNT(s.transaction_id) AS number_of_orders
FROM sales_transactions s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


-- Top-Performing Sales Representatives
SELECT
    sr.sales_rep_name,
    SUM(s.total_amount) AS total_sales,
    AVG(s.total_amount / s.quantity) AS avg_order_value,
    COUNT(s.transaction_id) AS number_of_orders
FROM sales_transactions s
JOIN sales_representatives sr ON s.sales_rep_id = sr.sales_rep_id
GROUP BY sr.sales_rep_name
ORDER BY total_sales DESC;


