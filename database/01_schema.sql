-- Migration split: schema

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
