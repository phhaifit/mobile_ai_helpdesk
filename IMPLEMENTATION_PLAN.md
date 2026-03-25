# Implementation Plan: User Acquisition Tracking #18

**Status:** Ready for Development  
**Target SDK:** Firebase Analytics (Google)  
**Duration:** ~2-3 sprints  
**Priority:** High (Core Analytics Infrastructure)

---

## 1. Overview & Objectives

This plan details the implementation of user acquisition tracking for the mobile_ai_helpdesk Flutter application. The feature will:

- Track app installations and first-time app opens
- Capture acquisition sources (organic, paid, referral)
- Extract and store UTM parameters from deep links
- Monitor user journeys via screen and event tracking
- Ensure no PII data is transmitted

### Success Metrics

1. ✅ First-open events fire within 1 minute of fresh app install
2. ✅ Install source captured and visible in Firebase Analytics dashboard
3. ✅ Deep links with UTM parameters properly attributed and tracked
4. ✅ Zero PII detected in analytics event payloads
5. ✅ Real-time event verification possible via Firebase debug mode
6. ✅ Screen navigation auto-tracked for all routes

---

## 2. Architecture & Design

### 2.1 Technology Stack

| Component              | Choice                                        | Rationale                                                    |
| ---------------------- | --------------------------------------------- | ------------------------------------------------------------ |
| Analytics SDK          | Firebase Analytics                            | Native Google integration, free tier, no backend required    |
| First-Launch Detection | Flutter-side (app open)                       | Simpler than native install detection; sufficient for MVP    |
| UTM Handling           | Dual: Firebase + URL parsing                  | Robust fallback; Firebase campaign params + custom parser    |
| Deep Linking           | URI scheme + Firebase Dynamic Links (Phase 2) | URI scheme for Phase 1 testing; Dynamic Links for production |
| Dashboard              | Firebase Console                              | Native analytics dashboard; no custom admin UI needed        |

### 2.2 Integration Points

The feature integrates into the existing clean architecture at these layers:

**Domain Layer (`lib/domain/`)**

- New: `analytics/analytics_service.dart` — Interface defining tracking behavior

**Data Layer (`lib/data/`)**

- New: `analytics/firebase_analytics_service_impl.dart` — Firebase implementation
- New: `analytics/first_launch_manager.dart` — First-launch detection logic
- Modify: `di/module/network_module.dart` — Register AnalyticsService as singleton
- Modify: `sharedpref/constants/preferences.dart` — Add analytics storage keys

**Presentation Layer (`lib/presentation/`)**

- Modify: Stores (LoginStore, etc.) — Inject AnalyticsService for event tracking
- Modify: `di/module/store_module.dart` — Inject service to stores

**Utilities Layer (`lib/utils/`)**

- New: `deep_linking/utm_param_parser.dart` — Parse UTM query parameters
- Modify: `routes/routes.dart` — Call UTM parser in onGenerateRoute

**Constants Layer (`lib/constants/`)**

- New: `analytics_events.dart` — Standardized event names
- Modify: `env.dart` — Add analytics environment config flags

**Application Root (`lib/`)**

- Modify: `main.dart` — Firebase initialization, first-launch tracking

### 2.3 Data Flow Diagram

```
App Launch
    ↓
Firebase.initializeApp()
    ↓
ServiceLocator.configureDependencies()
    ↓
FirstLaunchManager.checkAndTrackFirstLaunch()
    ├─ First-time?
    │  ├─ YES → Generate installationId, detect installSource, call trackAppOpen()
    │  └─ NO → Skip
    ↓
[User navigates to route]
    ↓
routes.onGenerateRoute()
    ├─ Parse UTM params from URL
    ├─ Call AnalyticsService.trackScreenView(screenName, utmParams)
    ↓
[User triggers action: login, signup, etc.]
    ↓
Store's @action method
    ├─ Call AnalyticsService.trackEvent(eventName, params)
    ↓
AnalyticsServiceImpl (Firebase backend)
    ├─ Validate & filter PII
    ├─ Batch locally (Firebase SDK handles)
    ├─ Send to Firebase Analytics
    ↓
Firebase Console (Realtime dashboard)
```

