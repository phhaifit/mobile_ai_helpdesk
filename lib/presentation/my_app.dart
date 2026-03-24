import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/app_theme.dart';
import '/constants/strings.dart';
import '/presentation/home/store/language/language_store.dart';
import '/presentation/home/store/theme/theme_store.dart';
import '/presentation/login/login_screen.dart';
import '/utils/locale/app_localization.dart';
import '/utils/routes/routes.dart';
import '../di/service_locator.dart';

class MyApp extends StatelessWidget {
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final LanguageStore _languageStore = getIt<LanguageStore>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          theme: _themeStore.darkMode
              ? AppThemeData.darkThemeData
              : AppThemeData.lightThemeData,
          onGenerateRoute: Routes.onGenerateRoute,
          locale: Locale(_languageStore.locale),
          supportedLocales: _languageStore.supportedLanguages
              .map((language) => Locale(language.locale, language.code))
              .toList(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const LoginScreen(),
        );
      },
    );
  }
}
