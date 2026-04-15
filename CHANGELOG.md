# Changelog

All notable changes to this project are documented in this file.

## [1.0.0] - 2026-04-15

### Added

- Final architecture, ERD, and deployment documentation.
- Completed project presentation as a single production-ready release.

### Changed

- Unified the repository into a finished project view without planning labels.
- Refined README content to describe the final application state.

## [0.2.0] - 2026-04-14

### Added

- Migration split SQL flow:
  - `database/01_schema.sql`
  - `database/02_seed.sql`
  - `database/03_logic.sql`
  - `database/04_validation.sql`
- One-command setup runner: `scripts/setup_local.sql`
- Contribution standard document: `CONTRIBUTING.md`

### Changed

- Hardened PHP action validation for order creation and food item creation.
- Updated README with migration-based setup instructions.
- Updated project documentation status.

## [0.1.0] - 2026-04-13

### Added

- Production-ready database baseline with constraints and synthetic seed data.
- Bill recalculation procedure and triggers.
- PHP Apache-compatible web application layer.
- XAMPP setup guidance.