---

## 3. Implementation Phases

### Phase 1: Setup & Infrastructure

**Objective:** Initialize Firebase and prepare environment configuration.

**Tasks:**

1. **Add Firebase dependencies to pubspec.yaml**
   - Add `firebase_core` (latest stable)
   - Add `firebase_analytics` (latest stable)
   - Add `package_info_plus` (for install source detection)
   - Run `flutter pub get` to fetch packages

2. **Configure Firebase for Android**
   - Download `google-services.json` from Firebase Console
   - Place in `android/app/` directory
   - Update `android/build.gradle.kts` with Google Play Services classpath
   - Verify `android/app/build.gradle.kts` has `apply plugin: 'com.google.gms.google-services'`

3. **Configure Firebase for iOS**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add to Xcode project via Runner target (Xcode GUI)
   - Update `ios/Podfile` to include Firebase pods (auto-linked by `firebase_core`)
   - Run `cd ios && pod install && cd ..`

4. **Initialize Firebase in main.dart**
   - Call `Firebase.initializeApp()` before `ServiceLocator.configureDependencies()`
   - Wrap in try-catch for edge cases (simulator/emulator)

5. **Add analytics configuration to env.dart**
   - Add boolean flags: `enableAnalytics`, `enableAnalyticsDebug`
   - Dev: all true; Staging: analytics true, debug false; Prod: analytics true, debug false
   - Initialize: Call `FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enableAnalytics)`

6. **Extend SharedPreferences keys for analytics**
   - Add: `isAppFirstOpen`, `firstLaunchTime`, `installationId`, `installSource`
   - Used by FirstLaunchManager to detect first app open

**Deliverables:**

- Firebase project linked to Flutter app
- `google-services.json` and `GoogleService-Info.plist` in place
- `flutter pub get` succeeds
- Firebase Analytics console shows SDK connectivity status

---

### Phase 2: Core Analytics Service

**Objective:** Build the reusable analytics service following clean architecture patterns.

**Tasks:**

7. **Create AnalyticsService interface**
   - File: `lib/domain/analytics/analytics_service.dart`
   - Methods: `trackAppOpen()`, `trackScreenView()`, `trackEvent()`, `setUserProperties()`, `setAnalyticsCollectionEnabled()`
   - Return types: `Future<void>` for async operations
   - No Firebase imports; pure business logic

8. **Create AnalyticsServiceImpl**
   - File: `lib/data/analytics/firebase_analytics_service_impl.dart`
   - Inject: `FirebaseAnalytics` instance from SDK
   - Implement all interface methods using Firebase API calls
   - Add PII validation: reject tracking params containing email, phone, or user names
   - Enforce parameter length limits: max 100 chars per value
   - Map custom event names to Firebase event constants (or raw names)
   - Include standard parameters: `device_id`, `installation_id`, `install_source`, `app_version`, `os_version`

9. **Register AnalyticsService in DI**
   - File: `lib/data/di/module/network_module.dart`
   - Register as singleton after EventBus registration
   - `getIt.registerSingleton<AnalyticsService>(() => AnalyticsServiceImpl())`
   - Ensure initialization happens after Firebase.initializeApp()

**Deliverables:**

- AnalyticsService interface accessible from domain layer
- AnalyticsServiceImpl properly wraps Firebase SDK
- Service registered in DI and injectable via `getIt<AnalyticsService>()`
- No compile errors; lint passes

---

### Phase 3: First-Launch & Installation Tracking

**Objective:** Detect first app open and capture installation metadata.

**Tasks:**

