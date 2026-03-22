import 'package:mobile_ai_helpdesk/core/widgets/auth_text_field.dart';
import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:mobile_ai_helpdesk/utils/routes/routes.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// RESET PASSWORD SCREEN WIDGET TREE:
/// Scaffold
///   ├─ AppBar
///   └─ SafeArea
///       └─ SingleChildScrollView
///           └─ Padding
///               └─ Column
///                   ├─ Icon
///                   ├─ Text (title)
///                   ├─ SizedBox
///                   ├─ [AuthTextField] (email)
///                   ├─ [AuthTextField] (token)
///                   ├─ [AuthTextField] (new password)
///                   ├─ [AuthTextField] (confirm password)
///                   ├─ SizedBox
///                   └─ FilledButton (reset)

class ResetPasswordScreen extends StatefulWidget {
  final String? email;

  const ResetPasswordScreen({super.key, this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final AuthStore _authStore;
  late final TextEditingController _emailController;
  late final TextEditingController _tokenController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _authStore = getIt<AuthStore>();
    _emailController = TextEditingController(text: widget.email ?? '');
    _tokenController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate
    if (email.isEmpty || !email.contains('@')) {
      FlushbarHelper.createError(message: 'Please enter valid email').show(context);
      return;
    }

    if (token.isEmpty) {
      FlushbarHelper.createError(message: 'Please enter reset token').show(context);
      return;
    }

    if (newPassword.isEmpty) {
      FlushbarHelper.createError(message: 'Please enter new password').show(context);
      return;
    }

    // Call reset password
    await _authStore.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (!mounted) return;

    if (_authStore.errorMessage == null) {
      FlushbarHelper.createSuccess(
        message: 'Password reset successfully!',
      ).show(context);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      });
    } else {
      FlushbarHelper.createError(
        message: _authStore.errorMessage ?? 'Reset failed',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('reset_password_tv_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.lock_reset_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                l.translate('reset_password_tv_title'),
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Email field
              AuthTextField(
                label: l.translate('common_email'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 16),

              // Token field
              AuthTextField(
                label: l.translate('reset_password_tv_token'),
                controller: _tokenController,
                prefixIcon: const Icon(Icons.key_outlined),
              ),
              const SizedBox(height: 16),

              // New password field
              AuthTextField(
                label: l.translate('reset_password_tv_new'),
                controller: _newPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outlined),
              ),
              const SizedBox(height: 16),

              // Confirm password field
              AuthTextField(
                label: l.translate('reset_password_tv_confirm'),
                controller: _confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outlined),
              ),
              const SizedBox(height: 32),

              // Reset button
              Observer(
                builder: (_) => SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _authStore.isResetPasswordLoading ? null : _handleResetPassword,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _authStore.isResetPasswordLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l.translate('reset_password_btn_reset')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
