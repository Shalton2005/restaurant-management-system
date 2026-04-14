-- Migration split: seed data

USE restaurant_mgmt;

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
