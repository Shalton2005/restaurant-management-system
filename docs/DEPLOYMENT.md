# Deployment Guide

## Local setup

1. Install XAMPP or another Apache + MySQL stack.
2. Place the project folder inside the web root.
3. Copy `.env.example` to `.env` and set database credentials.
4. Start Apache and MySQL.
5. Import the database using one of these:
   - `SOURCE scripts/setup_local.sql;`
   - `SOURCE restaurant.sql;`
6. Open the app in the browser.

## URLs

- Dashboard: `public/index.php`
- Orders: `public/index.php?page=orders`
- Bills: `public/index.php?page=bills`
- Health: `public/index.php?page=health`

## Verification

- Open the dashboard and confirm metrics load.
- Create a new order.
- Add a food item to the order.
- Confirm the bill total updates automatically.
- Run `SOURCE VALIDATION_QUERIES.sql;` in MySQL to verify integrity.
