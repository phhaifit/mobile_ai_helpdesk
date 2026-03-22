import '/utils/locale/app_localization.dart';
import '/utils/routes/routes.dart';
import '/presentation/login/store/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    await _store.login();
    if (mounted && _store.errorMessage == null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }
}
