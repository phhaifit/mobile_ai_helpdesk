import 'dart:io';

import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/sign_in_email/sign_in_email_screen.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    setupFirebaseCoreMocks();
    await Firebase.initializeApp();

    SharedPreferences.setMockInitialValues({});
    await ServiceLocator.configureDependencies();
  });

  test('Service locator registers ThemeStore + LanguageStore', () {
    expect(getIt.isRegistered<ThemeStore>(), isTrue);
    expect(getIt.isRegistered<LanguageStore>(), isTrue);
  });

  testWidgets('SignInEmailScreen renders without crashing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: SignInEmailScreen(),
      ),
    );
    await tester.pump();
  });
}
