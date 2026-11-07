USE bikestores;

-- SECTION 1 

-- Task 1
SELECT product_name, model_year, list_price
FROM production.products;
GO

-- Task 2
SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000;
GO

-- Task 3
SELECT *
FROM sales.customers
WHERE state = 'NY';
GO

-- Task 4
SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2017;
GO

-- Task 5
SELECT *
FROM production.products
WHERE product_name LIKE '%Trek%';
GO

-- Task 6
SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;
GO

-- Task 7
SELECT DISTINCT city
FROM sales.customers;
GO

-- Task 8
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;
GO