10. **Create FirstLaunchManager**
    - File: `lib/data/analytics/first_launch_manager.dart`
    - Logic:
      - Check SharedPreferences for `isAppFirstOpen` flag
      - If not set (first launch):
        - Generate UUID (using `uuid` package or similar)
        - Store `installationId` in SharedPreferences
        - Store current timestamp as `firstLaunchTime`
        - Infer `installSource` (default "organic"; platform-specific logic optional)
        - Call `AnalyticsService.trackAppOpen(installSource, sessionId)`
      - Set flag `isAppFirstOpen = true` to prevent re-firing
    - Return: `FirstLaunchData { isFirstLaunch, installationId, installSource }`

11. **Integrate FirstLaunchManager into main.dart**
    - After Firebase.initializeApp() and ServiceLocator.configureDependencies()
    - Call `FirstLaunchManager.checkAndTrackFirstLaunch()` (or similar)
    - Store result in a global variable or provider for later reference
    - Log result (debug print or verbose logging)

12. **Optional: Infer install source from platform**
    - Android: Use `package_info_plus` to check install source via `getInstallerPackageName()`
      - "com.android.vending" → "organic"
      - Other → "sideload"
    - iOS: App Store implicit; default "organic"
    - For Phase 1: Can skip and default all to "organic"; enhance in Phase 2

**Deliverables:**

- FirstLaunchManager detects first app open
- `installation_id` and `first_launch_time` stored persistently
- Firebase receives `first_open` event on first app run
- Subsequent app opens do not re-fire first_open

---

### Phase 4: Deep Link UTM Parameter Handling

**Objective:** Extract and track UTM parameters from deep link URLs.

**Tasks:**

13. **Create UTMParamParser**
    - File: `lib/utils/deep_linking/utm_param_parser.dart`
    - Parse URL query parameters: `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, `utm_term`
    - Validation: No special chars; max 100 chars per param
    - Return: `UTMParamData { source, medium, campaign, content, term }`

14. **Integrate UTM parsing into routing**
    - File: `lib/utils/routes/routes.dart`
    - In `onGenerateRoute()`:
      - Extract query params from `RouteSettings.name` (e.g., `/home?utm_source=google&utm_campaign=promo`)
      - Call `UTMParamParser.parse(queryParams)`
      - Pass parsed data to target screen via route args or global provider
      - Call `AnalyticsService.trackScreenView(screenName, utmParams)` with first screen

15. **Enable deep linking in platform configs**
    - Android: Add intent filter to `android/app/src/main/AndroidManifest.xml`
      - Scheme: `appname://` or custom URI
      - Action: `android.intent.action.VIEW`
      - Categories: `DEFAULT`, `BROWSABLE`
    - iOS: Add Associated Domains to Runner.xcodeproj
      - Configure `applinks:yourdomain.com` (optional for Phase 2)
    - Test: `adb shell am start -a android.intent.action.VIEW -d "appname://campaign?utm_source=test&utm_medium=social"`

**Deliverables:**

- UTM parameters extracted from deep link URLs
- First screen view includes UTM data in Firebase event
- Deep link routing works without app crash
- Parameters visible in Firebase Analytics Events dashboard

---

### Phase 5: Event Tracking Integration

**Objective:** Add event tracking to critical user flows throughout the app.

**Tasks:**

16. **Define standardized event names**
    - File: `lib/constants/analytics_events.dart`
    - Standard events:
      - `install` — fired on first app open (custom)
      - `first_open` — Firebase native (auto-fired by SDK)
      - `app_open` — fired every app foreground (manual, via app lifecycle observer)
      - `screen_view` — fired when navigating to a new route (auto via routing)
      - `user_signup` — when user creates account
      - `user_login` — when user authenticates
      - `user_logout` — when user logs out
      - `ticket_created`, `ticket_viewed` — feature-specific
      - `error` — when an error occurs (already using EventBus)
    - Naming: snake_case, max 40 chars, Firebase-compliant

