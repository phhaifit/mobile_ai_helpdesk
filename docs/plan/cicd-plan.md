# CI/CD Pipeline Plan — Mobile AI Helpdesk Flutter App

## TL;DR

Thiết lập 3 GitHub Actions workflows từ đầu cho dự án Flutter **Mobile AI Helpdesk** (`com.iotecksolutions.todoapp`):
1. **CI validation** tự động trên mọi PR
2. **Dev distribution** lên TestFlight + Google Play Internal Track khi merge vào `develop`
3. **Production release** thủ công qua `workflow_dispatch`

Đồng thời fix Android signing (hiện đang dùng debug key cho release) và thêm build badge vào README.

---

## Overview

| Thành phần | Hiện trạng | Mục tiêu |
|---|---|---|
| `.github/workflows/` | ❌ Không tồn tại | 3 workflow files |
| Android release signing | ❌ Dùng debug key | ✅ Keystore từ secrets |
| Android 16KB page size | ❌ Chưa cấu hình | ✅ `useLegacyPackaging = false` trong build.gradle |
| iOS code signing | ❌ Chưa cấu hình CI | ✅ Certificate + Profile từ secrets |
| Unit tests | ❌ Chỉ 1 placeholder test | ✅ Tests chạy trong CI |
| README badge | ❌ Không có | ✅ Build status badge |

---

## Architecture

```
GitHub Repository
├── PRs to main/develop
│   └── ci.yml ──────────────► flutter analyze + flutter test
│
├── push to develop
│   └── distribute.yml ──────► build AAB → Google Play Internal Track
│                           └► build IPA → TestFlight
│
└── workflow_dispatch (manual)
    └── release.yml ─────────► build AAB → Google Play Production
                            └► build IPA → App Store
```

**GitHub Actions tools sử dụng:**

| Action | Mục đích |
|---|---|
| `actions/checkout@v4` | Checkout code |
| `subosito/flutter-action@v2` | Setup Flutter SDK |
| `actions/cache@v3` | Cache pub packages (giảm build time) |
| `r0adkll/upload-google-play@v1` | Upload Android → Google Play |
| `apple-actions/upload-testflight-build@v1` | Upload iOS → TestFlight |

---

## Project Structure (Sau khi hoàn thành)

```
.github/
  workflows/
    ci.yml              ← PR validation: lint + tests
    distribute.yml      ← Dev distribution (push to develop)
    release.yml         ← Production release (manual trigger)
android/
  key.properties.example  ← Template (commit được) — không chứa giá trị thực
  app/
    build.gradle        ← Modified: dùng keystore signing thay debug signing
README.md               ← Modified: thêm CI badge
```

---

## Work Breakdown Structure

### Phase 1 — CI Foundation (PR Validation)

**1.1** Tạo `.github/workflows/ci.yml`
- Trigger: `pull_request` → branches `[main, develop]`
- Jobs:
  - `analyze`: `flutter analyze` — lint toàn bộ code
  - `test`: `flutter test` — chạy tất cả unit/widget tests
  - Cache pub packages với `actions/cache`
  - Flutter version: stable channel, `>=3.0.6`

**1.2** Thêm build status badge vào `README.md`
- Badge URL pattern: `https://github.com/{owner}/{repo}/actions/workflows/ci.yml/badge.svg`

---

### Phase 2 — Android Signing & Distribution

**2.1** Fix `android/app/build.gradle` — thay thế debug signing và hỗ trợ 16KB page size
- Thêm `signingConfigs.release` đọc từ file `android/key.properties`
- Dùng env vars: `storeFile`, `storePassword`, `keyAlias`, `keyPassword`
- File `android/key.properties` được thêm vào `.gitignore`
- Thêm `packaging.jniLibs.useLegacyPackaging = false` để native libraries (.so) được store uncompressed và aligned đúng 16KB boundary — bắt buộc cho Android 15+ (API 35) devices sử dụng 16KB page size:

```gradle
packaging {
    jniLibs {
        useLegacyPackaging = false
    }
}
```

**2.2** Tạo `android/key.properties.example` — template commit được vào repo (không chứa giá trị thực)

**2.3** Cấu hình Android distribution job trong `.github/workflows/distribute.yml`
- Trigger: `push` → branch `develop`
- Decode `ANDROID_KEYSTORE_BASE64` → file `.jks`
- Tạo `android/key.properties` từ secrets
- Build: `flutter build appbundle --release` (AAB tự động được Google Play repack đúng 16KB alignment)
- Upload AAB → Google Play Internal Track qua `r0adkll/upload-google-play@v1`
- Requires secret: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

---

### Phase 3 — iOS Code Signing & TestFlight

**3.1** Thêm iOS distribution job vào `distribute.yml`
- Decode certificate P12 từ `IOS_CERTIFICATES_P12_BASE64` → keychain
- Import provisioning profile từ `IOS_PROVISIONING_PROFILE_BASE64`
- Build: `flutter build ipa --release --export-options-plist=ExportOptions.plist`
- Upload IPA → TestFlight qua `apple-actions/upload-testflight-build@v1`
- Requires App Store Connect API key secrets

**3.2** Prerequisite: `$(PRODUCT_BUNDLE_IDENTIFIER)` trong Xcode project phải được set đúng trước khi CI chạy

---

### Phase 4 — Production Release Workflow

