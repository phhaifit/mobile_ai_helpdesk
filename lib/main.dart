import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import '/data/analytics/first_launch_manager.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/analytics/analytics_service.dart';
import '/presentation/login/login_screen.dart';
import '/utils/routes/routes.dart';
import 'constants/colors.dart';
import 'utils/locale/app_localization.dart';

void main() async {
  // Ensure Flutter bindings are initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

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
