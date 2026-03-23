# Omnichannel Integrations - Phase 1 (UI + Offline)

Last updated: 2026-03-21

## 1) Objective

Build a complete offline demo flow for Omnichannel Integrations (Messenger + Zalo) with mock data only.

Phase 1 goal:

- High-fidelity UI/UX aligned with current app style
- Full interaction flow using mock state transitions
- Clear success/error feedback for all user actions
- No real API call, no real OAuth handshake, no real QR scanner

Out of scope (Phase 1):

- Production OAuth to Meta/Zalo
- Real-time websocket sync
- Backend persistence
- Push notification/event processing

---

## 2) Feature Scope Breakdown

### 2.1 Messenger Integration

1. Connect/Disconnect Facebook Messenger Page UI
2. Page Settings Configuration Screen
3. OAuth Verification Flow UI (mock)
4. Customer Data Sync Status Screen
5. Page Resync UI

### 2.2 Zalo Integration

1. QR Code Scan Screen for Personal Account Connection (static mock QR)
2. OAuth Management Screen
3. Real-time Message Sync Status (mocked timeline/status)
4. CS Assignment to Zalo Accounts UI
5. Personal Message Sending UI

---

## 3) Proposed UX Flow (Phase 1)

### 3.1 Entry

- Add a new Omnichannel section entry from Home (or Integration tab area)
- Enter Omnichannel Hub screen with 2 cards:
  - Messenger Integration
  - Zalo Integration

### 3.2 Messenger Flow

- Messenger Overview
  - Show Connected/Disconnected state
  - Primary CTA:
    - Connect (when disconnected)
    - Configure / Disconnect (when connected)
- OAuth Mock Screen
  - Stepper style verification (Login -> Permission -> Success/Fail)
- Page Settings Screen
  - Toggles and select fields (auto-reply, business hours, language)
  - Save feedback snackbar
- Sync Status + Resync
  - Last sync time, success ratio, failed records
  - Resync button with loading -> success/error message

### 3.3 Zalo Flow

- Zalo Overview
  - Connection state card
  - Connect CTA
- QR Connect Screen
  - Static QR block + countdown mock + refresh mock button
- OAuth Management Screen
  - Link/Unlink account state
- Message Sync Status Screen
  - Mock live indicators (connected/degraded/disconnected)
- CS Assignment Screen
  - List of Zalo accounts and assign CS dropdown/chips
- Personal Message Screen
  - Compose box + send mock with success/error toast

---

## 4) Technical Design (Phase 1 - Implemented)

Technical stack and patterns:

- Clean Architecture boundaries (domain/data/presentation)
- MobX store for feature state and async action orchestration
- get_it for DI wiring across data/domain/presentation layers
- Named routes for all Omnichannel screens
- Offline mock repository as single source of integration state transitions

### 4.0 Runtime Navigation Behavior

- Home has 3 tabs: Dashboard, Tickets, Omnichannel.
- Omnichannel tab renders the Hub content directly (no intermediate CTA button).
- `OmnichannelHubScreen` supports both:
  - standalone route mode (`showAppBar = true`)
  - embedded tab mode (`showAppBar = false`)

### 4.1 Domain Layer

Create feature package: omnichannel

- Entity models:
  - OmnichannelOverview
  - MessengerIntegrationState
  - ZaloIntegrationState
  - ActionFeedback
  - ZaloAccountAssignment
  - IntegrationConnectionStatus
  - OAuthState
  - SyncState
- Repository interface:
  - OmnichannelRepository
- Use cases:
  - GetOmnichannelOverviewUseCase
  - ConnectMessengerUseCase
  - DisconnectMessengerUseCase
  - SyncMessengerDataUseCase
  - UpdateMessengerSettingsUseCase
  - ConnectZaloFromQrUseCase
  - DisconnectZaloUseCase
  - RetryZaloSyncUseCase
  - UpdateZaloAssignmentsUseCase

