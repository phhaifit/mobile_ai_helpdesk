import 'dart:async';

import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/firebase_options.dart';
import 'package:ai_helpdesk/presentation/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:developer';

import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/data/analytics/first_launch_manager.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/auth/user.dart';
import 'package:ai_helpdesk/firebase_options.dart';
import 'package:ai_helpdesk/presentation/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import '/di/service_locator.dart';
import '/data/analytics/first_launch_manager.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/analytics/analytics_service.dart';
import '/presentation/login/login_screen.dart';
import '/utils/routes/routes.dart';
import 'constants/colors.dart';
import 'utils/locale/app_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();

  final env = EnvConfig.instance;
  log('Running in ${env.environment.name} mode — ${env.baseUrl}');

  // Initialize Firebase
  try {
    try {
      Firebase.app();
    } catch (_) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Configure service locator and all dependencies
  await ServiceLocator.configureDependencies();

  await _trackFirstLaunch();
  runApp(MyApp());

  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn = env.sentryDsn;
  //     options.environment = env.sentryEnvironment;
  //     options.debug = env.isDev;
  //     options.enableAutoSessionTracking = true;
  //     options.attachStacktrace = true;
  //     options.tracesSampleRate = env.isProd ? 0.2 : 1.0;
  //     options.sendDefaultPii = false;
  //   },
  //   appRunner: () async {
  //     await _configureSentryContext();
  //     await _trackFirstLaunch();
  //     runApp(MyApp());
  //   },
  // );
}

Future<void> _trackFirstLaunch() async {
  // Check and track first app launch
  try {
    final getIt = GetIt.instance;
    final analyticsService = getIt<AnalyticsService>();
    final sharedPrefHelper = getIt<SharedPreferenceHelper>();

    final firstLaunchData = await FirstLaunchManager.checkAndTrackFirstLaunch(
      analyticsService: analyticsService,
      sharedPreferenceHelper: sharedPrefHelper,
    );

    debugPrint('[Main] App initialization complete: $firstLaunchData');
  } catch (e) {
    debugPrint('[Main] First launch tracking failed: $e');
  }
}

Future<void> _configureSentryContext() async {
  try {
    final getIt = GetIt.instance;
    final env = EnvConfig.instance;
    final sentryService = getIt<SentryService>();
    final sharedPrefHelper = getIt<SharedPreferenceHelper>();
    final User? user = await sharedPrefHelper.getUser();

    await sentryService.setEnvironmentContext(env.sentryEnvironment);
    await sentryService.addBreadcrumb(
      message: 'Application started',
      category: 'app.lifecycle',
      data: {'environment': env.sentryEnvironment},
      type: 'navigation',
    );

    if (user != null) {
      await sentryService.setUserContext(userId: user.id, email: user.email);
    }
  } catch (e) {
    debugPrint('[Main] Sentry context setup failed: $e');
  }
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