**4.1** Tạo `.github/workflows/release.yml`
- Trigger: `workflow_dispatch` (manual) với input `version_tag`
- Android job: Build AAB → upload `r0adkll/upload-google-play` với `track: production`
- iOS job: Build IPA → upload App Store Connect (submit for review)
- Reuse signing logic từ `distribute.yml`

---

### Phase 5 — Security & Documentation

**5.1** Audit toàn bộ workflow files — đảm bảo không có secret hardcode
- Kiểm tra tất cả keys/passwords/tokens dùng `${{ secrets.* }}`
- Xác nhận `android/key.properties` trong `.gitignore`
- Xác nhận không có certificate/keystore nào được commit

**5.2** Tạo hướng dẫn setup trong `docs/cicd-setup.md`
- Danh sách đầy đủ tất cả GitHub Secrets cần thiết
- Hướng dẫn cách export P12, provisioning profile, keystore sang Base64

---

## GitHub Secrets Cần Cấu Hình

| Secret Name | Mô tả | Dùng ở workflow |
|---|---|---|
| `ANDROID_KEYSTORE_BASE64` | Base64 của file .jks keystore | distribute, release |
| `ANDROID_KEYSTORE_PASSWORD` | Mật khẩu keystore | distribute, release |
| `ANDROID_KEY_ALIAS` | Key alias trong keystore | distribute, release |
| `ANDROID_KEY_PASSWORD` | Mật khẩu key | distribute, release |
| `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | JSON service account Google Play | distribute, release |
| `IOS_CERTIFICATES_P12_BASE64` | Base64 của .p12 distribution certificate | distribute, release |
| `IOS_CERTIFICATES_P12_PASSWORD` | Mật khẩu .p12 | distribute, release |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64 của .mobileprovision | distribute, release |
| `APP_STORE_CONNECT_API_KEY_ID` | Key ID từ App Store Connect | distribute, release |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer ID từ App Store Connect | distribute, release |
| `APP_STORE_CONNECT_API_KEY_BASE64` | Base64 của .p8 API key file | distribute, release |

---

## Testing — Acceptance Criteria Mapping

| Acceptance Criteria | Cách kiểm tra |
|---|---|
| PRs tự động trigger lint + test pipeline | Tạo test PR → xác nhận `ci.yml` chạy, `flutter analyze` + `flutter test` pass |
| Merges to develop auto-distribute | Push commit lên `develop` → xác nhận AAB trong Google Play Internal, IPA trong TestFlight |
| Production release với single trigger | GitHub → Actions → `release.yml` → Run workflow → cả 2 platforms được build + upload |
| No secrets hardcoded | `grep` toàn bộ `.yml` files, không có key/password/token nào là literal string |
| Pipeline status visible per commit/PR | Badge hiển thị trên README, check mark/X xuất hiện trên từng commit và PR |

---

## Milestones

### Milestone 1 — CI Foundation
> Deliverable: Mọi PR tự động trigger lint + test

- [ ] Tạo `.github/workflows/ci.yml` (analyze + test jobs)
- [ ] Thêm build status badge vào `README.md`

### Milestone 2 — Android Distribution
> Deliverable: Push lên `develop` → AAB tự động upload lên Google Play Internal Track

- [ ] Fix `android/app/build.gradle` — dùng keystore signing
- [ ] Tạo `android/key.properties.example` template
- [ ] Thêm Android job vào `.github/workflows/distribute.yml`

### Milestone 3 — iOS Distribution
> Deliverable: Push lên `develop` → IPA tự động upload lên TestFlight

- [ ] Cấu hình iOS code signing trong CI (certificate + provisioning profile)
- [ ] Bổ sung iOS job vào `distribute.yml`

### Milestone 4 — Production Release
> Deliverable: Single manual trigger deploy cả Android + iOS lên production

- [ ] Tạo `.github/workflows/release.yml` với `workflow_dispatch` trigger

### Milestone 5 — Security & Docs
> Deliverable: Tất cả Acceptance Criteria đều pass, repo sạch không hardcode secrets

- [ ] Audit toàn bộ workflows — không có secrets hardcode
- [ ] Tạo `docs/cicd-setup.md` hướng dẫn cấu hình secrets

---

## Decisions & Scope

- **Không dùng Fastlane:** Giữ đơn giản bằng GitHub Actions marketplace actions. Fastlane có thể bổ sung sau nếu cần workflow phức tạp hơn.
- **iOS runner:** Bắt buộc dùng `macos-latest` runner (tốn nhiều CI minutes hơn `ubuntu`). Android dùng `ubuntu-latest`.
- **Tests:** Chỉ chạy tests hiện có — không viết thêm unit tests (task riêng biệt).
- **iOS Bundle ID:** `$(PRODUCT_BUNDLE_IDENTIFIER)` cần được set thực tế trong Xcode project — prerequisite nằm ngoài scope CI/CD plan này.
- **`develop` branch:** Nếu branch này chưa tồn tại trong repo, cần tạo trước khi merge workflow files.
- **Android 16KB page size:** Yêu cầu Flutter `>=3.22` (Flutter Engine 3.22+ hỗ trợ 16KB page size). CI phải pin Flutter stable channel `>=3.22` — không dùng phiên bản cũ hơn dù `pubspec.yaml` chỉ require `>=3.0.6`. Với `useLegacyPackaging = false`, `.so` files được store uncompressed và page-aligned, cho phép Android 15 kernel map trực tiếp vào memory.
