import 'package:ai_helpdesk/core/widgets/auth_text_field.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

/// FORGOT PASSWORD SCREEN WIDGET TREE:
/// Scaffold
///   ├─ AppBar
///   └─ SafeArea
///       └─ SingleChildScrollView
///           └─ Padding
///               └─ Column
///                   ├─ Icon
///                   ├─ Text (title)
///                   ├─ Text (subtitle)
///                   ├─ SizedBox
///                   ├─ [AuthTextField] (email)
///                   ├─ SizedBox
///                   └─ FilledButton

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleRequestReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      FlushbarHelper.createError(
        message: 'Please enter valid email',
      ).show(context);
      return;
    }

    // For now, just show success (in mock API, request is accepted)
    FlushbarHelper.createSuccess(
      message: 'Reset link sent to your email',
    ).show(context);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('forgot_password_tv_title'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.email_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                l.translate('forgot_password_tv_title'),
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                l.translate('forgot_password_tv_subtitle'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Email field
              AuthTextField(
                label: l.translate('forgot_password_tv_email'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!value.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Send reset link button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _handleRequestReset,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l.translate('forgot_password_btn_reset')),
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