17. **Add tracking to authentication flows**
    - File: `lib/presentation/auth/store/login_store.dart`
    - On successful login: `trackEvent('user_login', {'success': true})`
    - On login failure: `trackEvent('user_login', {'success': false, 'error_code': errorCode})`
    - File: `lib/presentation/auth/store/signup_store.dart` (if exists)
    - On signup: `trackEvent('user_signup', {'method': 'email_password'})`

18. **Auto-track screen views via routing**
    - File: `lib/utils/routes/routes.dart`
    - In `onGenerateRoute()`: Call `AnalyticsService.trackScreenView(screenName)` for every route
    - Extract screen name from `RouteSettings.name`

19. **Track app lifecycle (resume/pause)**
    - File: `lib/presentation/main_screen.dart` or new lifecycle service
    - Implement `WidgetsBindingObserver` mixin
    - Override `didChangeAppLifecycleState()`
    - On `resumed`: Call `AnalyticsService.trackEvent('app_open')`
    - On `paused`: Optional—no action needed

20. **Optionally inject AnalyticsService into stores**
    - For stores that need tracking: `ChatStore`, `TicketStore`, `CustomerStore` (etc.)
    - In `lib/presentation/di/module/store_module.dart`: Inject `AnalyticsService` where needed
    - Call `trackEvent()` at key points (message sent, ticket created, etc.)

**Deliverables:**

- AnalyticsEvents constants defined
- Authentication events firing
- Screen navigation auto-tracked
- App lifecycle events (open/close) tracked
- Optional feature-specific events integrated

---

### Phase 6: Testing & Validation

**Objective:** Verify all events fire correctly and no PII is transmitted.

**Tasks:**

21. **Enable Firebase Analytics debug mode (local testing)**
    - Android: Run `adb shell setprop debug.firebase.analytics.app <package_name>`
    - Verify with `adb logcat | grep "FirebaseAnalytics"`
    - iOS: Launch with environment variable or Xcode scheme setting
    - Expected: Real-time events appear in Firebase Console within 5-10 seconds

22. **Create dev testing utilities (optional)**
    - Add toggle in settings screen: "Enable Verbose Analytics Logging"
    - When enabled: Print all `trackEvent()` calls to console with params
    - Helps verify events without waiting for Firebase dashboard

23. **Manual test scenarios**
    - [ ] **First-open test:**
      - Uninstall app completely
      - Reinstall from `flutter run` or APK
      - Open app → verify `first_open` event in Firebase Real-Time dashboard within 1 minute
      - Verify `installation_id` and `install_source` in event params
    - [ ] **Screen navigation test:**
      - Navigate between 5 different screens
      - Verify 5 `screen_view` events with correct screen names
    - [ ] **Deep link UTM test:**
      - Trigger deep link: `adb shell am start -a android.intent.action.VIEW -d "appname://campaign?utm_source=google&utm_medium=cpc&utm_campaign=summer"`
      - App opens to correct screen
      - Verify Firebase event contains UTM params
    - [ ] **Authentication test:**
      - Sign up → verify `user_signup` event
      - Log in → verify `user_login` event
      - Log out → verify `user_logout` event
    - [ ] **App lifecycle test:**
      - Open app → send to background (press home)
      - Wait 5 seconds
      - Return to app → verify `app_open` event
    - [ ] **PII audit:**
      - Search Firebase Analytics events for user email, phone, full name
      - Results should be zero
      - Check event params for no sensitive data

24. **Build & lint verification**
    - Run `flutter analyze` — zero warnings/errors
    - Run `flutter pub get` — no dependency conflicts
    - Run on Android emulator/device (API 24+)
    - Run on iOS simulator/device (iOS 12+)

**Deliverables:**

- All manual test scenarios passed
- Firebase Console shows expected events in real-time
- Zero PII in event payloads
- No build errors or lint warnings

---

## 4. Files to Create

