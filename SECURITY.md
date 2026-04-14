# Security Notes

## Data classification

This project currently includes only synthetic demo data intended for academic use.

## Sensitive information policy

Do not store any of the following in this repository:

- Real personal data (names, phone numbers, addresses)
- API keys, passwords, tokens
- Raw production database dumps
- Internal infrastructure hostnames or IP addresses

## Safe collaboration checklist

- Use environment variables for secrets (never hardcode credentials)
- Use least-privilege DB users for application access
- Rotate credentials before any public release
- Review pull requests for accidental secret leaks

## Incident response (basic)

If sensitive data is accidentally committed:

1. Revoke leaked secrets immediately.
2. Remove exposed data from repository history.
3. Force-rotate database and service credentials.
4. Document the fix in project history.
