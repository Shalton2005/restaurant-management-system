# Contributing Guide

## Branch strategy

- Branch from `main` using `feature/<short-name>` or `fix/<short-name>`.
- Keep pull requests focused to one concern.

## Commit message convention

Use Conventional Commits:

- `feat:` for new functionality
- `fix:` for bug fixes
- `docs:` for documentation changes
- `chore:` for maintenance tasks

Examples:

- `feat(db): split schema into migration files`
- `fix(web): validate order references before insert`
- `docs(setup): update xampp runbook`

## SQL change policy

- Update migration files in `database/` first.
- Keep `restaurant.sql` aligned as full-run fallback.
- Include at least one validation query update if schema logic changes.

## Security expectations

- Never commit `.env` or credentials.
- Never commit real personal customer data.
- Use synthetic values for demos and screenshots.

## Pull request checklist

- Confirm setup from clean local environment
- Run `SOURCE scripts/setup_local.sql;`
- Run validation checks from `database/04_validation.sql`
- Verify dashboard, orders, bills, and health pages
