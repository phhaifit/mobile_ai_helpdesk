import 'package:ai_helpdesk/presentation/home/home.dart';
import 'package:ai_helpdesk/presentation/login/login_screen.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String login = '/login';
  static const String home = '/home';

  // route generator -----------------------------------------------------------
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            final l = AppLocalizations.of(context);
            final msgTemplate = l.translate('routes_tv_no_route_defined');
            final msg =
                msgTemplate.replaceAll('{route}', settings.name ?? '');
            return Scaffold(
              body: Center(
                child: Text(msg),
              ),
            );
          },
        );
    }
  }
}
