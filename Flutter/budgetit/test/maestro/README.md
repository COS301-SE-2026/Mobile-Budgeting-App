# Maestro E2E structure

This folder is organized by test scope so new flows stay easy to find and run.

## Suggested layout

- `smoke/` — fast end-to-end checks for core app health
- `auth/` — login, guest, register, logout, password reset
- `dashboard/` — dashboard-specific flows and assertions
- `transactions/` — add/edit/delete transaction flows

## Naming convention

Use descriptive flow filenames, for example:

- `smoke/guest_to_dashboard.yaml`
- `auth/login.yaml`
- `transactions/add_transaction.yaml`

## Secrets / login credentials

The online-login flow expects these environment variables at runtime:

- `MAESTRO_LOGIN_EMAIL`
- `MAESTRO_LOGIN_PASSWORD`

Keep the real values in a local `.env` file or export them in your shell before running Maestro. A safe template lives at `auth/.env.example`.

You can also use `scripts/test/run_maestro_flow.sh` to source the `.env` file and run a flow in one step.

## Current flows

- `smoke/guest_to_dashboard.yaml` — launches the app, verifies `Continue as Guest`, and confirms the dashboard loads
- `auth/login.yaml` — launches the app, verifies the login fields, signs in with env-provided credentials, and confirms the dashboard loads
- `auth/invalid_login.yaml` — launches the app, tries a bad password, checks the error message, and confirms the dashboard does not load
