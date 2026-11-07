SELECT
c.first_name + '' + c.last_name AS full_customer_name,
p.product_name,
o.order_date,
oi.list_price
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.order_id
INNER JOIN sales.order_items AS oi
ON o.order_id = oi.order_id
INNER JOIN production.products AS p
ON oi.product_id = p.product_id;

CREATE VIEW vw_customer_orders AS
SELECT
c.first_name + '' + c.last_name AS full_customer_name,
p.product_name,
o.order_date,
oi.list_price
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.order_id
INNER JOIN sales.order_items AS oi
ON o.order_id = oi.order_id
INNER JOIN production.products AS p
ON oi.product_id = p.product_id;

CREATE OR ALTER VIEW vw_customer_orders AS
SELECT
c.first_name + '' + c.last_name AS full_customer_name,
p.product_name,
o.order_date,
o.order_id,
o.order_status,
oi.list_price

FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.order_id
INNER JOIN sales.order_items AS oi
ON o.order_id = oi.order_id
INNER JOIN production.products AS p
ON oi.product_id = p.product_id;

SELECT *
FROM [dbo].[vw_customer_orders];


CREATE VIEW sales.vw_customer_contect AS
SELECT
customer_id,
first_name,
last_name,
city
FROM sales.customers

SELECT* FROM sales.vw_customer_contect

SELECT 
    category_id, 
    brand_id, 
    COUNT(*) AS total_products
FROM production.products
GROUP BY category_id, brand_id
ORDER BY category_id, brand_id;

SELECT 
    category_id, 
    COUNT(*) AS total_products
FROM production.products
GROUP BY category_id;

SELECT 
    brand_id, 
    COUNT(*) AS total_products
FROM production.products
GROUP BY brand_id;

WITH customer_ordered AS (
    SELECT 
        c.first_name + ' ' + c.last_name AS full_name,
        c.email,
        o.order_status,
        o.staff_id
    FROM sales.customers c
    INNER JOIN sales.orders o
        ON c.customer_id = o.customer_id
),
orders_by_staff AS (
    SELECT 
        co.full_name,
        co.email,
        co.order_status,
        s.first_name + ' ' + s.last_name AS staff_name,
        s.manager_id
    FROM customer_ordered co
    INNER JOIN sales.staffs s
        ON co.staff_id = s.staff_id
),
order_by_manager AS (
    SELECT 
        obs.full_name,
        obs.email,
        obs.order_status,
        obs.staff_name,
        m.first_name + ' ' + m.last_name AS manager_name
    FROM orders_by_staff obs
    INNER JOIN sales.staffs m
        ON obs.manager_id = m.staff_id
)
SELECT * FROM order_by_manager;
select DISTINCT (order_status) from sales.orders 
SELECT DISTINCT 
    order_status,
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'ON the way'
        WHEN 4 THEN 'Shipping'
        ELSE 'Unknown'
    END AS status_name
FROM sales.orders;

WITH customer_ordered AS (
    SELECT 
        c.first_name + ' ' + c.last_name AS full_name,
        c.email,
        -- Yahan order_status number ko name mein convert kar diya hai
        CASE o.order_status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Processing'
            WHEN 3 THEN 'ON the way'
            WHEN 4 THEN 'Shipping'
            ELSE 'Unknown'
        END AS order_status,
        o.staff_id
    FROM sales.customers c
    INNER JOIN sales.orders o
        ON c.customer_id = o.customer_id
),
orders_by_staff AS (
    SELECT 
        co.full_name,
        co.email,
        co.order_status,
        s.first_name + ' ' + s.last_name AS staff_name,
        s.manager_id
    FROM customer_ordered co
    INNER JOIN sales.staffs s
        ON co.staff_id = s.staff_id
),
order_by_manager AS (
    SELECT 
        obs.full_name,
        obs.email,
        obs.order_status,
        obs.staff_name,
        m.first_name + ' ' + m.last_name AS manager_name
    FROM orders_by_staff obs
    INNER JOIN sales.staffs m
        ON obs.manager_id = m.staff_id
)
SELECT * FROM order_by_manager;


WITH customer_ordered AS (
    SELECT 
        c.first_name + ' ' + c.last_name AS full_name,
        c.email,
        o.order_id,
        o.order_status,
        o.staff_id
    FROM sales.customers c
    INNER JOIN sales.orders o
        ON c.customer_id = o.customer_id
),

customer_ordered_product AS (
    SELECT
        co.full_name,
        co.email,
        co.order_id,
        co.order_status,
        co.staff_id,
        p.product_name
    FROM customer_ordered co
    INNER JOIN sales.order_items oi
        ON co.order_id = oi.order_id
    INNER JOIN production.products p
        ON oi.product_id = p.product_id
),

order_by_staff AS (
    SELECT 
        cop.full_name,
        cop.email,
        cop.order_id,
        cop.product_name,
        cop.order_status,
        s.first_name + ' ' + s.last_name AS staff_name,
        s.manager_id
    FROM customer_ordered_product cop
    INNER JOIN sales.staffs s
        ON cop.staff_id = s.staff_id
),

order_by_manager AS (
    SELECT 
        obs.full_name,
        obs.email,
        obs.order_id,
        obs.product_name,
        CASE
            WHEN obs.order_status = 1 THEN 'Initial Arrived'
            WHEN obs.order_status = 2 THEN 'Packing Done'
            WHEN obs.order_status = 3 THEN 'In Progress'
            WHEN obs.order_status = 4 THEN 'Shipped'
            ELSE 'Invalid'
        END AS order_status,
        obs.staff_name,
        m.first_name + ' ' + m.last_name AS manager_name
    FROM order_by_staff obs
    INNER JOIN sales.staffs m
        ON obs.manager_id = m.staff_id
)

SELECT *
FROM order_by_manager;