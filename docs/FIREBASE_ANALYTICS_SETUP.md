# Firebase Analytics Setup

This app uses **Firebase Analytics** (Google Analytics) for screen views, events, and user properties. Follow these steps to run with a real Firebase project and verify events in DebugView.

## 1. Create a Firebase project (if needed)

1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a project or select an existing one.
3. Enable **Analytics** (usually enabled by default).

## 2. Add Android app and get `google-services.json`

1. In Firebase Console → Project settings → Your apps, click **Add app** → Android.
2. **Android package name** must be: `com.jarvis.helpdesk` (must match `android/app/build.gradle.kts`).
3. Download **google-services.json** and place it in:
   ```
   android/app/google-services.json
   ```
4. Do **not** commit real `google-services.json` with secrets to public repos; use CI secrets or leave it out and add locally.

## 3. Add iOS app and get `GoogleService-Info.plist`

1. In Firebase Console → Project settings → Your apps, click **Add app** → iOS.
2. **iOS bundle ID** must match your app (e.g. `com.jarvis.helpdesk`).
3. Download **GoogleService-Info.plist** and add it to the Xcode project:
   - Open `ios/Runner.xcworkspace` in Xcode.
   - Drag `GoogleService-Info.plist` into the **Runner** target (ensure "Copy items if needed" and Runner target are checked).
   - Or place the file in `ios/Runner/GoogleService-Info.plist` and ensure it is included in the Runner target.

## 4. Generate Flutter Firebase options (recommended)

Install the FlutterFire CLI, then run from the project root:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates/updates `lib/firebase_options.dart` with your project’s API keys and IDs. The placeholder `lib/firebase_options.dart` in the repo is for compilation only; replace it with the generated file for real analytics.

## 5. Verify events in Firebase DebugView

1. **Android**  
   Enable debug mode and run the app:
   ```bash
   adb shell setprop debug.firebase.analytics.app com.jarvis.helpdesk
   flutter run
   ```
   To disable:
   ```bash
   adb shell setprop debug.firebase.analytics.app .none.
   ```

2. **iOS**  
   In Xcode, add the `-FIRAnalyticsDebugEnabled` argument to the Run scheme, then run the app.

3. In Firebase Console go to **Analytics → DebugView** and select your app. You should see:
   - `screen_view` for login and home.
   - `login` and custom events (`ticket_created`, `agent_used`) with parameters.
   - User properties: `tenant_id`, `role`, `plan_type` after login.

## 6. Event taxonomy

See **[ANALYTICS.md](./ANALYTICS.md)** for the full list of screen names, event names, parameters, and user properties.