| File Path                                                 | Purpose                                    |
| --------------------------------------------------------- | ------------------------------------------ |
| `lib/domain/analytics/analytics_service.dart`             | Analytics service interface (domain layer) |
| `lib/data/analytics/firebase_analytics_service_impl.dart` | Firebase implementation (data layer)       |
| `lib/data/analytics/first_launch_manager.dart`            | First-launch detection & tracking          |
| `lib/utils/deep_linking/utm_param_parser.dart`            | UTM parameter extraction & validation      |
| `lib/constants/analytics_events.dart`                     | Standardized event name constants          |

---

## 5. Files to Modify

| File Path                                        | Changes                                                                                    |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------ |
| `pubspec.yaml`                                   | Add `firebase_core`, `firebase_analytics`, `package_info_plus`                             |
| `lib/main.dart`                                  | Firebase initialization, FirstLaunchManager call                                           |
| `lib/constants/env.dart`                         | Add `enableAnalytics`, `enableAnalyticsDebug` flags                                        |
| `lib/data/sharedpref/constants/preferences.dart` | Add analytics keys: `isAppFirstOpen`, `firstLaunchTime`, `installationId`, `installSource` |
| `lib/data/di/module/network_module.dart`         | Register AnalyticsService singleton                                                        |
| `lib/utils/routes/routes.dart`                   | UTM parsing in `onGenerateRoute()`, screen view tracking                                   |
| `lib/presentation/di/module/store_module.dart`   | Inject AnalyticsService to stores (optional, as needed)                                    |
| `lib/presentation/auth/store/login_store.dart`   | Add `trackEvent()` calls for auth events                                                   |
| `lib/presentation/main_screen.dart`              | Implement WidgetsBindingObserver for app lifecycle tracking                                |
| `android/app/build.gradle.kts`                   | Add Google Play Services plugin                                                            |
| `android/app/src/main/AndroidManifest.xml`       | Add deep link intent filter                                                                |
| `android/app/google-services.json`               | Firebase config (download from console)                                                    |
| `ios/Podfile`                                    | Firebase pods (auto-linked)                                                                |
| `ios/Runner.xcodeproj`                           | Add GoogleService-Info.plist, Associated Domains                                           |
| `ios/Runner/GoogleService-Info.plist`            | Firebase config (download from console)                                                    |

---

## 6. Dependencies & Sequencing

### Must Complete First (Blocking)

- **Phase 1 (Steps 1-6):** Firebase setup must be done before anything else
  - Steps 1, 2: Can be done in parallel (pubspec + Android config)
  - Step 3: Dependency on Step 2 (iOS requires Pod install)
  - Step 4: Dependency on Steps 1–3 (Firebase SDK must be available)

### Sequential Phases

- **Phase 2 (Steps 7–9):** Depends on Phase 1
- **Phase 3 (Steps 10–12):** Depends on Phase 2
- **Phase 4 (Steps 13–15):** Can be done in parallel with Phase 3
- **Phase 5 (Steps 16–20):** Can be done incrementally after Phase 3
- **Phase 6 (Steps 21–24):** Final validation; use throughout development

### Parallel Opportunities

- Phase 2 + Phase 4: Build AnalyticsService while building UTMParamParser (independent)
- Phase 5, Step 16 + others: Define events while implementing features

---

## 7. Acceptance Criteria & Verification

| AC                                                   | Verification Method                                                | Status     |
| ---------------------------------------------------- | ------------------------------------------------------------------ | ---------- |
| Install and first-open events tracked correctly      | Fresh install → verify `first_open` event in Firebase within 1 min | ⏳ Phase 6 |
| Acquisition source captured and visible in dashboard | Firebase Analytics > Audience tab shows `install_source` property  | ⏳ Phase 6 |
| Deep link attribution working for campaign URLs      | Trigger deep link with utm_source → verify in Firebase Events      | ⏳ Phase 6 |
| No PII sent in tracking events                       | Manual audit: zero email/phone in event payloads                   | ⏳ Phase 6 |
| Events firing correctly in debug mode                | Firebase Real-Time dashboard shows events < 10 sec                 | ⏳ Phase 6 |

