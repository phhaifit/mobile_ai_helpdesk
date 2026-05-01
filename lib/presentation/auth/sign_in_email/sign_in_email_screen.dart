import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/sign_in_email/store/sign_in_email_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SignInEmailScreen extends StatefulWidget {
  const SignInEmailScreen({super.key});

  @override
  State<SignInEmailScreen> createState() => _SignInEmailScreenState();
}

class _SignInEmailScreenState extends State<SignInEmailScreen> {
  late final SignInEmailStore _store;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _store = getIt<SignInEmailStore>();
    _emailController = TextEditingController(text: _store.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nonce = await _store.sendOtp();
    if (!mounted) return;
    if (nonce != null && nonce.isNotEmpty) {
      await Navigator.of(context).pushNamed(
        Routes.verifyOtp,
        arguments: <String, String>{'email': _store.email, 'nonce': nonce},
      );
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
                Icon(Icons.headset_mic,
                    size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  l.translate('signin_tv_title'),
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.translate('signin_tv_subtitle'),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Observer(
                  builder: (_) => TextField(
                    controller: _emailController,
                    enabled: !_store.isLoading,
                    autofocus: true,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.send,
                    onChanged: _store.setEmail,
                    onSubmitted: (_) {
                      if (_store.canSubmit) _submit();
                    },
                    decoration: InputDecoration(
                      labelText: l.translate('signin_tv_email'),
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                      errorText: _store.errorKey == null
                          ? null
                          : l.translate(_store.errorKey!),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Observer(
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _store.canSubmit ? _submit : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: _store.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l.translate('signin_btn_send_code')),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.translate('signin_tv_we_send_email'),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
