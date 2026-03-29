# Store Publishing Commands

## Generate icon and splash assets

flutter pub get
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create

## Build release artifacts

### Android AAB

flutter build appbundle --release

### iOS release build (macOS only)

flutter build ios --release

## Optional checks

flutter analyze
flutter test
