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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();

  runApp(const MyApp());
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final env = EnvConfig.instance;
  log('Running in ${env.environment.name} mode — ${env.baseUrl}');

  await ServiceLocator.configureDependencies();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
  }

  // runApp(MyApp());
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
