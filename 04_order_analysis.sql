-- Step 1: Order Metrics

SELECT
	COUNT(*) AS total_orders,
	COUNT(*) FILTER (WHERE status = 'cancelled') AS cancelled_orders,
	(COUNT(*)-COUNT(*) FILTER (WHERE status = 'cancelled')) AS valid_orders,
	CAST(COUNT(*) FILTER (WHERE status = 'cancelled') AS NUMERIC)
	/
	NULLIF(COUNT(*),0)
	* 100 AS cancellation_rate
FROM
	ecommerce.orders

	
-- Step 2: Order Details & Payment Consistency

WITH order_details AS (
	SELECT 
		eo.order_id,
		ec.first_name||' '||ec.last_name AS customer_name,
		eo.order_date,
		eo.status,
		SUM(eoi.quantity*eoi.unit_price) AS order_value

	FROM
		ecommerce.customers AS ec
	JOIN
		ecommerce.orders AS eo
	ON 
		eo.customer_id = ec.customer_id
	JOIN 
		ecommerce.order_items AS eoi
	ON 
		eo.order_id = eoi.order_id
	GROUP BY 
		eo.order_id,
		ec.first_name,
		ec.last_name,
		eo.order_date,
		eo.status	
)
SELECT
    od.order_id,
    od.customer_name,
    od.order_date,
    od.status AS order_status,
    od.order_value,
    ep.payment_status,
    ep.amount AS payment_amount,
	CASE 
        WHEN od.status = 'delivered' AND ep.payment_status = 'paid'
            THEN 'Consistent'
        WHEN od.status = 'shipped' AND ep.payment_status = 'paid'
            THEN 'Consistent'
        WHEN od.status = 'processing' AND ep.payment_status = 'pending'
            THEN 'Consistent'
        WHEN od.status = 'pending' AND ep.payment_status = 'pending'
            THEN 'Consistent'
        WHEN od.status = 'cancelled' AND ep.payment_status = 'failed'
            THEN 'Consistent'
        ELSE 'Needs Review'
    END AS payment_consistency
	FROM 
		order_details AS od
	LEFT JOIN
		ecommerce.payments AS ep
    ON 
		od.order_id = ep.order_id
	ORDER BY 
		od.order_id;