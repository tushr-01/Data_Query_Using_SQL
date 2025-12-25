-- List the first 5 customers from Virginia (VA) or Texas (TX) 
-- sorted by birth date (oldest to youngest)

SELECT *
FROM customers 
WHERE state IN ('VA', 'TX')
ORDER BY birth_date ASC
LIMIT 5 ; 


-- UNIONS 
-- List all orders and label them as ACTIVE if on/after 2019-01-01,
-- or ARCHIVED if before 2019-01-01

SELECT 
	order_id, 
    order_date, 
    'ACTIVE' AS status
FROM orders 
WHERE order_date >= '2019-01-01'
UNION
SELECT 
	order_id, 
    order_date, 
    'ARCHIVED' AS status
FROM orders
WHERE order_date <= '2019-01-01' ;