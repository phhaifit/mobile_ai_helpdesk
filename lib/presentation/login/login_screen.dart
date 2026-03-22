import 'package:ai_helpdesk/core/widgets/auth_text_field.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// LOGIN SCREEN WIDGET TREE:
/// Scaffold
///   └─ SafeArea
///       └─ Center
///           └─ SingleChildScrollView
///               └─ Column
///                   ├─ Icon (logo)
///                   ├─ Text (welcome title)
///                   ├─ Text (subtitle)
///                   ├─ SizedBox (spacing)
///                   ├─ [AuthTextField] (email)
///                   ├─ SizedBox (spacing)
///                   ├─ [AuthTextField] (password)
///                   ├─ SizedBox (spacing)
///                   ├─ FilledButton (sign in)
///                   ├─ SizedBox (spacing)
///                   ├─ TextButton (forgot password)
///                   └─ TextButton (sign up)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthStore _authStore;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

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

  void _handleLogin() async {
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
                // Logo icon
                Icon(
                  Icons.headset_mic,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Welcome title
                Text(
                  l.translate('login_tv_welcome'),
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  l.translate('login_tv_subtitle'),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email field
                AuthTextField(
                  label: l.translate('login_tv_email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                AuthTextField(
                  label: l.translate('login_tv_password'),
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Login button
                Observer(
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _authStore.isLoginLoading ? null : _handleLogin,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _authStore.isLoginLoading
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

                // Forgot password button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.forgotPassword);
                  },
                  child: Text(l.translate('login_tv_forgot_password')),
                ),

                const SizedBox(height: 8),

                // Sign up button
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
}
