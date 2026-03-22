import 'dart:io';

import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/login/login_screen.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeFirebaseAppPlatform extends Fake implements FirebaseApp {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => call.method == 'getApplicationDocumentsDirectory'
          ? Directory.systemTemp.path
          : null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_core'),
      (call) async => {
        'name': '[DEFAULT]',
        'options': {
          'apiKey': 'test',
          'appId': '1:0:android:0',
          'messagingSenderId': '0',
          'projectId': 'test',
        },
        'pluginConstants': {},
      },
    );

    SharedPreferences.setMockInitialValues({});
    await ServiceLocator.configureDependencies();
  });

  test('Service locator registers ThemeStore + LanguageStore', () {
    expect(getIt.isRegistered<ThemeStore>(), isTrue);
    expect(getIt.isRegistered<LanguageStore>(), isTrue);
  });

  testWidgets('LoginScreen renders without crashing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const LoginScreen(),
      ),
    );
    await tester.pump();
  });
}
