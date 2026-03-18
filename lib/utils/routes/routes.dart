import 'package:ai_helpdesk/presentation/home/home.dart';
import 'package:ai_helpdesk/presentation/login/login_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/monetization_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/upgrade_confirmation_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/upgrade_payment_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String login = '/login';
  static const String home = '/home';
  static const String monetization = '/monetization';
  static const String upgradePayment = '/upgrade-payment';
  static const String upgradeConfirmation = '/upgrade-confirmation';

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
      case monetization:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MonetizationScreen(),
        );
      case upgradePayment:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const UpgradePaymentScreen(),
        );
      case upgradeConfirmation:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const UpgradeConfirmationScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
