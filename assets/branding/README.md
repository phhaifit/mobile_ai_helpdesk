# Branding Assets for Store Publishing

Place the following source images before running icon/splash generation:

## App Icon Sources

- assets/branding/app_icon/app_icon_1024.png
  - 1024x1024 px
  - PNG, no transparency for App Store final icon source
- assets/branding/app_icon/app_icon_foreground_1024.png
  - 1024x1024 px
  - PNG with transparent background for Android adaptive icon foreground

## Splash Source

- assets/branding/splash/splash_logo_1024.png
  - Recommended square logo with transparent background
  - PNG format

## Generate Assets

Run these commands after adding source files:

flutter pub get
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create

## Notes

- Keep all source design files (Figma/AI/PSD) outside this repo.
- Regenerate assets whenever branding changes.
