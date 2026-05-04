import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/ai_agent/ai_agent.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/ai_agent/agent_create_edit_screen.dart';
import 'package:ai_helpdesk/presentation/ai_agent/agent_detail_screen.dart';
import 'package:ai_helpdesk/presentation/ai_agent/agent_list_screen.dart';
import 'package:ai_helpdesk/presentation/ai_agent/team_assistant_screen.dart';
import 'package:ai_helpdesk/presentation/auth/edit_profile/edit_profile_screen.dart';
import 'package:ai_helpdesk/presentation/auth/profile/profile_screen.dart';
import 'package:ai_helpdesk/presentation/auth/sign_in_email/sign_in_email_screen.dart';
import 'package:ai_helpdesk/presentation/auth/verify_otp/verify_otp_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/knowledge_source_list_screen.dart';
import 'package:ai_helpdesk/presentation/main_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/campaign_create_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/campaign_detail_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/campaign_list_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/facebook_admin_setup_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/marketing_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/recipient_targeting_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/template_create_edit_screen.dart';
import 'package:ai_helpdesk/presentation/marketing/template_library_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/monetization_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/upgrade_confirmation_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/upgrade_payment_screen.dart';
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
import 'package:ai_helpdesk/presentation/playground/playground_screen.dart';
import 'package:ai_helpdesk/presentation/prompt/private_prompt_editor_screen.dart';
import 'package:ai_helpdesk/presentation/splash/splash_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/create_ticket_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/customer_ticket_history_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/edit_ticket_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/ticket_detail_screen.dart';
import 'package:ai_helpdesk/utils/deep_linking/utm_param_parser.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String splash = '/';
  static const String signInEmail = '/sign-in';
  static const String verifyOtp = '/verify-otp';
  // Backwards-compatible alias — some older call-sites push '/login'.
  static const String login = signInEmail;
  static const String main = '/main';
  static const String home = '/home';
  static const String promptEditor = '/prompt-editor';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String ticketList = '/ticket';
  static const String createTicket = '/create_ticket';
  static const String ticketDetail = '/ticket/ticket-detail';
  static const String editTicket = '/edit_ticket';
  static const String customerHistory = '/customer_history';
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
  static const String marketingHub = '/marketing';
  static const String campaignList = '/marketing/campaigns';
  static const String campaignCreate = '/marketing/campaigns/create';
  static const String campaignDetail = '/marketing/campaigns/detail';
  static const String templateLibrary = '/marketing/templates';
  static const String templateCreateEdit = '/marketing/templates/edit';
  static const String recipientTargeting = '/marketing/targeting';
  static const String facebookAdminSetup = '/marketing/facebook-admin';
  // AI Agent
  static const String agentList = '/ai-agents';
  static const String agentCreate = '/ai-agents/create';
  static const String agentEdit = '/ai-agents/edit';
  static const String agentDetail = '/ai-agents/detail';
  static const String teamAssistant = '/ai-agents/team-assistant';
  // Playground
  static const String playground = '/playground';
  static const String knowledge = '/knowledge';

  // route generator -----------------------------------------------------------
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routePath = settings.name ?? '';
    final screenName = _extractRouteName(routePath);

    final utmData = UTMParamParser.parseRoutePath(routePath);

    _trackScreenView(screenName, utmData);

    switch (screenName) {
      case splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case signInEmail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SignInEmailScreen(),
        );
      case verifyOtp:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = (args?['email'] as String?) ?? '';
        final nonce = (args?['nonce'] as String?) ?? '';
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VerifyOtpScreen(email: email, nonce: nonce),
        );
      case main:
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainScreen(),
        );
      case promptEditor:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PrivatePromptEditorScreen(),
        );
      case profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );
      case editProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const EditProfileScreen(),
        );
      case ticketList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainScreen(initialCategory: 'pending_tickets'),
        );
      case createTicket:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CreateTicketScreen(),
        );
      case ticketDetail:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => TicketDetailScreen(ticketId: settings.arguments as String),
        );
      case editTicket:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => EditTicketScreen(ticket: settings.arguments as Ticket),
        );
      case customerHistory:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => CustomerTicketHistoryScreen(
                customerId: args['customerId']!,
                customerName: args['customerName']!,
              ),
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
      case marketingHub:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MarketingScreen(),
        );
      case campaignList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CampaignListScreen(),
        );
      case campaignCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CampaignCreateScreen(),
        );
      case campaignDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CampaignDetailScreen(),
        );
      case templateLibrary:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TemplateLibraryScreen(),
        );
      case templateCreateEdit:
        final template = settings.arguments as MarketingTemplate?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => TemplateCreateEditScreen(template: template),
        );
      case recipientTargeting:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RecipientTargetingScreen(),
        );
      case facebookAdminSetup:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FacebookAdminSetupScreen(),
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
      case knowledge:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const KnowledgeSourceListScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => Scaffold(
                body: Center(child: Text('No route defined for $screenName')),
              ),
        );
    }
  }

  static String _extractRouteName(String routePath) {
    if (routePath.contains('?')) {
      return routePath.split('?')[0];
    }
    return routePath;
  }

  static void _trackScreenView(String screenName, UTMData utmData) {
    Future.microtask(() async {
      try {
        final getIt = GetIt.instance;
        final sentryService = getIt<SentryService>();
        final analyticsService = getIt<AnalyticsService>();

        await sentryService.setCurrentScreen(screenName);
        await sentryService.addBreadcrumb(
          message: 'Navigated to $screenName',
          category: 'navigation',
          data: utmData.hasAnyParams ? utmData.toMap() : null,
          type: 'navigation',
        );

        if (utmData.hasAnyParams) {
          await analyticsService.trackScreenView(
            screenName,
            screenClass: 'Screen',
            utmParams: utmData.toMap(),
          );
          debugPrint(
            '[Routes] Screen view tracked: $screenName with UTM params: ${utmData.toMap()}',
          );
        } else {
          await analyticsService.trackScreenView(
            screenName,
            screenClass: 'Screen',
          );
          debugPrint('[Routes] Screen view tracked: $screenName');
        }
      } catch (e) {
        debugPrint('[Routes] Failed to track screen view: $e');
      }
    });
  }
}
