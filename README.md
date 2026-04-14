# Restaurant Management System (DBMS)

Production-ready baseline for a Restaurant Management System using MySQL 8+.

This repository now includes a PHP + Apache compatible web application layer.

## What is included

- Robust relational schema with constraints and indexes
- Synthetic, non-sensitive seed data
- Bill recalculation procedure with insert/update/delete triggers
- Summary view for common reporting (`vw_order_summary`)
- GitHub-ready project docs
- Validation query pack for QA and project demo
- Migration-style SQL split for maintainable deployments
- One-command local setup script

## Web application module

- Runtime: PHP 8+ (Apache/XAMPP compatible)
- Entry point: `public/index.php`
- Features:
	- Dashboard metrics and order summary view
	- Create new orders
	- Add food items and auto-update bill totals
	- Health page for DB connectivity checks

## Tech stack

- SQL dialect: MySQL 8+

## Quick start

1. Create a MySQL 8+ database user with DDL/DML permissions.
2. Run either full script mode or migration mode.

Full script mode:

```sql
SOURCE restaurant.sql;
```

Migration mode (recommended for modular deployment):

```sql
SOURCE scripts/setup_local.sql;
```

3. Verify output:

```sql
SELECT * FROM vw_order_summary;
```

4. Run validation checks:

```sql
SOURCE VALIDATION_QUERIES.sql;
```

## Run with Apache (XAMPP style)

1. Copy this project folder into your XAMPP `htdocs` directory.
2. Create `.env` in project root by copying `.env.example`.
3. Set DB values in `.env`.
4. Start Apache and MySQL from XAMPP Control Panel.
5. Execute schema:

```sql
SOURCE restaurant.sql;
```

6. Open in browser:

`http://localhost/Restaurant%20Management%20System/public/index.php`

If folder name differs, update URL accordingly.

## Security and data privacy

- This repository contains only synthetic sample data.
- No real customer identities, phone numbers, or payment identifiers are used.
- Do not commit production credentials, `.env` secrets, or DB dumps with personal data.

## Repository structure

- `restaurant.sql` - complete schema, seed data, trigger, indexes, and reporting view
- `VALIDATION_QUERIES.sql` - data integrity and reporting checks
- `database/01_schema.sql` - schema and indexes
- `database/02_seed.sql` - seed data
- `database/03_logic.sql` - procedures, triggers, and view
- `database/04_validation.sql` - validation suite
- `scripts/setup_local.sql` - one-command setup runner
- `SECURITY.md` - secure usage guidance
- `public/index.php` - web app entry point for Apache/PHP
- `src/` - app configuration, pages, and form actions
- `CONTRIBUTING.md` - contribution and commit conventions
- `CHANGELOG.md` - release notes by version

## Professional upgrades from initial mini-project version

- Removed any local-host deployment URLs from code artifacts
- Upgraded naming and constraints for cleaner data governance
- Added idempotent object recreation (`DROP IF EXISTS`) for repeatable setup
- Added full bill-total synchronization logic for INSERT, UPDATE, and DELETE on `food_item`
- Added QA validation queries to demonstrate consistency during evaluation

## Suggested next production steps

1. Add a backend API (Node.js/Java/Python) with ORM migration support.
2. Add CI for schema validation and SQL formatting checks.
3. Add backup/restore automation and role-based DB access.
