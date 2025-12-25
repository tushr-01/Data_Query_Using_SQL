-- Identify top revenue clients and their outstanding dues per client

USE invoicing;

SELECT 
    c.client_id,
    c.name AS client_name,
    COUNT(i.invoice_id) AS total_invoices,
    SUM(i.invoice_total) AS total_invoiced_amount,
    SUM(i.payment_total) AS total_paid_amount,
    SUM(i.invoice_total - i.payment_total) AS total_outstanding_amount
FROM invoices i
JOIN clients c 
	ON i.client_id = c.client_id
GROUP BY c.client_id, c.name
ORDER BY total_invoiced_amount DESC;


-- Which payment methods customers prefer and 
-- what % of collections they contribute

SELECT 
    pm.name AS payment_method,
    COUNT(p.payment_id) AS number_of_payments,
    SUM(p.amount) AS total_amount_collected,
    ROUND(100.0 * SUM(p.amount) / SUM(SUM(p.amount)) OVER (), 2) AS pct_of_total_collections
FROM payments p
JOIN payment_methods pm 
      ON p.payment_method = pm.payment_method_id
GROUP BY pm.name
ORDER BY total_amount_collected DESC;


-- Segment clients by typical ticket size

SELECT 
    c.client_id,
    c.name AS client_name,
    COUNT(i.invoice_id) AS invoice_count,
    AVG(i.invoice_total) AS avg_invoice_value,
    MIN(i.invoice_total) AS min_invoice,
    MAX(i.invoice_total) AS max_invoice
FROM invoices i
JOIN clients c ON i.client_id = c.client_id
GROUP BY c.client_id, c.name
ORDER BY avg_invoice_value DESC;


-- Rank customers by lifetime value and recency

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    AVG(oi.quantity * oi.unit_price) AS avg_order_value,
    MAX(o.order_date) AS last_order_date
FROM customers c
JOIN orders o       
	ON c.customer_id = o.customer_id
JOIN order_items oi  
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY total_revenue DESC;