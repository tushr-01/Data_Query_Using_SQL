-- INNER JOIN
-- List all orders placed in the year 2018 
-- With the customer’s full name and the order date

SELECT 
	o.order_id, 
    c.first_name, 
    c.last_name, 
    o.order_date
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id 
	WHERE order_date BETWEEN "2018-01-01" AND "2018-12-31" ;
    
    
-- INNER JOIN WITH MULTIPLE TABLES 
-- List all clients who paid using Credit Card,
-- showing the client name and payment method details

SELECT 
	p.client_id AS Client_id,
    c.name AS Client, 
    p.payment_method AS "Payment method id",
    pm.name AS "Payment method"
FROM payments p
JOIN clients c
	ON p.client_id = c.client_id
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
WHERE payment_method = 1 ;


-- OUTER JOIN
-- Show all products and how many were ordered,
-- including those not ordered at all

SELECT 
	p.product_id, 
    p.name, 
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id ; 
    
    
-- SELF JOIN
-- For each employee, list their name, job title 
-- and the name of the manager they report to

SELECT employee_id, first_name, last_name, job_title, reports_to
FROM employees ;

SELECT 
	e.employee_id, 
    e.first_name, 
    e.last_name, 
    e.job_title, 
    m.first_name AS 'manager'
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id ;

    
-- CROSS JOINS
-- List all products with all possible shippers to plan deliveries
    
SELECT * 
FROM shippers s
CROSS JOIN products p ;