--Shipping Status Distribution
SELECT 
	shipping_status,
	COUNT(*) AS total_shipments
FROM ecommerce.shipping
GROUP BY shipping_status;

--Delivery Performance
SELECT
    COUNT(*) FILTER (WHERE shipping_status = 'delivered') AS delivered_shipments,
    COUNT(*) FILTER (WHERE shipping_status = 'delivered')::NUMERIC
        / NULLIF(COUNT(*), 0) * 100 AS delivery_rate
FROM ecommerce.shipping;

--Shipping Duration

----Shipping Duration per Shipment
SELECT 
    shipping_id,
    shipping_status,
    delivered_at-shipped_at AS shipping_duration
FROM 
	ecommerce.shipping
WHERE 
	shipping_status = 'delivered'
ORDER BY
	 shipping_id;
----Average & Longest Shipping Duration
SELECT 
	AVG(delivered_at-shipped_at)AS average_shipping_days,
	max(delivered_at-shipped_at) AS longest_shipping_days,
	min(delivered_at-shipped_at) AS shortest_shipping_days
FROM
	ecommerce.shipping
WHERE
	shipping_status = 'delivered';
--Missing Shipping Records
SELECT 
	eo.order_id,
	eo.customer_id,
	eo.order_date
FROM 
	ecommerce.orders eo
LEFT JOIN 
	ecommerce.shipping es
ON 
	eo.order_id = es.order_id
WHERE
	es.shipping_id IS NULL;





