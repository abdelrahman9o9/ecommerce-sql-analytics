WITH customer_metrics AS (
    SELECT
        eo.customer_id,

        COUNT(DISTINCT eo.order_id)
            FILTER (WHERE eo.status != 'cancelled') AS total_orders,

        COALESCE(
            SUM(eoi.quantity * eoi.unit_price)
                FILTER (WHERE eo.status != 'cancelled'),
            0
        ) AS total_spent,

        COALESCE(
            SUM(eoi.quantity * eoi.unit_price)
                FILTER (WHERE eo.status != 'cancelled'),
            0
        ) /
        NULLIF(
            COUNT(DISTINCT eo.order_id)
                FILTER (WHERE eo.status != 'cancelled'),
            0
        ) AS average_order_value

    FROM ecommerce.orders eo
    JOIN ecommerce.order_items eoi
        ON eoi.order_id = eo.order_id
    GROUP BY eo.customer_id
)

SELECT
    ec.customer_id,
    ec.first_name || ' ' || ec.last_name AS customer_name,
    COALESCE(cm.total_orders, 0) AS total_orders,
    COALESCE(cm.total_spent, 0) AS total_spent,
    cm.average_order_value,

    DENSE_RANK() OVER (
        ORDER BY COALESCE(cm.total_spent, 0) DESC
    ) AS customer_rank

FROM ecommerce.customers ec
LEFT JOIN customer_metrics cm
    ON ec.customer_id = cm.customer_id

ORDER BY customer_rank;