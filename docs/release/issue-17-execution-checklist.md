# Issue #17 Execution Checklist - Mobile App Store Publishing

## Phase 1 - Pre-release Audit

- [ ] Confirm app identifiers:
  - iOS Bundle ID matches App Store Connect app
  - Android Application ID matches Play Console app
- [ ] Confirm app version policy:
  - `versionName` and `versionCode` (Android)
  - `CFBundleShortVersionString` and `CFBundleVersion` (iOS)
- [ ] Confirm legal URLs:
  - Privacy Policy
  - Terms of Service (if applicable)
  - Support URL / contact email
- [ ] Run smoke tests on release mode:
  - Login/logout
  - Main navigation
  - Key ticket/chat actions

## Phase 2 - Media Assets

- [ ] Prepare app icon sources
- [ ] Generate launcher icons with flutter_launcher_icons
- [ ] Prepare splash source and generate native splash
- [ ] Capture screenshots for required device sizes
- [ ] Store screenshots under a shared release folder for traceability

## Phase 3 - Store Metadata

- [ ] Finalize app title
- [ ] Finalize subtitle/short description
- [ ] Finalize full description
- [ ] Finalize keyword set (iOS)
- [ ] Finalize promotional text / release notes

## Phase 4 - Signing and Build Artifacts

- [ ] Android:
  - [ ] Create release keystore
  - [ ] Add `android/key.properties` from template
  - [ ] Build signed AAB
- [ ] iOS:
  - [ ] Configure certificate/provisioning profile
  - [ ] Archive app in Xcode
  - [ ] Upload build to App Store Connect

## Phase 5 - Console Setup and Submission

- [ ] Google Play Console:
  - [ ] App content forms completed
  - [ ] Data Safety completed
  - [ ] Content rating completed
  - [ ] Production/closed track configured
  - [ ] AAB uploaded and submitted
- [ ] App Store Connect:
  - [ ] App Privacy completed
  - [ ] Age rating completed
  - [ ] Build attached to version
  - [ ] Metadata and screenshots uploaded
  - [ ] Submission sent for review

## Phase 6 - Post-submission

- [ ] Monitor reviewer feedback daily
- [ ] Fix and resubmit quickly if rejected
- [ ] Validate app live status on both stores
- [ ] Add production store links to README/release notes
