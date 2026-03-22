import 'package:ai_helpdesk/presentation/home/home.dart';
import 'package:ai_helpdesk/presentation/login/login_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_customer_sync_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_dashboard_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_oauth_status_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_settings_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_hub_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/zalo/zalo_account_assignment_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/zalo/zalo_connect_qr_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/zalo/zalo_integration_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/zalo/zalo_oauth_management_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/zalo/zalo_personal_message_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/zalo/zalo_sync_status_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/monetization_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/upgrade_confirmation_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/upgrade_payment_screen.dart';
import '/presentation/home/home.dart';
import '/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String login = '/login';
  static const String home = '/home';
  static const String omnichannelHub = '/omnichannel';
  static const String messengerDashboard = '/omnichannel/messenger/dashboard';
  static const String messengerOauthStatus =
      '/omnichannel/messenger/oauth-status';
  static const String messengerCustomerSync =
      '/omnichannel/messenger/customer-sync';
  static const String messengerSettings = '/omnichannel/messenger/settings';
  static const String zaloOverview = '/omnichannel/zalo/overview';
  static const String zaloConnectQr = '/omnichannel/zalo/connect-qr';
  static const String zaloOauthManagement = '/omnichannel/zalo/oauth';
  static const String zaloSyncStatus = '/omnichannel/zalo/sync-status';
  static const String zaloAccountAssignment =
      '/omnichannel/zalo/account-assignment';
  static const String zaloPersonalMessage =
      '/omnichannel/zalo/personal-message';
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
      case omnichannelHub:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OmnichannelHubScreen(),
        );
      case messengerDashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MessengerDashboardScreen(),
        );
      case messengerOauthStatus:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MessengerOauthStatusScreen(),
        );
      case messengerCustomerSync:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MessengerCustomerSyncScreen(),
        );
      case messengerSettings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MessengerSettingsScreen(),
        );
      case zaloOverview:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ZaloIntegrationScreen(),
        );
      case zaloConnectQr:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ZaloConnectQrScreen(),
        );
      case zaloOauthManagement:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ZaloOauthManagementScreen(),
        );
      case zaloSyncStatus:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ZaloSyncStatusScreen(),
        );
      case zaloAccountAssignment:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ZaloAccountAssignmentScreen(),
        );
      case zaloPersonalMessage:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ZaloPersonalMessageScreen(),
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
