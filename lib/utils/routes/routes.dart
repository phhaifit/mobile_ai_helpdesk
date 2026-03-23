import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/home/home.dart';
import 'package:ai_helpdesk/presentation/login/login_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/ticket_list_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/create_ticket_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/ticket_detail_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/edit_ticket_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/customer_ticket_history_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String login = '/login';
  static const String home = '/home';
  static const String ticketList = '/ticket_list';
  static const String createTicket = '/create_ticket';
  static const String ticketDetail = '/ticket_detail';
  static const String editTicket = '/edit_ticket';
  static const String customerHistory = '/customer_history';

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
      case ticketList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TicketListScreen(),
        );
      case createTicket:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CreateTicketScreen(),
        );
      case ticketDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => TicketDetailScreen(
            ticketId: settings.arguments as String,
          ),
        );
      case editTicket:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EditTicketScreen(
            ticket: settings.arguments as Ticket,
          ),
        );
      case customerHistory:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CustomerTicketHistoryScreen(
            customerId: args['customerId']!,
            customerName: args['customerName']!,
          ),
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

