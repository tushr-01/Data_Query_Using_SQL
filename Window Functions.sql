-- Label the 1st, 2nd, 3rd order of each customer.

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    o.order_date,
    ROW_NUMBER() OVER (
        PARTITION BY c.customer_id
        ORDER BY o.order_date
    ) AS order_number_for_customer
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, order_number_for_customer;


-- Rank customers by sales where equal revenue gets same rank.

WITH customer_rev AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o      ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, customer_name
)
SELECT
    customer_id,
    customer_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_rev
ORDER BY revenue_rank;


-- Measure gap between consecutive invoices for each client

SELECT
    i.client_id,
    i.invoice_id,
    i.invoice_date,
    LAG(i.invoice_date) OVER (
        PARTITION BY i.client_id
        ORDER BY i.invoice_date
    ) AS previous_invoice_date,
    DATEDIFF(
        i.invoice_date,
        LAG(i.invoice_date) OVER (
            PARTITION BY i.client_id
            ORDER BY i.invoice_date
        )
    ) AS days_since_previous_invoice
FROM invoices i
ORDER BY i.client_id, i.invoice_date;


-- Show current and next invoice due date in the same row

SELECT
    i.client_id,
    i.invoice_id,
    i.due_date,
    LEAD(i.due_date) OVER (
        PARTITION BY i.client_id
        ORDER BY i.due_date
    ) AS next_invoice_duedate
FROM invoices i
ORDER BY i.client_id, i.due_date;