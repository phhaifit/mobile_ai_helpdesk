import 'package:mobile_ai_helpdesk/core/widgets/auth_text_field.dart';
import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// CHANGE PASSWORD SCREEN WIDGET TREE:
/// Scaffold
///   ├─ AppBar
///   └─ SafeArea
///       └─ SingleChildScrollView
///           └─ Padding
///               └─ Column
///                   ├─ Icon
///                   ├─ Text (title)
///                   ├─ SizedBox
///                   ├─ [AuthTextField] (current password)
///                   ├─ [AuthTextField] (new password)
///                   ├─ [AuthTextField] (confirm password)
///                   ├─ SizedBox
///                   └─ FilledButton

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final AuthStore _authStore;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _authStore = getIt<AuthStore>();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate
    if (currentPassword.isEmpty) {
      FlushbarHelper.createError(
        message: 'Please enter current password',
      ).show(context);
      return;
    }

    if (newPassword.isEmpty) {
      FlushbarHelper.createError(
        message: 'Please enter new password',
      ).show(context);
      return;
    }

    if (confirmPassword.isEmpty) {
      FlushbarHelper.createError(
        message: 'Please confirm new password',
      ).show(context);
      return;
    }

    // Call change password
    await _authStore.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (!mounted) return;

    if (_authStore.errorMessage == null) {
      FlushbarHelper.createSuccess(
        message: 'Password changed successfully!',
      ).show(context);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } else {
      FlushbarHelper.createError(
        message: _authStore.errorMessage ?? 'Failed to change password',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('change_password_tv_title'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.lock_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                l.translate('change_password_tv_title'),
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Current password field
              AuthTextField(
                label: l.translate('change_password_tv_current'),
                controller: _currentPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Current password is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // New password field
              AuthTextField(
                label: l.translate('change_password_tv_new'),
                controller: _newPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'New password is required';
                  if (value.length < 8)
                    return 'Password must be at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm password field
              AuthTextField(
                label: l.translate('change_password_tv_confirm'),
                controller: _confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Confirm password is required';
                  if (value != _newPasswordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Change button
              Observer(
                builder: (_) => SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _authStore.isChangePasswordLoading
                        ? null
                        : _handleChangePassword,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _authStore.isChangePasswordLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.translate('change_password_btn_change')),
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
