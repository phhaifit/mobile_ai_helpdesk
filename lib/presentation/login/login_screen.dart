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
    _store = GetIt.instance<LoginStore>();
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
                      onPressed: _store.canSubmit ? () => _handleLogin() : null,
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

                if (kDebugMode) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Test Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Email: test@example.com',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Password: Test@123456',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],

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
      await Navigator.pushReplacementNamed(context, Routes.home);
    }
  }
}
