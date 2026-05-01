import 'dart:async';
import 'dart:developer';

import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/data/analytics/first_launch_manager.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/firebase_options.dart';
import 'package:ai_helpdesk/presentation/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration from .env file
  await dotenv.load(fileName: '.env');
  log('✓ Loaded .env configuration');

  await setPreferredOrientations();

  final env = EnvConfig.instance;
  final resolvedUrl = EnvConfig.getResolvedBaseUrl();
  log('Running in ${env.environment.name} mode — $resolvedUrl');

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

// ignore: unused_element
Future<void> _configureSentryContext() async {
  try {
    final getIt = GetIt.instance;
    final env = EnvConfig.instance;
    final sentryService = getIt<SentryService>();

    await sentryService.setEnvironmentContext(env.sentryEnvironment);
    await sentryService.addBreadcrumb(
      message: 'Application started',
      category: 'app.lifecycle',
      data: {'environment': env.sentryEnvironment},
      type: 'navigation',
    );
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
