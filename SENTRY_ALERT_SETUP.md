# Sentry Alert Setup Guide

This project sends errors to Sentry with environment separation:

- development: `SENTRY_DSN_DEV`
- production: `SENTRY_DSN_PROD`

## 1. Configure DSN per environment

Use Dart defines when running/building the app:

```bash
# Dev
flutter run --dart-define=ENV=dev --dart-define=SENTRY_DSN_DEV=<YOUR_DEV_DSN>

# Production build example
flutter build apk --dart-define=ENV=prod --dart-define=SENTRY_DSN_PROD=<YOUR_PROD_DSN>
```

## 2. Suggested Alert Rules in Sentry Dashboard

Create alert rules in Sentry project settings with these conditions:

1. Critical crash spike

- Type: Issue alert
- Condition: Event level is `fatal` or `error`
- Threshold: more than 10 events in 5 minutes
- Environment: `production`
- Action: send notification to Slack/Email/PagerDuty

2. New production issue

- Type: Issue alert
- Condition: First seen issue
- Environment: `production`
- Action: notify engineering channel

3. Regression detected

- Type: Issue alert
- Condition: Issue changes state from resolved to unresolved
- Environment: `production`
- Action: notify on-call engineer

4. Dev noisy error monitor

- Type: Metric alert
- Condition: error count over 30 in 10 minutes
- Environment: `development`
- Action: notify development channel only

## 3. Verify Error Reporting

1. Start app in dev with `SENTRY_DSN_DEV` set.
2. Tap the debug button "test crash" on login screen.
3. Confirm event appears in Sentry under `development`.
4. Confirm event has:

- `screen_name` tag
- user context (`id`, `email` when available)
- `tenant_id` tag
- breadcrumbs for navigation and auth actions
