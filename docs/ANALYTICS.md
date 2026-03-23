# Analytics Event Taxonomy

This document defines the Firebase Analytics (Google Analytics) events, parameters, and user properties used in the app. All tracking goes through `AnalyticsService`; event and screen names are centralized in `lib/core/analytics/`.

---

## Screen views

Screen views are logged when:

1. **Named routes** — `AnalyticsRouteObserver` handles `Navigator.push` and **`Navigator.pushReplacement`** (`didPush` / `didReplace`), so flows like login → home are tracked.
2. **Home tabs** — When the user switches tabs on `HomeScreen`, a screen view is logged for the active tab (`home_dashboard`, `home_tickets`, etc.).

Screen names use the constants in `AnalyticsScreen`.

| Screen name | When it’s logged |
|-------------|------------------|
| `login` | Login route (`/login`) |
| `register` | Registration |
| `forgot_password` | Forgot password |
| `reset_password` | Reset password |
| `home` | Home shell route (`/home`) |
| `home_dashboard` | Home → Dashboard tab |
| `home_tickets` | Home → Tickets tab |
| `home_omnichannel` | Home → Omnichannel tab |
| `home_monetization` | Home → Monetization tab |
| `profile` | Profile |
| `change_password` | Change password |
| `omnichannel_hub` | Omnichannel hub |
| `messenger_dashboard` | Messenger dashboard |
| `messenger_oauth_status` | Messenger OAuth status |
| `messenger_customer_sync` | Messenger customer sync |
| `messenger_settings` | Messenger settings |
| `zalo_overview` | Zalo overview |
| `zalo_connect_qr` | Zalo connect QR |
| `zalo_oauth_management` | Zalo OAuth management |
| `zalo_sync_status` | Zalo sync status |
| `zalo_account_assignment` | Zalo account assignment |
| `zalo_personal_message` | Zalo personal message |
| `monetization` | Monetization screen |
| `upgrade_payment` | Upgrade payment |
| `upgrade_confirmation` | Upgrade confirmation |

---

## Custom events

| Event name | Description | Parameters |
|------------|-------------|------------|
| `login` | User signed in | `method` (e.g. `email`), `success` (bool) |
| `ticket_created` | A new ticket was created | `ticket_id`, `channel` (e.g. `in_app`) |
| `agent_used` | User used an agent (e.g. chatbot) on a ticket | `ticket_id`, `agent_type` (e.g. `chatbot`, `human`) |
| `logout` | User signed out | — |

Parameter keys are defined in `AnalyticsEvent` (e.g. `paramMethod`, `paramTicketId`, `paramChannel`, `paramAgentType`, `paramSuccess`).

---

## User properties

Set after login and cleared on logout. Names are in `AnalyticsUserProperty`.

| Property | Description | Example values |
|----------|-------------|----------------|
| `tenant_id` | Tenant/organization identifier | `default_tenant` |
| `role` | User role in the app | `agent`, `admin` |
| `plan_type` | Subscription/plan type | `standard`, `pro` |

---

## Code references

- **Events / params:** `lib/core/analytics/analytics_event.dart`
- **Screens:** `lib/core/analytics/analytics_screen.dart`
- **User properties:** `lib/core/analytics/analytics_user_property.dart`
- **Implementation:** `lib/core/analytics/analytics_service.dart`
- **Screen tracking:** `lib/core/analytics/analytics_route_observer.dart`

When adding new events or properties, update this file and the corresponding constant classes.

---

## Verifying in Firebase (DebugView / dashboard)

See **[FIREBASE_ANALYTICS_SETUP.md](./FIREBASE_ANALYTICS_SETUP.md)** for enabling debug mode on Android/iOS and viewing events in **Analytics → DebugView** and the main Analytics reports.
