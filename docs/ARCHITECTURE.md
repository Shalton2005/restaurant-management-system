# Architecture Overview

## System summary

This project is a completed restaurant management system built on MySQL 8+ and PHP 8+.

## Main layers

- Presentation layer: Apache-served PHP pages in `public/` and `src/pages/`
- Application layer: request validation, CSRF checks, and form actions in `src/actions/`
- Data layer: database schema, triggers, procedures, and views in `restaurant.sql` and `database/`
- Configuration layer: environment variables and PDO setup in `src/config/`

## Request flow

```mermaid
flowchart LR
    A[Browser] --> B[Apache / PHP entry point]
    B --> C[Page router in public/index.php]
    C --> D[Dashboard / Orders / Bills / Health]
    D --> E[Form actions in src/actions]
    E --> F[PDO connection]
    F --> G[(MySQL database)]
    G --> H[Triggers / Views / Stored procedure]
```

## Core business behavior

- Creating an order inserts a row into `orders` and creates the linked bill.
- Adding a food item automatically recalculates the bill total through database triggers.
- Dashboard numbers are read from the live database.
- Validation queries verify referential integrity and calculated totals.

## Deployment model

- Local development: XAMPP or any Apache + MySQL stack
- Configuration: `.env` file in the project root
- Database initialization: `scripts/setup_local.sql` or `restaurant.sql`
