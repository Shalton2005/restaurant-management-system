# Apache/XAMPP Setup Guide

## Prerequisites

- XAMPP installed (Apache + MySQL)
- PHP 8+ enabled in Apache

## Steps

1. Place project inside `xampp/htdocs/`.
2. Open project root and create `.env` from `.env.example`.
3. Set DB settings in `.env`.
4. Start MySQL and Apache from XAMPP Control Panel.
5. Open phpMyAdmin and run one of the following:
	- `SOURCE scripts/setup_local.sql;` (recommended)
	- `SOURCE restaurant.sql;` (single-file fallback)
6. Open application:

http://localhost/Restaurant%20Management%20System/public/index.php

## Default pages

- Dashboard: `/public/index.php`
- Orders: `/public/index.php?page=orders`
- Bills: `/public/index.php?page=bills`
- Health: `/public/index.php?page=health`

## Troubleshooting

- DB connection error: verify DB credentials in `.env`
- Table/view missing: execute `restaurant.sql` again
- 404 in browser: verify project folder name in URL and Apache is running
