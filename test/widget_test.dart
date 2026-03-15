import 'dart:io';

import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/login/login.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // path_provider has no native implementation in headless test VM — return a
    // real temp directory so Sembast can open its database file.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return Directory.systemTemp.path;
        }
        return null;
      },
    );

    // Provide empty initial values so SharedPreferences works in the test environment
    SharedPreferences.setMockInitialValues({});

    await ServiceLocator.configureDependencies();
  });

  // Verify that the DI container registered all required stores.
  test('Service locator registers required stores', () {
    expect(getIt<ThemeStore>(), isNotNull);
    expect(getIt<LanguageStore>(), isNotNull);
    expect(getIt<UserStore>(), isNotNull);
  });

  // Smoke test: render the LoginScreen inside a plain MaterialApp (no custom
  // AppThemeData) so GoogleFonts is never triggered, keeping the test hermetic.
  // AppLocalizations.delegate is required because LoginScreen calls
  // AppLocalizations.of(context) for its string resources.
  testWidgets('LoginScreen renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: LoginScreen(),
      ),
    );
    // Two pumps: first builds the tree, second resolves the async locale load
    await tester.pump();
    await tester.pump();
  });
}
