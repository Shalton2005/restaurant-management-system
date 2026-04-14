-- Migration split: procedures, triggers, views, and transactional seed

USE restaurant_mgmt;

DROP TRIGGER IF EXISTS trg_food_item_after_insert;
DROP TRIGGER IF EXISTS trg_food_item_after_update;
DROP TRIGGER IF EXISTS trg_food_item_after_delete;
DROP PROCEDURE IF EXISTS sp_recalculate_bill_total;
DROP VIEW IF EXISTS vw_order_summary;

DELIMITER $$

CREATE PROCEDURE sp_recalculate_bill_total (IN p_order_no INT)
BEGIN
    UPDATE bill b
    SET b.total_price = (
        SELECT IFNULL(SUM(fi.quantity * fi.unit_price), 0)
        FROM food_item fi
        WHERE fi.order_no = p_order_no
    )
    WHERE b.order_no = p_order_no;
END$$

CREATE TRIGGER trg_food_item_after_insert
AFTER INSERT ON food_item
FOR EACH ROW
BEGIN
    CALL sp_recalculate_bill_total(NEW.order_no);
END$$

CREATE TRIGGER trg_food_item_after_update
AFTER UPDATE ON food_item
FOR EACH ROW
BEGIN
    CALL sp_recalculate_bill_total(OLD.order_no);
    IF NEW.order_no <> OLD.order_no THEN
        CALL sp_recalculate_bill_total(NEW.order_no);
    END IF;
END$$

CREATE TRIGGER trg_food_item_after_delete
AFTER DELETE ON food_item
FOR EACH ROW
BEGIN
    CALL sp_recalculate_bill_total(OLD.order_no);
END$$

DELIMITER ;

CREATE VIEW vw_order_summary AS
SELECT
    o.order_no,
    c.customer_name,
    r.restaurant_name,
    o.order_time,
    b.total_price,
    b.payment_notes
FROM orders o
JOIN customer c ON c.customer_id = o.customer_id
JOIN restaurant r ON r.restaurant_id = c.restaurant_id
JOIN bill b ON b.order_no = o.order_no;

INSERT INTO food_item (food_id, quantity, unit_price, item_description, order_no) VALUES
(501, 2, 150.00, 'Chicken Biryani', 401),
(502, 1, 120.00, 'Paneer Tikka', 402),
(503, 3, 90.00, 'Samosa', 403);
