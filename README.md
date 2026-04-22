# Restaurant Management System (DBMS)

Minimal and clean restaurant management system using MySQL 8+ and PHP 8+.

## Main Working

- Create orders from the Orders page.
- Add food items from the Bills page.
- Bill totals are automatically recalculated by database triggers.
- Dashboard shows live counts and order summary.

## Tech Stack

- PHP 8+
- MySQL 8+
- Apache (XAMPP supported)

## How To Run

1. Place this project inside xampp/htdocs.
2. Copy .env.example as .env and set DB credentials.
3. Start Apache and MySQL in XAMPP.
4. Run one of the setup scripts in MySQL:

```sql
SOURCE scripts/setup_local.sql;
```

or

```sql
SOURCE restaurant.sql;
```

5. Open in browser:

http://localhost/Restaurant%20Management%20System/public/index.php

## Main Pages

- Dashboard: /public/index.php
- Orders: /public/index.php?page=orders
- Bills: /public/index.php?page=bills
- Health: /public/index.php?page=health

## Important Files

- restaurant.sql
- scripts/setup_local.sql
- public/index.php
- src/

## Notes

- Uses synthetic sample data only.
- ER diagram and architecture docs are in docs/.
