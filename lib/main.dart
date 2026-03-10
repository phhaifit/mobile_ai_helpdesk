import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'di/service_locator.dart';
import 'presentation/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
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
