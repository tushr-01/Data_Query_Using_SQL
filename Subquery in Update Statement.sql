-- SUBQUERY IN UPDATE STATEMENT
-- Update 'Myworks’ invoices to pay 50% and 
-- set the payment date to the due date

UPDATE invoices 
SET 
    payment_total = ROUND(invoice_total * 0.5, 2), 
    payment_date = due_date
WHERE client_id IN 
            (SELECT client_id 
            FROM clients
            WHERE name = 'Myworks');