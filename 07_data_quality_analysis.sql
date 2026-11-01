-- =====================================================
-- 1. Completeness Check
-- =====================================================

-- Query 1: Count NULL values in nullable columns.
SELECT
    'customers.city' AS column_name,
    COUNT(*) FILTER (WHERE city IS NULL) AS null_count
FROM ecommerce.customers

UNION ALL

SELECT
    'payments.payment_date',
    COUNT(*) FILTER (WHERE payment_date IS NULL)
FROM ecommerce.payments

UNION ALL

SELECT
    'shipping.shipping_company',
    COUNT(*) FILTER (WHERE shipping_company IS NULL)
FROM ecommerce.shipping

UNION ALL

SELECT
    'shipping.tracking_number',
    COUNT(*) FILTER (WHERE tracking_number IS NULL)
FROM ecommerce.shipping

UNION ALL

SELECT
    'shipping.shipped_at',
    COUNT(*) FILTER (WHERE shipped_at IS NULL)
FROM ecommerce.shipping

UNION ALL

SELECT
    'shipping.delivered_at',
    COUNT(*) FILTER (WHERE delivered_at IS NULL)
FROM ecommerce.shipping;


-- Query 2: Check missing payment dates by status.
SELECT
    payment_status,
    COUNT(*) AS total_records,
    COUNT(*) FILTER (WHERE payment_date IS NULL) AS missing_payment_date
FROM ecommerce.payments
GROUP BY payment_status
ORDER BY payment_status;


-- Query 3: Check missing shipping information by status.
SELECT
    shipping_status,
    COUNT(*) AS total_shipments,
    COUNT(*) FILTER (WHERE tracking_number IS NULL) AS missing_tracking_number,
    COUNT(*) FILTER (WHERE shipped_at IS NULL) AS missing_shipped_at,
    COUNT(*) FILTER (WHERE delivered_at IS NULL) AS missing_delivered_at
FROM ecommerce.shipping
GROUP BY shipping_status
ORDER BY shipping_status;


-- Query 4: Investigate payment records with missing dates.
SELECT
    p.payment_id,
    p.order_id,
    p.amount,
    p.payment_method,
    o.status AS order_status,
    p.payment_status,
    p.payment_date,
    s.shipping_status
FROM ecommerce.payments p
JOIN ecommerce.orders o
    ON p.order_id = o.order_id
JOIN ecommerce.shipping s
    ON p.order_id = s.order_id
WHERE p.payment_date IS NULL
ORDER BY p.payment_id;


-- Findings:
-- 5 payment records have missing payment dates:
-- 3 pending and 2 failed payments.
-- Missing shipping information is associated with
-- pending or cancelled shipments.
-- All delivered shipments have both shipping timestamps.
-- Failed payment dates require further investigation.
-- No data was modified.


-- =====================================================
-- 2. Uniqueness Check
-- =====================================================

-- Query 1: Check duplicate customer emails,
-- payment records, and shipping records per order.
SELECT
    'customers.email' AS checked_key,
    email AS duplicate_value,
    COUNT(*) AS duplicate_count
FROM ecommerce.customers
GROUP BY email
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'payments.order_id',
    order_id::TEXT,
    COUNT(*)
FROM ecommerce.payments
GROUP BY order_id
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'shipping.order_id',
    order_id::TEXT,
    COUNT(*)
FROM ecommerce.shipping
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Query 2: Review PRIMARY KEY and UNIQUE constraints.
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_catalog = kcu.constraint_catalog
    AND tc.constraint_schema = kcu.constraint_schema
    AND tc.constraint_name = kcu.constraint_name
    AND tc.table_name = kcu.table_name
WHERE tc.constraint_schema = 'ecommerce'
    AND tc.constraint_type IN ('PRIMARY KEY', 'UNIQUE')
ORDER BY
    tc.table_name,
    tc.constraint_name,
    kcu.ordinal_position;


-- Findings:
-- No duplicate customer emails were found.
-- No orders have multiple payment or shipping records.
-- PRIMARY KEY and UNIQUE constraints enforce
-- uniqueness on defined columns and column combinations.


-- =====================================================
-- 3. Validity Check
-- =====================================================

-- Query 1: Check for negative product prices
-- or stock quantities.
SELECT
    product_id,
    product_name,
    price,
    stock_quantity
FROM ecommerce.products
WHERE price < 0
   OR stock_quantity < 0;