### 4.2 Data Layer

- Mock repository implementation only:
  - MockOmnichannelRepositoryImpl
- Simulate network delay using Future.delayed
- Keep mutable in-memory `_state` for Messenger + Zalo integration snapshots
- Action behavior:
  - Connect/disconnect toggles connection + oauth + sync metadata
  - Sync operations update timestamps and counters
  - Assignment save updates mapped CS owner per account
  - Certain actions return validation failures when channel is disconnected

### 4.3 Presentation Layer

Screens:

- Omnichannel hub screen
- Messenger overview screen
- Messenger OAuth mock screen
- Messenger settings screen
- Messenger sync status screen
- Zalo overview screen
- Zalo QR connect screen
- Zalo OAuth management screen
- Zalo sync status screen
- Zalo CS assignment screen
- Zalo personal message screen

Store:

- OmnichannelStore
- Observables:
  - overview
  - fetchFuture
  - actionFuture
  - actionMessageKey
  - actionWasSuccess
  - errorMessage
- Actions:
  - fetchOverview
  - connect/disconnect actions
  - sync/retry actions
  - update messenger settings
  - update zalo assignments
  - clearActionMessage

UI feedback:

- Action results are surfaced via localized Snackbar on every action screen.
- Loading state is derived from `ObservableFuture` status.
- Hub cards show real-time summary from current store state.

### 4.4 DI and Routing

- Register repository in data DI module
- Register all use cases in domain DI module
- Register store in presentation DI module (factory)
- Add route constants and route builders
- Home tab integration embeds Omnichannel hub directly for faster entry UX

---

## 5) File Plan (Implemented)

Domain:

- lib/domain/entity/omnichannel/omnichannel.dart
- lib/domain/repository/omnichannel/omnichannel_repository.dart
- lib/domain/usecase/omnichannel/\*.dart

Data:

- lib/data/repository/omnichannel/mock_omnichannel_repository_impl.dart

Presentation:

- lib/presentation/omnichannel/omnichannel_hub_screen.dart
- lib/presentation/omnichannel/messenger/messenger_dashboard_screen.dart
- lib/presentation/omnichannel/messenger/messenger_oauth_status_screen.dart
- lib/presentation/omnichannel/messenger/messenger_settings_screen.dart
- lib/presentation/omnichannel/messenger/messenger_customer_sync_screen.dart
- lib/presentation/omnichannel/zalo/zalo_integration_screen.dart
- lib/presentation/omnichannel/zalo/zalo_connect_qr_screen.dart
- lib/presentation/omnichannel/zalo/zalo_oauth_management_screen.dart
- lib/presentation/omnichannel/zalo/zalo_sync_status_screen.dart
- lib/presentation/omnichannel/zalo/zalo_account_assignment_screen.dart
- lib/presentation/omnichannel/zalo/zalo_personal_message_screen.dart
- lib/presentation/omnichannel/store/omnichannel_store.dart

Cross-cutting:

- lib/data/di/module/repository_module.dart
- lib/domain/di/module/usecase_module.dart
- lib/presentation/di/module/store_module.dart
- lib/utils/routes/routes.dart
- assets/lang/en.json
- assets/lang/vi.json

---

## 6) Acceptance Criteria Mapping

1. All integration screens implemented per design

- Implemented by dedicated Messenger and Zalo screen set above

2. Mock data simulates connected/disconnected states

- Repository mock state machine for each channel

3. QR code screen UI rendered (static mock)

- Dedicated Zalo QR connect screen with static QR widget

4. Success/error feedback for all actions

- Store action results mapped to snackbar/banner states

5. Widget tree documented for each screen

- Section 8 documents implemented widget trees for all phase-1 screens

---

## 7) Implementation Status

Current status: IMPLEMENTED (Phase 1 UI + mock flow)

Completed:

