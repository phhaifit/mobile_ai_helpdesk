# Analytics Event Taxonomy

This document defines the Firebase Analytics (Google Analytics) events, parameters, and user properties used in the app. All tracking goes through `AnalyticsService`; event and screen names are centralized in `lib/core/analytics/`.

---

## Screen views

Screen views are logged automatically via `AnalyticsRouteObserver` when routes are pushed. Screen names use the constants in `AnalyticsScreen`.

| Screen name       | When it’s logged        |
|-------------------|--------------------------|
| `login`           | User opens Login screen  |
| `home`            | User opens Home screen   |

Additional screens (e.g. `home_dashboard`, `home_tickets`) can be added in `AnalyticsScreen` and logged when switching tabs or opening sub-screens.

---

## Custom events

| Event name        | Description                    | Parameters |
|-------------------|--------------------------------|------------|
| `login`           | User signed in                 | `method` (e.g. `email`), `success` (bool) |
| `ticket_created`  | A new ticket was created       | `ticket_id`, `channel` (e.g. `in_app`)    |
| `agent_used`      | User used an agent (e.g. chatbot) on a ticket | `ticket_id`, `agent_type` (e.g. `chatbot`, `human`) |
| `logout`          | User signed out                | — |

Parameter keys are defined in `AnalyticsEvent` (e.g. `paramMethod`, `paramTicketId`, `paramChannel`, `paramAgentType`, `paramSuccess`).

---

## User properties

Set after login and used for segmentation in Firebase. Cleared on logout. Names are in `AnalyticsUserProperty`.

| Property   | Description                          | Example values   |
|------------|--------------------------------------|------------------|
| `tenant_id`| Tenant/organization identifier       | `default_tenant` |
| `role`     | User role in the app                 | `agent`, `admin` |
| `plan_type`| Subscription/plan type               | `standard`, `pro`|

---

## Code references

- **Events / params:** `lib/core/analytics/analytics_event.dart`
- **Screens:** `lib/core/analytics/analytics_screen.dart`
- **User properties:** `lib/core/analytics/analytics_user_property.dart`
- **Implementation:** `lib/core/analytics/analytics_service.dart`
- **Screen tracking:** `lib/core/analytics/analytics_route_observer.dart`

When adding new events or properties, update this file and the corresponding constant classes.
