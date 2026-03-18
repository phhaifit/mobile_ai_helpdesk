import 'package:flutter/material.dart';

import '/di/service_locator.dart';
import '/presentation/main_screen.dart';
import 'constants/colors.dart';

void main() async {
  await ServiceLocator.configureDependencies();
  runApp(const MyApp());
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