- Domain entity, repository contract, and omnichannel use cases
- Mock repository state transitions for Messenger and Zalo actions
- Omnichannel MobX store with action feedback + refresh logic
- Omnichannel hub + Messenger flow screens + Zalo flow screens
- DI registration, route registration, Home entry tab, EN/VI localization keys
- build_runner generation and analyzer verification (no new blocking errors)
- Chrome runtime crash fixed by guarding Crashlytics initialization on web

---

## 8) Widget Tree (Implemented)

### 8.1 Omnichannel Hub Screen (standalone or embedded)

- Conditional root
  - Standalone: Scaffold
    - AppBar
    - Body
  - Embedded: Body only
- Body
  - Observer
    - ListView
      - OverviewCard
      - MessengerChannelCard
      - ZaloChannelCard

### 8.2 Messenger Dashboard Screen

- Scaffold
  - AppBar
  - Observer
    - ListView
      - MessengerSummaryCard
      - OAuthStatusNavTile
      - CustomerSyncNavTile
      - SettingsNavTile

### 8.3 Messenger OAuth Screen (Mock)

- Scaffold
  - AppBar
  - ListView
    - StatusCard
    - Stepper
      - Step 1 Login
      - Step 2 Permission
      - Step 3 Done
    - Connect/Disconnect CTA

### 8.4 Messenger Settings Screen

- Scaffold
  - AppBar
  - Form
    - SwitchListTile (Auto reply)
    - Dropdown/Segment (Language)
    - Time range selector (Business hours mock)
  - Save button

### 8.5 Messenger Sync Status Screen

- Scaffold
  - AppBar
  - ListView
    - LastSyncCard
    - StatsCard (synced/failed)
    - SyncNowButton

### 8.6 Zalo Integration Screen

- Scaffold
  - AppBar
  - Observer
    - ListView
      - ConnectionStatusCard
      - QR Connect CTA
      - OAuth Management CTA
      - Sync Status CTA
      - Assignment CTA
      - Personal Message CTA

### 8.7 Zalo QR Connect Screen

- Scaffold
  - AppBar
  - Observer
    - ListView
    - QRPlaceholderCard
    - Connection summary card
    - Connect/Disconnect button
    - Navigate to sync status
    - Navigate to assignment

### 8.8 Zalo OAuth Management Screen

- Scaffold
  - AppBar
  - Column
    - OAuthStateCard
    - Link/Unlink buttons

### 8.9 Zalo Sync Status Screen

- Scaffold
  - AppBar
  - Observer
    - ListView
    - ConnectionHealthIndicator
    - SyncStatusCard
    - Retry Sync button

### 8.10 Zalo CS Assignment Screen

- Scaffold
  - AppBar
  - ListView
    - AccountAssignmentTile x N
      - Account info
      - CS selector
  - Save assignments button

### 8.11 Zalo Personal Message Screen

- Scaffold
  - AppBar
  - ListView
    - Recipient TextField
    - Message TextField (multiline)
    - Send button
    - Result banner/snackbar

---

## 9) Test Plan (Phase 1)

1. Open Omnichannel Hub from Home
2. Verify Messenger and Zalo cards render
3. Enter Messenger flow
   - Connect -> success feedback
   - Disconnect -> success feedback
   - OAuth mock -> success and error cases
   - Save settings -> success feedback
   - Resync -> loading then success/error
4. Enter Zalo flow
   - Open QR screen -> static QR visible
   - Refresh QR -> feedback visible
   - OAuth manage link/unlink -> status changes
   - Sync status indicators update from mock
   - CS assignment save -> success feedback
   - Send personal message -> success/error feedback
5. Validate dark/light mode readability
6. Validate EN/VI localization display

---

## 10) Definition of Done

- All screens in scope implemented with mock interactions
- Acceptance criteria fully satisfied
- DI, routes, localization updated
- Analyzer has no blocking errors for new feature files
- Widget tree section in this document reflects actual implementation
