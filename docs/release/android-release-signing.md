# Android Release Signing Guide

## 1. Create upload keystore

Example command:

keytool -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

Store this file in a secure location (not committed to git).

## 2. Create key.properties

Copy template:

- Source: android/key.properties.example
- Target: android/key.properties

Fill values:

- storePassword
- keyPassword
- keyAlias
- storeFile

`android/key.properties` and `.jks` are already ignored by git.

## 3. Build release artifact

flutter build appbundle --release

Output:

- build/app/outputs/bundle/release/app-release.aab

## 4. Upload to Google Play Console

- Use Internal/Closed testing first.
- Verify install and crash-free startup before Production rollout.
