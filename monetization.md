# Monetization Feature Plan (Phase 1 - UI + Offline)

## 1) Goal

Implement a complete offline monetization experience with mock data, including:

- Pricing/plan comparison UI
- Upgrade flow with payment method selection steps (UI only)
- Usage limits and progress indicator
- Current plan status with expiry information
- Pro vs Free feature gating sections

No real payment SDKs, no backend calls, and no remote config in this phase.

---

## 2) Scope & Non-Scope

### In Scope

- New monetization domain entity for local/mock plan data structure.
- Mock repository + use cases for fetching current plan, plan catalog, usage summary, and feature gates.
- MobX store for state and step transitions in upgrade flow.
- New monetization screens and reusable widgets under presentation layer.
- Route registration and navigation entry from existing app UI.
- Localization keys (EN + VI) for all user-facing texts.
- Widget tree documentation for each monetization screen.

### Out of Scope

- Real payment processing (Stripe/Apple Pay/Google Pay/etc.)
- Server-side subscription validation
- Purchase restoration
- Receipt verification
- Analytics/crash telemetry events for monetization

---

## 3) Proposed UX (Phase 1)

### Screen A: Monetization Overview (Pricing + Status + Usage + Comparison)

- Header: “Upgrade to Pro”
- Current Plan Card:
  - Plan name (Free/Pro)
  - Renewal/expiry text
  - Short status label
- Usage Card:
  - Example metric: monthly ticket quota usage (e.g., 18/20)
  - Linear progress indicator
  - Remaining quota note
- Plans Section:
  - Free and Pro cards with pricing text
  - Feature bullets per plan
  - CTA button for upgrading to Pro
- Feature Gating Section:
  - A list showing Free availability vs Pro availability using icons/chips

### Screen B: Upgrade Flow (Payment Method Selection)

- Step indicator (mock):
  1. Select plan
  2. Select payment method
  3. Confirm
- Payment method options (radio/select state):
  - Credit/Debit Card (mock)
  - PayPal (mock)
  - Bank Transfer (mock)
- Summary box:
  - Selected plan + mock billed amount
- Continue button (navigates to confirmation)

### Screen C: Upgrade Confirmation (Offline Simulation)

- Mock “Upgrade submitted” result
- Selected plan + payment method recap
- “Back to Monetization” button

---

## 4) Architecture Plan (Clean + MobX)

## 4.1 Domain

- `lib/domain/entity/monetization/monetization.dart`
  - Holds plan status, plan options, usage info, and feature gate rows.
- `lib/domain/repository/monetization/monetization_repository.dart`
  - Exposes methods for fetching mock monetization data.
- `lib/domain/usecase/monetization/`
  - `get_monetization_overview_usecase.dart`
  - `simulate_upgrade_usecase.dart`

## 4.2 Data

- `lib/data/repository/monetization/mock_monetization_repository_impl.dart`
  - Provides deterministic mock data and delayed futures for offline simulation.

## 4.3 Presentation

- `lib/presentation/monetization/store/monetization_store.dart`
  - MobX observables: loading, overview data, selected plan, selected payment method, current step, message.
  - Actions: fetchOverview, selectPlan, selectPaymentMethod, continueToConfirm, resetFlow.
- Screens:
  - `lib/presentation/monetization/monetization_screen.dart`
  - `lib/presentation/monetization/upgrade_payment_screen.dart`
  - `lib/presentation/monetization/upgrade_confirmation_screen.dart`

## 4.4 DI & Routing

- Register repository in `lib/data/di/module/repository_module.dart`
- Register use cases in `lib/domain/di/module/usecase_module.dart`
- Register store in `lib/presentation/di/module/store_module.dart`
- Add routes in `lib/utils/routes/routes.dart`
- Add entry point button from Home tab (minimal, non-disruptive)

---

## 5) Acceptance Criteria Mapping

1. **Pricing/plan comparison screen implemented**
   - Covered by Screen A plans section + feature comparison list.

2. **Upgrade flow UI with mock payment steps**
   - Covered by Screen B (step indicator + payment selection) and Screen C confirmation.

3. **Usage limit indicator renders with mock usage data**
   - Covered by Screen A usage card + progress indicator.

4. **Pro vs free feature gating shown in UI (mock)**
   - Covered by Screen A feature gating section.

5. **Widget tree documented for each screen**
   - Documented in this markdown after implementation under section 9.

---

## 6) UI/UX Consistency Rules

- Use existing Material widgets and current theme from app.
- Avoid adding new color systems or custom design tokens.
- Follow spacing patterns seen in `login_screen.dart` and `home.dart`.
- Keep flow simple, readable, and mobile-first.

---

## 7) Code Quality Rules

- Keep business decisions in store/use case, not in widgets.
- Keep comments focused on non-obvious logic only.
- Keep file names in `snake_case` and classes in `PascalCase`.
- Ensure no direct data-layer import in presentation layer.

---

## 8) Validation Plan

- Run build runner for MobX and json_serializable outputs.
- Run static analysis.
- Manual verification checklist:
  - Open monetization screen from app.
  - Check plan comparison and usage indicator rendering.
  - Start upgrade flow and switch payment options.
  - Confirm mock completion screen appears.
  - Verify all new text uses localization keys.

---

## 9) Widget Tree Documentation (to be filled during implementation)

### Screen A: Monetization Overview

- Scaffold
  - AppBar
  - Observer
    - SingleChildScrollView
      - Column
        - CurrentPlanCard
        - UsageLimitCard
        - PlansComparisonSection
        - FeatureGatingSection
        - UpgradeCTAButton

### Screen B: Upgrade Payment

- Scaffold
  - AppBar
  - Observer
    - Column
      - StepIndicator
      - PaymentMethodSelectorList
      - PlanSummaryCard
      - ContinueButton

### Screen C: Upgrade Confirmation

- Scaffold
  - AppBar
  - Observer
    - Center
      - Column
        - ResultIcon
        - ConfirmationMessage
        - SelectionRecapCard
        - BackButton

---

## 10) Deliverables

- Full Phase 1 monetization UI/offline flow
- DI + routing integration
- Localization updates
- Widget tree docs finalized in this file
- Build/analyze verification results
