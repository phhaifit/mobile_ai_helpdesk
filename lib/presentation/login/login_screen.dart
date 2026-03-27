import 'package:ai_helpdesk/core/analytics/analytics_event.dart';
import 'package:ai_helpdesk/core/analytics/analytics_user_property.dart';
import 'package:ai_helpdesk/core/widgets/auth_text_field.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '/presentation/login/store/login_store.dart';
import '/utils/locale/app_localization.dart';
import '/utils/routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginStore _store;

  @override
  void initState() {
    super.initState();
    _authStore = getIt<AuthStore>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate fields
    if (email.isEmpty) {
      FlushbarHelper.createError(message: 'Please enter email').show(context);
      return;
    }

    if (password.isEmpty) {
      FlushbarHelper.createError(message: 'Please enter password').show(context);
      return;
    }

    // Call login
    await _authStore.login(email: email, password: password);

    // Handle results
    if (!mounted) return;

    if (_authStore.isAuthenticated) {
      await _trackLoginAnalytics();
      FlushbarHelper.createSuccess(
        message: _authStore.successMessage ?? 'Login successful!',
      ).show(context);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      });
    } else {
      FlushbarHelper.createError(
        message: _authStore.errorMessage ?? 'Login failed',
      ).show(context);
    }
  }

  Future<void> _trackLoginAnalytics() async {
    final analytics = getIt<AnalyticsService>();
    final prefs = getIt<SharedPreferenceHelper>();

    await analytics.trackEvent(
      AnalyticsEvent.login,
      parameters: {
        AnalyticsEvent.paramMethod: 'email',
        AnalyticsEvent.paramSuccess: 'true',
      },
    );

    const tenantId = 'default_tenant';
    const role = 'agent';
    const planType = 'standard';

    await prefs.saveAnalyticsUserProperties(
      tenantId: tenantId,
      role: role,
      planType: planType,
    );

    await analytics.setUserProperties(
      tenantId,
      userProperties: {
        AnalyticsUserProperty.tenantId: tenantId,
        AnalyticsUserProperty.role: role,
        AnalyticsUserProperty.planType: planType,
      },
    );
  }

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
                Observer(
                  builder: (_) => TextField(
                    onChanged: _store.setEmail,
                    enabled: !_store.isLoading,
                    decoration: InputDecoration(
                      labelText: l.translate('login_tv_email'),
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                      errorText: _store.errorMessage,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) => TextField(
                    onChanged: _store.setPassword,
                    enabled: !_store.isLoading,
                    decoration: InputDecoration(
                      labelText: l.translate('login_tv_password'),
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: GestureDetector(
                        onTap: _store.togglePasswordVisibility,
                        child: Icon(
                          _store.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: !_store.isPasswordVisible,
                  ),
                ),
                const SizedBox(height: 24),
                Observer(
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          _authStore.isLoginLoading ? null : () => _handleLogin(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _store.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l.translate('login_btn_sign_in')),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.forgotPassword);
                  },
                  child: Text(l.translate('login_tv_forgot_password')),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.translate('login_tv_no_account')),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.register);
                      },
                      child: Text(l.translate('login_btn_sign_up')),
                    ),
                  ],
                ),
                if (kDebugMode && !kIsWeb) ...[
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      FirebaseCrashlytics.instance.crash();
                    },
                    child: Text(l.translate('login_btn_test_crash')),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    await _store.login();
    if (mounted && _store.errorMessage == null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }
}
