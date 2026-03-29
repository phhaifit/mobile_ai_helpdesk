import 'dart:developer';

import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/data/analytics/first_launch_manager.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/firebase_options.dart';
import 'package:ai_helpdesk/presentation/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

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

  runApp(MyApp());
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
