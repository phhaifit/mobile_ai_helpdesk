import 'package:ai_helpdesk/presentation/auth/change_password/change_password_screen.dart';
import 'package:ai_helpdesk/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:ai_helpdesk/presentation/auth/profile/profile_screen.dart';
import 'package:ai_helpdesk/presentation/auth/registration/registration_screen.dart';
import 'package:ai_helpdesk/presentation/auth/reset_password/reset_password_screen.dart';
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
import '/domain/entity/ai_agent/ai_agent.dart';
import '/presentation/ai_agent/agent_create_edit_screen.dart';
import '/presentation/ai_agent/agent_detail_screen.dart';
import '/presentation/ai_agent/agent_list_screen.dart';
import '/presentation/ai_agent/team_assistant_screen.dart';
import '/presentation/playground/playground_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
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
  // AI Agent
  static const String agentList = '/ai-agents';
  static const String agentCreate = '/ai-agents/create';
  static const String agentEdit = '/ai-agents/edit';
  static const String agentDetail = '/ai-agents/detail';
  static const String teamAssistant = '/ai-agents/team-assistant';
  // Playground
  static const String playground = '/playground';

  // route generator -----------------------------------------------------------
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegistrationScreen(),
        );
      case forgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgotPasswordScreen(),
        );
      case resetPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ResetPasswordScreen(
            email: args?['email'] as String?,
          ),
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );
      case changePassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ChangePasswordScreen(),
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
      case agentList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AgentListScreen(),
        );
      case agentCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AgentCreateEditScreen(),
        );
      case agentEdit:
        final agent = settings.arguments as AiAgent?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AgentCreateEditScreen(agent: agent),
        );
      case agentDetail:
        final agent = settings.arguments as AiAgent;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AgentDetailScreen(agent: agent),
        );
      case teamAssistant:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TeamAssistantScreen(),
        );
      case playground:
        final agent = settings.arguments as AiAgent?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PlaygroundScreen(agent: agent),
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
