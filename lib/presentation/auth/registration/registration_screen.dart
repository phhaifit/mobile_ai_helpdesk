import 'package:mobile_ai_helpdesk/core/widgets/auth_text_field.dart';
import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:mobile_ai_helpdesk/utils/routes/routes.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// REGISTRATION SCREEN WIDGET TREE:
/// Scaffold
///   ├─ AppBar (title)
///   └─ SafeArea
///       └─ Center
///           └─ SingleChildScrollView
///               └─ Column
///                   ├─ Icon (logo)
///                   ├─ Text (title)
///                   ├─ SizedBox (spacing)
///                   ├─ [AuthTextField] (email)
///                   ├─ [AuthTextField] (username)
///                   ├─ [AuthTextField] (password)
///                   ├─ [AuthTextField] (confirm password)
///                   ├─ SizedBox (spacing)
///                   ├─ FilledButton (sign up)
///                   └─ TextButton (sign in)

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final AuthStore _authStore;
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _authStore = getIt<AuthStore>();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate fields
    if (email.isEmpty || !email.contains('@')) {
      FlushbarHelper.createError(message: 'Please enter valid email').show(context);
      return;
    }

    if (username.isEmpty) {
      FlushbarHelper.createError(message: 'Please enter username').show(context);
      return;
    }

    if (password.isEmpty) {
      FlushbarHelper.createError(message: 'Please enter password').show(context);
      return;
    }

    // Call register
    await _authStore.register(
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (!mounted) return;

    if (_authStore.isAuthenticated) {
      FlushbarHelper.createSuccess(
        message: _authStore.successMessage ?? 'Registration successful!',
      ).show(context);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      });
    } else {
      FlushbarHelper.createError(
        message: _authStore.errorMessage ?? 'Registration failed',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('register_tv_title')),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo icon
                Icon(
                  Icons.person_add_outlined,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  l.translate('register_tv_title'),
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email field
                AuthTextField(
                  label: l.translate('register_tv_email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Username field
                AuthTextField(
                  label: l.translate('register_tv_username'),
                  controller: _usernameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Username is required';
                    if (value.length < 3) return 'Username must be at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                AuthTextField(
                  label: l.translate('register_tv_password'),
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 8) return 'Password must be at least 8 characters';
                    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain uppercase letter';
                    if (!value.contains(RegExp(r'[a-z]'))) return 'Must contain lowercase letter';
                    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain number';
                    if (!value.contains(RegExp(r'[@#%&*]'))) return 'Must contain special character';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password field
                AuthTextField(
                  label: l.translate('register_tv_confirm_password'),
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Confirm password is required';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Sign up button
                Observer(
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _authStore.isRegisterLoading ? null : _handleRegister,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _authStore.isRegisterLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l.translate('register_btn_sign_up')),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.translate('register_tv_have_account')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(l.translate('register_btn_sign_in')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
