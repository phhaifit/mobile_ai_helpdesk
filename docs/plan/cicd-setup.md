# CI/CD Setup Guide

This document describes how to configure the required GitHub Secrets and external services
to make the three CI/CD workflows operational.

---

## Workflows Overview

| File | Trigger | Purpose |
|---|---|---|
| `.github/workflows/ci.yml` | PR to `main` / `develop` | Lint + tests |
| `.github/workflows/distribute.yml` | Push to `develop` | Dev build → TestFlight + Google Play Internal |
| `.github/workflows/release.yml` | Manual (`workflow_dispatch`) | Production build → App Store + Google Play Production |

---

## GitHub Secrets

Go to **GitHub → Repository → Settings → Secrets and variables → Actions → New repository secret**.

### Android

| Secret | How to obtain |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -i release.jks \| pbcopy` (macOS) |
| `ANDROID_KEYSTORE_PASSWORD` | Password chosen when generating the keystore |
| `ANDROID_KEY_ALIAS` | Alias chosen when generating the keystore |
| `ANDROID_KEY_PASSWORD` | Key password chosen when generating the keystore |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | See *Google Play Setup* section below |

**Generate a keystore (first time only):**
```bash
keytool -genkey -v \
  -keystore release.jks \
  -alias YOUR_KEY_ALIAS \
  -keyalg RSA -keysize 2048 \
  -validity 10000
```

### iOS

| Secret | How to obtain |
|---|---|
| `IOS_CERTIFICATES_P12_BASE64` | See *iOS Certificate Export* below |
| `IOS_CERTIFICATES_P12_PASSWORD` | Password set during .p12 export |
| `IOS_PROVISIONING_PROFILE_BASE64` | See *iOS Provisioning Profile* below |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect → Users and Access → Integrations → Keys |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Same page as above |
| `APP_STORE_CONNECT_API_KEY_BASE64` | `base64 -i AuthKey_XXXX.p8 \| pbcopy` |

**Export iOS Distribution Certificate to Base64:**
1. Open **Keychain Access** → My Certificates
2. Right-click the **Apple Distribution** certificate → Export → save as `.p12`
3. `base64 -i Certificates.p12 | pbcopy` → paste as secret

**Export Provisioning Profile to Base64:**
1. Download the App Store provisioning profile from **Apple Developer Portal**
2. `base64 -i profile.mobileprovision | pbcopy` → paste as secret

---

## iOS: ExportOptions.plist

Edit `ios/ExportOptions.plist` and fill in:
- `teamID` — your 10-character Apple Team ID (Developer Portal → Membership)
- The bundle identifier key under `provisioningProfiles` — must match your app's bundle ID set in Xcode
- The provisioning profile name — must match exactly the profile name in Apple Developer Portal

---

## Google Play Setup

1. Go to **Google Play Console → Setup → API access**
2. Link to a Google Cloud project, then create a **service account** with the **Release Manager** role
3. Download the service account JSON key
4. Paste the **entire JSON contents** (not base64) as `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

The app (`com.iotecksolutions.todoapp`) must already exist in Google Play Console
(at least a manual upload of the first APK/AAB is needed before the API can upload).

---

## iOS Bundle ID

The app bundle ID is currently a placeholder in `ios/ExportOptions.plist`.

Set the real bundle ID in **Xcode**:
1. Open `ios/Runner.xcworkspace`
2. Select the `Runner` target → **Signing & Capabilities**
3. Set **Bundle Identifier** (e.g. `com.yourcompany.mobileaihelpdesk`)
4. Update `ios/ExportOptions.plist` → `provisioningProfiles` key to match

---

## README Badge

After pushing to GitHub, update the badge URL in `README.md`:
```
![CI](https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME/actions/workflows/ci.yml/badge.svg)
```

---

## develop Branch

If the `develop` branch does not exist yet:
```bash
git checkout -b develop
git push -u origin develop
```
