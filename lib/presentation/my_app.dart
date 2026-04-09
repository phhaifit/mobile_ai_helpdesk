import 'package:ai_helpdesk/constants/app_theme.dart';
import 'package:ai_helpdesk/constants/strings.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../di/service_locator.dart';
import '../domain/repository/auth/auth_repository.dart';

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
          navigatorObservers: [SentryNavigatorObserver()],
          home: const _SplashGate(),
        );
      },
    );
  }
}

/// Lightweight gate that checks persisted auth state and routes accordingly.
class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final authRepo = getIt<AuthRepository>();
      final hasToken = await authRepo.isAuthenticated();

      if (hasToken) {
        // Restore user session into the singleton AuthStore
        final authStore = getIt<AuthStore>();
        await authStore.getCurrentUser();

        if (mounted && authStore.currentUser != null) {
          Navigator.pushReplacementNamed(context, Routes.home);
          return;
        }
      }
    } catch (_) {
      // If anything fails, fall through to login
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
