# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`ai_helpdesk` (Jarvis Helpdesk) — a Flutter mobile app for an omnichannel AI-powered helpdesk (Messenger, Zalo, tickets, CS workflows, AI agent playground, knowledge base). Flutter SDK constraint: `>=3.7.0 <4.0.0`; CI pins `3.29.0`.

## Common Commands

```bash
# Install deps
flutter pub get

# Generate MobX / json_serializable code (run after any *_store.dart or @JsonSerializable change)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Static analysis (CI uses --no-fatal-infos)
flutter analyze

# Run all tests / a single test
flutter test
flutter test test/customer_unit_test.dart

# Run app (env defaults to dev via --dart-define=ENV)
flutter run
flutter run --dart-define=ENV=staging
flutter run --dart-define=ENV=prod

# Sentry DSN is passed via dart-define (see SENTRY_ALERT_SETUP.md):
flutter run --dart-define=ENV=dev --dart-define=SENTRY_DSN_DEV=<dsn>

# Force real omnichannel integrations even in dev
flutter run --dart-define=USE_REAL_OMNICHANNEL=true
```

## Architecture

Strict 3-layer Clean Architecture (the `.github/instructions/flutter-architecture.instructions.md` file is the canonical spec — treat it as authoritative).

**Layer boundaries** — enforce these strictly:

| Layer | Path | May depend on |
|---|---|---|
| Presentation | `lib/presentation/` | Domain only (never `lib/data/`) |
| Domain | `lib/domain/` | Nothing — pure Dart, no Flutter/Dio/Sembast |
| Data | `lib/data/` | Domain only (implements its interfaces) |
| Core | `lib/core/` | Nothing external |

**Data flow:** Widget → MobX Store → UseCase → Repository (interface in `domain/`, impl in `data/`) → Api (Dio) or local datasource (Sembast/SharedPreferences). Repositories return `Either<Failure, T>` (dartz) — they never throw; DioExceptions are converted via `NetworkExceptions`.

**DI** — single root `ServiceLocator.configureDependencies()` in [lib/di/service_locator.dart](lib/di/service_locator.dart) calls three per-layer modules:
- `lib/data/di/data_layer_injection.dart` — APIs + repository impls (lazy singletons)
- `lib/domain/di/domain_layer_injection.dart` — use cases (lazy singletons)
- `lib/presentation/di/presentation_layer_injection.dart` — stores (**factories**, one per screen)

Any new class must be registered in the matching module. `configureDependencies()` calls `getIt.reset()` first so hot restart is safe.

**Environments** — [lib/constants/env.dart](lib/constants/env.dart) defines an `EnvConfig` enum (dev/staging/prod) selected by `--dart-define=ENV=...`. Base URL, timeouts, logging, analytics, real-omnichannel toggle, and Sentry DSN/environment name all derive from this single source.

**MobX store shape** — every screen has exactly one store. Expose loading via `@computed` from an `ObservableFuture`, not a raw `@observable bool`. Stores must not reference `BuildContext` or `Navigator`. Construct dependencies (use cases) via constructor injection only.

**Routing** — named routes only, defined as static constants in `lib/utils/routes/routes.dart`. Pass data via `RouteSettings.arguments`, never via screen constructors. No inline `MaterialPageRoute` at call sites.

**Features already scaffolded in `lib/presentation/`:** `ai_agent`, `auth`, `chat`, `customer`, `customer_management`, `home`, `knowledge`, `login`, `marketing`, `menu`, `monetization`, `omnichannel`, `playground`, `prompt`, `team`, `tenant`, `ticket`. Follow the same layered structure when adding new ones.

## Feature Scaffold Order

When adding a feature, create in this order (see `.github/instructions/feature-development.instructions.md` for templates):

1. `lib/domain/entity/<feature>/<feature>.dart` — `@JsonSerializable` entity
2. `lib/domain/repository/<feature>/<feature>_repository.dart` — abstract interface returning `Either<Failure, T>`
3. `lib/domain/usecase/<feature>/<verb>_<feature>_usecase.dart` — one class per operation, extends `UseCase`
4. `lib/data/network/apis/<feature>/<feature>_api.dart` + endpoint constant in `lib/data/network/constants/endpoints.dart`
5. `lib/data/repository/<feature>/<feature>_repository_impl.dart` — wraps `DioException` with `NetworkExceptions`
6. `lib/presentation/<feature>/store/<feature>_store.dart` + run build_runner
7. `lib/presentation/<feature>/<feature>_screen.dart` — `Observer` for reactive state, `initState` for store init
8. Register in all three DI modules + add named route

Run `build_runner` after step 1 and step 6. Add user-facing strings to `assets/lang/{en,da,es}.json` and access via `AppLocalization` — no hardcoded strings, colors, dimensions, or URLs in widgets.

## Conventions & Gotchas

- **Never edit `*.g.dart` files** — regenerate via build_runner.
- **Never call repositories from widgets or stores directly** — go through use cases.
- **Analyzer excludes `main_screen.dart`** (see `analysis_options.yaml`); the real app entry is `lib/main.dart` → `MyApp`.
- `strict-casts` and `strict-raw-types` are enabled; `avoid_print`, `avoid_relative_lib_imports`, `always_declare_return_types` are lint errors.
- Constants live in `lib/constants/` (`colors.dart`, `strings.dart`, `dimens.dart`, `font_family.dart`, `assets.dart`, `app_theme.dart`, `analytics_events.dart`). Don't inline these values.
- Firebase is initialized in `main()` with a pre-check (`Firebase.app()`) to avoid double-init during hot restart. Sentry init is currently commented out — DSN plumbing via `env.sentryDsn` is ready when it's re-enabled.

## CI/CD

- `.github/workflows/ci.yml` — runs `flutter analyze --no-fatal-infos` + `flutter test` on every PR to `main`.
- `.github/workflows/distribute.yml` — builds signed Android AAB on PRs to `feature/21-ci/cd-pipeline` (iOS TestFlight job is commented out).
- `.github/workflows/release.yml` — manual `workflow_dispatch` with a `version_tag` input; uploads AAB to Google Play production track and IPA to App Store via `altool`.

Keystore, service account JSON, iOS P12/provisioning, and App Store Connect API key are all injected via GitHub secrets — never commit them. `android/key.properties` is generated at build time.

## Reference Documents

- `README.md` — product vision, V1 feature inventory, target users, success metrics.
- `README.devflow.md` — local setup (emulator, env selection, build_runner).
- `Folder_Structure.md` — full tree of the boilerplate this project derives from (zubairehman/flutter_boilerplate_project).
- `.github/instructions/flutter-architecture.instructions.md` — layer rules, store/use case/repository templates.
- `.github/instructions/feature-development.instructions.md` — step-by-step scaffold checklist with validation list.
- `SENTRY_ALERT_SETUP.md` — Sentry DSN wiring and recommended alert rules.
- `docs/` — per-screen widget-tree docs and feature plans (AI agent playground, tenant/employee screens, CI/CD plan).
