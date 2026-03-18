import 'package:ai_helpdesk/core/analytics/analytics_service.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.headset_mic,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  l.translate('login_tv_welcome'),
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.translate('login_tv_subtitle'),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                    labelText: l.translate('login_tv_email'),
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: l.translate('login_tv_password'),
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _onSignIn(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(l.translate('login_btn_sign_in')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignIn(BuildContext context) async {
    final analytics = getIt<AnalyticsService>();
    final prefs = getIt<SharedPreferenceHelper>();

    await analytics.logLoginEvent(method: 'email', success: true);
    await analytics.logLogin(method: 'email');

    // Placeholder until real auth API returns tenant/role/plan
    const tenantId = 'default_tenant';
    const role = 'agent';
    const planType = 'standard';
    await prefs.saveAuthToken('placeholder_token');
    await prefs.saveIsLoggedIn(true);
    await prefs.saveAnalyticsUserProperties(
      tenantId: tenantId,
      role: role,
      planType: planType,
    );
    await analytics.setUserProperties(
      tenantId: tenantId,
      role: role,
      planType: planType,
    );

    if (context.mounted) {
      await Navigator.pushReplacementNamed(context, Routes.home);
    }
  }
}
