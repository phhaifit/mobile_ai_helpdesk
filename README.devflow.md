# Developer Setup & Workflow

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | `^3.11.0` (Dart `^3.11.0`) |
| Android Studio | Latest (with Android SDK & Emulator) |
| Xcode | Latest (macOS only, for iOS) |

> **First time?** Follow the official quick-start: https://docs.flutter.dev/install/quick
> Pick your OS and target platform, then come back here.

## Getting Started

```powershell
# 1. Clone & enter the project
git clone https://github.com/phhaifit/mobile_ai_helpdesk.git ai_helpdesk
cd ai_helpdesk

# 2. Install dependencies
flutter pub get

# 3. Run code generation (MobX stores, JSON models)
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Running the App

### Android (Windows / PowerShell)

```powershell
# List available emulators
emulator -list-avds

# Start an emulator (add -wipe-data to avoid cache issues)
emulator -avd <emulator_name>
# or with clean state:
emulator -avd <emulator_name> -wipe-data
```

> **Tip:** You can also launch emulators from **Android Studio → Device Manager**.

Once the emulator is running:

```powershell
# Run with default environment (dev)
flutter run

# If multiple devices are connected, select the target
flutter run -d <device_id>
```

Use `flutter devices` to list connected devices and their IDs.

### iOS (macOS / Terminal)

```bash
# Open iOS Simulator
open -a Simulator

# Run
flutter run
```

### Linux / macOS / Bash

Replace `emulator` commands with the same syntax in your shell. The Flutter CLI works identically across terminals.

## Environment Selection

The app uses `--dart-define=ENV` to switch environments. Default is **dev**.

| Environment | Command |
|-------------|---------|
| **dev** (default) | `flutter run` |
| **staging** | `flutter run --dart-define=ENV=staging` |
| **prod** | `flutter run --dart-define=ENV=prod` |

These map to the configurations in `lib/constants/env.dart`.

## Code Generation

After modifying MobX stores (`*_store.dart`) or `@JsonSerializable` models, regenerate:

```powershell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

> Never edit `*.g.dart` files manually.

## Static Analysis

```powershell
flutter analyze
```

Lint rules are configured in `analysis_options.yaml`.

## Project Structure

```
lib/
├── constants/        # Theme, colors, strings, env config
├── core/             # Base classes, shared widgets, extensions
├── data/             # API clients, repository impls, local storage, DI
├── di/               # Root service locator (get_it)
├── domain/           # Entities, repository interfaces, use cases, DI
├── presentation/     # Screens, MobX stores, UI-layer DI
├── utils/            # Routes, locale, device utilities
└── main.dart         # Entry point
```
