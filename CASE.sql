-- Classify each order as High, Medium, or Low value based on its revenue

SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS order_value,
    CASE
        WHEN SUM(oi.quantity * oi.unit_price) >= 150 THEN 'High value'
        WHEN SUM(oi.quantity * oi.unit_price) >= 100 THEN 'Medium value'
        ELSE 'Low value'
    END AS order_value_band
FROM orders o
JOIN customers c  
	ON o.customer_id = c.customer_id
JOIN order_items oi 
	ON o.order_id = oi.order_id
GROUP BY
    o.order_id, o.order_date, c.customer_id, customer_name
ORDER BY order_value DESC;


-- Convert raw amounts into clear payment statuses

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.points,
    CASE
        WHEN c.points >= 3000 THEN 'Platinum'
        WHEN c.points >= 1500 THEN 'Gold'
        WHEN c.points >= 500  THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_tier
FROM customers c
ORDER BY c.points DESC;
SELECT
    i.invoice_id,
    i.client_id,
    i.invoice_total,
    i.payment_total,
    (i.invoice_total - i.payment_total) AS outstanding_amount,
    CASE
        WHEN i.payment_total = 0 THEN 'Not paid'
        WHEN i.payment_total < i.invoice_total THEN 'Partially paid'
        WHEN i.payment_total = i.invoice_total THEN 'Fully paid'
        ELSE 'Overpaid / check needed'
    END AS payment_status
FROM invoices i
ORDER BY outstanding_amount DESC;