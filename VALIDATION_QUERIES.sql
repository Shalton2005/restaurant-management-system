-- Validation queries for demo, QA and viva checks
-- Note: this file is mirrored by database/04_validation.sql
USE restaurant_mgmt;

-- 1) Table row counts
SELECT 'restaurant' AS table_name, COUNT(*) AS total_rows FROM restaurant
UNION ALL
SELECT 'customer', COUNT(*) FROM customer
UNION ALL
SELECT 'waiter', COUNT(*) FROM waiter
UNION ALL
SELECT 'chef', COUNT(*) FROM chef
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'food_item', COUNT(*) FROM food_item
UNION ALL
SELECT 'bill', COUNT(*) FROM bill;

-- 2) Check if every order has exactly one bill record
SELECT o.order_no
FROM orders o
LEFT JOIN bill b ON b.order_no = o.order_no
WHERE b.bill_no IS NULL;

-- 3) Validate bill totals against food_item line totals
SELECT
    b.order_no,
    b.total_price AS bill_total,
    IFNULL(SUM(fi.quantity * fi.unit_price), 0) AS computed_total
FROM bill b
LEFT JOIN food_item fi ON fi.order_no = b.order_no
GROUP BY b.order_no, b.total_price
HAVING ABS(b.total_price - IFNULL(SUM(fi.quantity * fi.unit_price), 0)) > 0.009;

-- 4) Business view output
SELECT * FROM vw_order_summary ORDER BY order_no;
