WITH product_metrics AS (
SELECT
	product_id,
	SUM(quantity) AS Units_Sold,
	COUNT(DISTINCT eoi.order_id) AS total_orders,
	SUM(quantity * unit_price) AS total_revenue
FROM 
	ecommerce.order_items eoi
join 
	ecommerce.orders eo
ON
	eo.order_id = eoi.order_id
WHERE eo.status != 'cancelled'
GROUP BY product_id
)
SELECT
	ec.product_id,
	product_name,
	category_name,
	COALESCE(Units_Sold, 0) AS units_sold,
	COALESCE(total_orders, 0) AS total_orders,
	COALESCE(total_revenue, 0) AS total_revenue,
	DENSE_RANK() OVER (
	PARTITION BY ec.category_id
    ORDER BY COALESCE (total_revenue,0) DESC
)AS product_rank

FROM ecommerce.products ec
LEFT JOIN product_metrics pm
	ON ec.product_id=pm.product_id
JOIN ecommerce.categories cat
    ON ec.category_id = cat.category_id






