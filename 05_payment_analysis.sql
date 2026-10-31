--Payment Status Analysis
SELECT
    payment_status,
	COUNT(*) AS total_payments,
	SUM(amount) AS total_amount,
	AVG(amount) AS average_amount
FROM ecommerce.payments
GROUP BY payment_status;

--Payment Method Analysis
SELECT
    payment_method,
	COUNT(*) AS total_payments,
	SUM(amount) AS total_amount,
	AVG(amount) AS average_amount,
	COUNT(*) FILTER (WHERE payment_status = 'paid') AS paid_payments,
	COUNT(*) FILTER (WHERE payment_status = 'pending') AS pending_payments,
	COUNT(*) FILTER (WHERE payment_status = 'failed') AS failed_payments
FROM ecommerce.payments
GROUP BY payment_method;

--Missing Payment Records
SELECT 
	eo.order_id,
	first_name||' '||last_name AS customer_name,
	order_date,
	eo.status AS order_status
FROM ecommerce.orders eo
JOIN ecommerce.customers ec
ON eo.customer_id = ec.customer_id
LEFT JOIN ecommerce.payments ep
ON eo.order_id = ep.order_id
WHERE ep.payment_id IS NULL;





