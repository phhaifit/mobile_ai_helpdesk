import 'dart:async';
import 'dart:developer';

import 'package:ai_helpdesk/constants/app_theme.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/constants/dimens.dart';
import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/constants/strings.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();

  final env = EnvConfig.instance;
  log('Running in ${env.environment.name} mode — ${env.baseUrl}');

  await ServiceLocator.configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: AppThemeData.lightThemeData,
      darkTheme: AppThemeData.darkThemeData,
      home: const ThemeDemoScreen(),
    );
  }
}

class ThemeDemoScreen extends StatelessWidget {
  const ThemeDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName, style: textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.horizontalPadding,
          vertical: Dimens.verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Color Tokens ---
            Text('Color Tokens', style: textTheme.headlineMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorChip('Primary', colorScheme.primary),
                _ColorChip('On Primary', colorScheme.onPrimary),
                _ColorChip('Secondary', colorScheme.secondary),
                _ColorChip('Surface', colorScheme.surface),
                _ColorChip('Error', colorScheme.error),
              ],
            ),
            const SizedBox(height: 8),
            Text('Blue Swatch', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: Row(
                children: AppColors.blue.entries.map((e) {
                  return Expanded(
                    child: Container(color: e.value),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 32),

            // --- Typography ---
            Text('Typography', style: textTheme.headlineMedium),
            const SizedBox(height: 12),
            _TypographyRow('headlineMedium', textTheme.headlineMedium!),
            _TypographyRow('headlineSmall', textTheme.headlineSmall!),
            _TypographyRow('titleLarge', textTheme.titleLarge!),
            _TypographyRow('titleMedium', textTheme.titleMedium!),
            _TypographyRow('titleSmall', textTheme.titleSmall!),
            _TypographyRow('bodyLarge', textTheme.bodyLarge!),
            _TypographyRow('bodyMedium', textTheme.bodyMedium!),
            _TypographyRow('bodySmall', textTheme.bodySmall!),
            _TypographyRow('labelLarge', textTheme.labelLarge!),
            _TypographyRow('labelSmall', textTheme.labelSmall!),
            const Divider(height: 32),

            // --- Component Samples ---
            Text('Components', style: textTheme.headlineMedium),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {},
              child: const Text('Filled Button'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.headset_mic, color: colorScheme.primary),
                title: Text('Sample Card', style: textTheme.titleMedium),
                subtitle: Text(
                  'Demonstrates theme surface and text styles.',
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ColorChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final isBright = ThemeData.estimateBrightnessForColor(color) == Brightness.light;
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: isBright ? Colors.black87 : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TypographyRow extends StatelessWidget {
  final String name;
  final TextStyle style;
  const _TypographyRow(this.name, this.style);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(name, style: Theme.of(context).textTheme.labelSmall),
          ),
          Expanded(child: Text(Strings.appName, style: style)),
        ],
      ),
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