-- Query 2: Check for non-positive quantities
-- or negative unit prices.
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price
FROM ecommerce.order_items
WHERE quantity <= 0
   OR unit_price < 0;


-- Query 3: Check for negative payment amounts.
SELECT
    payment_id,
    order_id,
    amount
FROM ecommerce.payments
WHERE amount < 0;


-- Query 4: Profile observed status and payment method values.
SELECT
    'orders.status' AS column_name,
    status AS value,
    COUNT(*) AS record_count
FROM ecommerce.orders
GROUP BY status

UNION ALL

SELECT
    'payments.payment_status',
    payment_status,
    COUNT(*)
FROM ecommerce.payments
GROUP BY payment_status

UNION ALL

SELECT
    'shipping.shipping_status',
    shipping_status,
    COUNT(*)
FROM ecommerce.shipping
GROUP BY shipping_status

UNION ALL

SELECT
    'payments.payment_method',
    payment_method,
    COUNT(*)
FROM ecommerce.payments
GROUP BY payment_method
ORDER BY column_name, value;


-- Query 5: Check invalid shipping timestamp order.
SELECT
    shipping_id,
    order_id,
    shipped_at,
    delivered_at
FROM ecommerce.shipping
WHERE delivered_at < shipped_at;


-- Findings:
-- No negative product prices or stock quantities were found.
-- No non-positive item quantities or negative unit prices were found.
-- No negative payment amounts were found.
-- No unexpected categorical values were identified
-- in the observed data.
-- Allowed values have not been verified against formal business rules.
-- No delivery timestamps earlier than shipping timestamps were found.


-- =====================================================
-- 4. Referential Integrity Check
-- =====================================================

-- Query 1: Check order items referencing
-- non-existing orders or products.
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id
FROM ecommerce.order_items oi
LEFT JOIN ecommerce.orders o
    ON oi.order_id = o.order_id
LEFT JOIN ecommerce.products p
    ON oi.product_id = p.product_id
WHERE o.order_id IS NULL
   OR p.product_id IS NULL;


-- Query 2: Check orders referencing non-existing customers.
SELECT
    o.order_id,
    o.customer_id
FROM ecommerce.orders o
LEFT JOIN ecommerce.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Query 3: Check payment and shipping records
-- referencing non-existing orders.
SELECT
    'payments' AS table_name,
    p.payment_id AS record_id,
    p.order_id
FROM ecommerce.payments p
LEFT JOIN ecommerce.orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'shipping',
    s.shipping_id,
    s.order_id
FROM ecommerce.shipping s
LEFT JOIN ecommerce.orders o
    ON s.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Query 4: Check products referencing non-existing categories.
SELECT
    p.product_id,
    p.product_name,
    p.category_id
FROM ecommerce.products p
LEFT JOIN ecommerce.categories c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;


-- Findings:
-- All tested foreign key relationships reference existing records.
-- No orphan records were found.
-- No data was modified.


-- =====================================================
-- 5. Consistency Check
-- =====================================================

-- Query 1: Check consistency between order,
-- payment, and shipping statuses.
SELECT
    o.status AS order_status,
    p.payment_status,
    s.shipping_status,
    COUNT(*) AS record_count
FROM ecommerce.orders o
JOIN ecommerce.payments p
    ON o.order_id = p.order_id
JOIN ecommerce.shipping s
    ON o.order_id = s.order_id
GROUP BY
    o.status,
    p.payment_status,
    s.shipping_status
ORDER BY
    o.status,
    p.payment_status,
    s.shipping_status;


-- Query 2: Identify missing or inconsistent
-- payment amounts compared with calculated order values.
WITH order_values AS (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS order_value
    FROM ecommerce.order_items
    GROUP BY order_id
)
SELECT
    o.order_id,
    p.amount AS payment_amount,
    ov.order_value
FROM ecommerce.orders o
LEFT JOIN ecommerce.payments p
    ON o.order_id = p.order_id
LEFT JOIN order_values ov
    ON o.order_id = ov.order_id
WHERE p.payment_id IS NULL
   OR ov.order_id IS NULL
   OR p.amount IS DISTINCT FROM ov.order_value
ORDER BY o.order_id;


-- Findings:
-- All observed status combinations match the expected
-- status mapping used in Task 04.
-- Payment amounts match calculated order values
-- for all 15 orders.
-- No amount inconsistencies were found.
-- No data was modified.