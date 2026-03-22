import 'dart:async';
import 'dart:developer';

import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/firebase_options.dart';
import 'package:ai_helpdesk/presentation/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/di/service_locator.dart';
import '/presentation/main_screen.dart';
import 'constants/colors.dart';

void main() async {
  await ServiceLocator.configureDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    // Catch framework errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Catch async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return !kDebugMode;
    };

    // Enable crashlytics explicitly and add custom logs/keys.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseCrashlytics.instance.setUserIdentifier('test-user-123');
    await FirebaseCrashlytics.instance.setCustomKey('tenant', 'default_tenant');
    await FirebaseCrashlytics.instance.setCustomKey('screen', 'startup_screen');
    await FirebaseCrashlytics.instance.log(
      'App started - Initializing services',
    );
  }

  runApp(MyApp());
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
      home: const MainScreen(),
    );
  }
}
