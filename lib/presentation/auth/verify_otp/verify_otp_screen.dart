import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/verify_otp/store/verify_otp_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String nonce;
  const VerifyOtpScreen({
    required this.email,
    required this.nonce,
    super.key,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late final VerifyOtpStore _store;
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _store = getIt<VerifyOtpStore>()
      ..initialise(email: widget.email, nonce: widget.nonce);
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _store.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final ok = await _store.verify();
    if (!ok || !mounted) return;
    await Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.home,
      (_) => false,
    );
  }

  void _onChanged(String raw) {
    _store.setCode(raw);
    if (_codeController.text != _store.code) {
      _codeController.value = TextEditingValue(
        text: _store.code,
        selection: TextSelection.collapsed(offset: _store.code.length),
      );
    }
    if (_store.canSubmit) {
      _handleSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                l.translate('verify_tv_title'),
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '${l.translate('verify_tv_subtitle_to_email')} ${_store.maskedEmail}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Observer(
                builder: (_) => TextField(
                  controller: _codeController,
                  enabled: !_store.isVerifying,
                  autofocus: true,
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.visiblePassword,
                  maxLength: 6,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                    letterSpacing: 8,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[a-zA-Z0-9]'),
                    ),
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '••••••',
                    border: const OutlineInputBorder(),
                    errorText: _store.errorKey == null
                        ? null
                        : l.translate(_store.errorKey!),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Observer(
                builder: (_) => FilledButton(
                  onPressed: _store.canSubmit ? _handleSubmit : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: _store.isVerifying
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(l.translate('verify_btn_verify')),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Observer(
                builder: (_) {
                  if (_store.canResend) {
                    return TextButton(
                      onPressed: _store.isResending ? null : _store.resend,
                      child: Text(l.translate('verify_btn_resend')),
                    );
                  }
                  return Text(
                    '${l.translate('verify_tv_resend_in')} ${_store.resendCountdown}s',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.translate('verify_tv_change_email')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
