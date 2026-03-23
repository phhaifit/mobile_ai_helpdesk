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
import '/presentation/home/home.dart';
import '/presentation/login/login_screen.dart';
import '/utils/deep_linking/utm_param_parser.dart';
import '/domain/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  // route generator -----------------------------------------------------------
  /// Generates routes with integrated UTM parameter parsing and analytics tracking.
  ///
  /// This method:
  /// 1. Extracts the route name from settings
  /// 2. Parses any UTM parameters from the route path
  /// 3. Tracks screen view with analytics
  /// 4. Returns the appropriate widget
  ///
  /// Example routes:
  /// - '/home' (no UTM params)
  /// - '/home?utm_source=google&utm_campaign=promo' (with UTM params)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Extract route name (without query parameters)
    final routePath = settings.name ?? '';
    final screenName = _extractRouteName(routePath);

    // Parse UTM parameters if present
    final utmData = UTMParamParser.parseRoutePath(routePath);

    // Track screen view with analytics asynchronously
    _trackScreenView(screenName, utmData);

    // Generate the appropriate route
    switch (screenName) {
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
          builder: (_) => ResetPasswordScreen(email: args?['email']),
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
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for $screenName')),
          ),
        );
    }
  }

  /// Extracts the route name from a full route path (removes query parameters).
  ///
  /// Example:
  /// - '/home?utm_source=google' → '/home'
  /// - '/login' → '/login'
  static String _extractRouteName(String routePath) {
    if (routePath.contains('?')) {
      return routePath.split('?')[0];
    }
    return routePath;
  }

  /// Tracks a screen view with UTM parameters via analytics service.
  ///
  /// This method is called asynchronously to avoid blocking navigation.
  /// If analytics service is not available, the error is silently ignored
  /// to ensure navigation continues regardless of analytics availability.
  static void _trackScreenView(String screenName, UTMData utmData) {
    // Run analytics tracking asynchronously (non-blocking)
    Future.microtask(() async {
      try {
        final getIt = GetIt.instance;
        final analyticsService = getIt<AnalyticsService>();

        // Track screen view with UTM parameters if available
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
        // Silently fail - don't block navigation if analytics fails
      }
    });
  }
}
