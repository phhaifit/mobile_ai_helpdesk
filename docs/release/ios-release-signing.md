# iOS Release Signing and Submission Guide

## 1. Apple Developer prerequisites

- Active Apple Developer Program account
- App ID created for bundle identifier
- Signing certificate (Apple Distribution)
- Provisioning profile for App Store distribution

## 2. Configure signing in Xcode

- Open ios/Runner.xcworkspace
- Select Runner target
- Set Team and Bundle Identifier
- Ensure Signing Certificate = Apple Distribution
- Ensure Provisioning Profile is valid for Release

## 3. Build and archive

flutter build ios --release

Then in Xcode:

- Product > Archive
- Validate archive in Organizer
- Distribute App > App Store Connect > Upload

## 4. App Store Connect metadata

- App Privacy section completed
- Age rating completed
- Screenshots and app description completed
- Build attached to target version

## 5. Submit for review

- Submit to App Review
- Monitor feedback and respond quickly to any rejection reason
