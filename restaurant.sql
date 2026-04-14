-- Restaurant Management System
-- Production-ready baseline schema + seed for MySQL 8+
-- Notes:
-- 1) Seed values are synthetic and non-sensitive.
-- 2) Script is idempotent: re-running will recreate objects.

CREATE DATABASE IF NOT EXISTS restaurant_mgmt
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE restaurant_mgmt;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS bill;
DROP TABLE IF EXISTS food_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS chef;
DROP TABLE IF EXISTS waiter;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS restaurant;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE restaurant (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(80) NOT NULL,
    address_line VARCHAR(150) NOT NULL,
    city VARCHAR(60) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_restaurant_name_city UNIQUE (restaurant_name, city)
);

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(80) NOT NULL,
    contact_no VARCHAR(20) NOT NULL,
    city VARCHAR(60) NOT NULL,
    restaurant_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_restaurant
        FOREIGN KEY (restaurant_id) REFERENCES restaurant (restaurant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_customer_contact_digits
        CHECK (contact_no REGEXP '^[0-9]{10,15}$')
);

CREATE TABLE waiter (
    waiter_id INT AUTO_INCREMENT PRIMARY KEY,
    waiter_name VARCHAR(80) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE chef (
    chef_id INT AUTO_INCREMENT PRIMARY KEY,
    chef_name VARCHAR(80) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_no INT AUTO_INCREMENT PRIMARY KEY,
    item_count INT NOT NULL,
    order_time TIME NOT NULL,
    customer_id INT NOT NULL,
    waiter_id INT NOT NULL,
    chef_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_orders_item_count CHECK (item_count > 0),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_waiter
        FOREIGN KEY (waiter_id) REFERENCES waiter (waiter_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_chef
        FOREIGN KEY (chef_id) REFERENCES chef (chef_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE food_item (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    item_description VARCHAR(120) NOT NULL,
    order_no INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_food_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_food_item_unit_price CHECK (unit_price >= 0),
    CONSTRAINT fk_food_item_order
        FOREIGN KEY (order_no) REFERENCES orders (order_no)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE bill (
    bill_no INT AUTO_INCREMENT PRIMARY KEY,
    total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    payment_notes VARCHAR(120),
    order_no INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_bill_total_price CHECK (total_price >= 0),
    CONSTRAINT uq_bill_order UNIQUE (order_no),
    CONSTRAINT fk_bill_order
        FOREIGN KEY (order_no) REFERENCES orders (order_no)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE INDEX idx_customer_restaurant_id ON customer (restaurant_id);
CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_orders_waiter_id ON orders (waiter_id);
CREATE INDEX idx_orders_chef_id ON orders (chef_id);
CREATE INDEX idx_food_item_order_no ON food_item (order_no);

INSERT INTO restaurant (restaurant_id, restaurant_name, address_line, city) VALUES
(1, 'Spice Bay', 'Road 11, Central District', 'Hyderabad'),
(2, 'Urban Tadka', 'Market Block A', 'Delhi'),
(3, 'Clay Oven House', 'Station Road', 'Lucknow'),
(4, 'South Spoon', 'Tech Park Avenue', 'Bengaluru'),
(5, 'Royal Platter', 'Riverfront Lane', 'Ahmedabad');

INSERT INTO customer (customer_id, customer_name, contact_no, city, restaurant_id) VALUES
(101, 'Customer One', '9000000001', 'Hyderabad', 1),
(102, 'Customer Two', '9000000002', 'Delhi', 2),
(103, 'Customer Three', '9000000003', 'Lucknow', 3),
(104, 'Customer Four', '9000000004', 'Bengaluru', 4),
(105, 'Customer Five', '9000000005', 'Ahmedabad', 5);

INSERT INTO waiter (waiter_id, waiter_name) VALUES
(201, 'Waiter A'),
(202, 'Waiter B');

INSERT INTO chef (chef_id, chef_name) VALUES
(301, 'Chef Alpha'),
(302, 'Chef Beta');

INSERT INTO orders (order_no, item_count, order_time, customer_id, waiter_id, chef_id) VALUES
(401, 3, '13:10:00', 101, 201, 301),
(402, 2, '14:00:00', 102, 202, 302),
(403, 4, '12:30:00', 103, 201, 301);

INSERT INTO bill (bill_no, total_price, payment_notes, order_no) VALUES
(601, 0.00, 'Pending calculation', 401),
(602, 0.00, 'Pending calculation', 402),
(603, 0.00, 'Pending calculation', 403);

DROP TRIGGER IF EXISTS trg_food_item_after_insert;
DROP TRIGGER IF EXISTS trg_food_item_after_update;
DROP TRIGGER IF EXISTS trg_food_item_after_delete;
DROP PROCEDURE IF EXISTS sp_recalculate_bill_total;

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

INSERT INTO food_item (food_id, quantity, unit_price, item_description, order_no) VALUES
(501, 2, 150.00, 'Chicken Biryani', 401),
(502, 1, 120.00, 'Paneer Tikka', 402),
(503, 3, 90.00, 'Samosa', 403);

DROP VIEW IF EXISTS vw_order_summary;

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