---

## 8. Risk & Mitigation

| Risk                                                        | Likelihood | Impact | Mitigation                                                      |
| ----------------------------------------------------------- | ---------- | ------ | --------------------------------------------------------------- |
| Firebase SDK initialization fails on some devices           | Low        | High   | Wrap in try-catch; add telemetry to report errors               |
| UTM parameters contain special chars causing parsing errors | Medium     | Medium | Add validation & sanitization in UTMParamParser                 |
| PII accidentally tracked (email in event params)            | Low        | High   | Implement param validation in AnalyticsServiceImpl; code review |
| Deep links not working on iOS                               | Medium     | Medium | Test on iOS device; verify Associated Domains config            |
| Event quota exceeded (Firebase limits ~500/session)         | Very Low   | Low    | Monitor dashboard; add sampling if needed                       |
| Performance impact from event batching                      | Low        | Low    | Firebase SDK optimized; unlikely to cause issues                |

---

## 9. Success Metrics & Monitoring

### Key Metrics to Track

- Number of installs per day (based on first_open events)
- Breakdown by install_source (organic vs. other)
- Top acquisition channels (utm_source values)
- Attribution conversion rate (install → login)
- Screen visit patterns (most-visited screens)

### Monitoring Dashboard

- Firebase Analytics Console > Overview tab (real-time events, active users)
- Events tab (detail drill-down)
- Audience tab (user properties, install_source)
- Real-Time tab (live event stream)

### Alerts / Thresholds

- If first_open events drop below 10/hour → investigate Firebase connectivity
- If PII detected in events → halt tracking and investigate
- If event payload size > 1KB → optimize params

---

## 10. Timeline & Effort Estimate

| Phase     | Steps    | Effort          | Duration      |
| --------- | -------- | --------------- | ------------- |
| Phase 1   | 1–6      | 3–4 hours       | 1–2 days      |
| Phase 2   | 7–9      | 2–3 hours       | 1 day         |
| Phase 3   | 10–12    | 2–3 hours       | 1 day         |
| Phase 4   | 13–15    | 3–4 hours       | 1–2 days      |
| Phase 5   | 16–20    | 3–4 hours       | 1–2 days      |
| Phase 6   | 21–24    | 2–3 hours       | 1–2 days      |
| **Total** | **1–24** | **15–21 hours** | **6–10 days** |

_Assumes 1 developer, working full-time. Can be parallelized with multiple devs._

---

## 11. Post-Implementation & Future Enhancements

### Phase 2 Enhancements (Future)

- Native install referrer detection (Android InstallReferrer API)
- Firebase Dynamic Links for shortened campaign URLs
- Cohort analysis and funnel tracking
- Custom event sampling/rate limiting
- Deep linking for core app features (not just campaigns)

### Operational

- Set up Firebase Alerts for anomalies (e.g., sudden drop in events)
- Monthly review of acquisition metrics
- Quarterly audit of event tracking to ensure no PII leakage
- Plan for GDPR compliance (data retention, user consent)

---

## 12. References & Resources

- [Flutter Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [Firebase Analytics Events Reference](https://support.google.com/firebase/answer/9234069)
- [Firebase Debug Mode (Android)](https://support.google.com/firebase/answer/7201382)
- [Firebase Debug Mode (iOS)](https://support.google.com/firebase/answer/7201382)
- [Deep Linking in Flutter](https://flutter.dev/docs/development/ui/navigation/deep-linking)
- [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links)

---

## 13. Approval & Sign-Off

**Created:** March 21, 2026  
**Created By:** GitHub Copilot  
**Status:** Ready for Development

**Sign-off required from:**

- [ ] Tech Lead — Architecture review
- [ ] Project Manager — Timeline & resource allocation
- [ ] QA Lead — Test plan review

---
