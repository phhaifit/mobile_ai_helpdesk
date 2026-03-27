import 'dart:developer';

import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/data/analytics/first_launch_manager.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/firebase_options.dart';
import 'package:ai_helpdesk/presentation/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:developer';

// // import 'package:ai_helpdesk/di/service_locator.dart';
// // import 'package:ai_helpdesk/firebase_options.dart';
// // import 'package:ai_helpdesk/presentation/my_app.dart';
// // import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:ai_helpdesk/constants/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();

  try {
    try {
      Firebase.app();
    } catch (_) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e, st) {
    debugPrint('Firebase initialization failed: $e\n$st');
  }

  final env = EnvConfig.instance;
  log('Running in ${env.environment.name} mode — ${env.baseUrl}');

  // Initialize Firebase after bindings are ready
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
    // Continue app startup even if Firebase init fails (graceful degradation)
  }

  // Configure service locator and all dependencies
  await ServiceLocator.configureDependencies();

  try {
    final analyticsService = GetIt.instance<AnalyticsService>();
    final sharedPrefHelper = GetIt.instance<SharedPreferenceHelper>();

    final firstLaunchData = await FirstLaunchManager.checkAndTrackFirstLaunch(
      analyticsService: analyticsService,
      sharedPreferenceHelper: sharedPrefHelper,
    );
    debugPrint('[Main] App initialization complete: $firstLaunchData');
  } catch (e) {
    debugPrint('[Main] First launch tracking failed: $e');
  }

  if (!kIsWeb) {
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return !kDebugMode;
    };

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseCrashlytics.instance.setUserIdentifier('test-user-123');
    await FirebaseCrashlytics.instance.setCustomKey('tenant', 'default_tenant');
    await FirebaseCrashlytics.instance.setCustomKey('screen', 'startup_screen');
    await FirebaseCrashlytics.instance.log(
      'App started - Initializing services',
    );

    debugPrint('[Main] App initialization complete: $firstLaunchData');
  } catch (e) {
    debugPrint('[Main] First launch tracking failed: $e');
    // Continue app startup even if first launch tracking fails
  }

  runApp(const MyApp());
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // if (!kIsWeb) {
  //   // Catch framework errors
  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  //   // Catch async errors
  //   PlatformDispatcher.instance.onError = (error, stack) {
  //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //     return !kDebugMode;
  //   };

  //   // Enable crashlytics explicitly and add custom logs/keys.
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  //   await FirebaseCrashlytics.instance.setUserIdentifier('test-user-123');
  //   await FirebaseCrashlytics.instance.setCustomKey('tenant', 'default_tenant');
  //   await FirebaseCrashlytics.instance.setCustomKey('screen', 'startup_screen');
  //   await FirebaseCrashlytics.instance.log(
  //     'App started - Initializing services',
  //   );
  // }

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Helpdesk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.messengerBlue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      home: const LoginScreen(),
      onGenerateRoute: Routes.onGenerateRoute,
    );
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
