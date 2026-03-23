import 'package:ai_helpdesk/presentation/home/home.dart';
import 'package:ai_helpdesk/presentation/knowledge/knowledge_source_list_screen.dart';
import 'package:ai_helpdesk/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String login = '/login';
  static const String home = '/home';
  static const String knowledge = '/knowledge';

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
      case knowledge:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const KnowledgeSourceListScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
