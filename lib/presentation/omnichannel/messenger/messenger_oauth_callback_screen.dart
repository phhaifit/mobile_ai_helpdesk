import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_oauth_config.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';

class MessengerOauthCallbackScreen extends StatefulWidget {
  final String? code;
  final String? state;
  final String? error;

  const MessengerOauthCallbackScreen({
    super.key,
    this.code,
    this.state,
    this.error,
  });

  @override
  State<MessengerOauthCallbackScreen> createState() =>
      _MessengerOauthCallbackScreenState();
}

class _MessengerOauthCallbackScreenState
    extends State<MessengerOauthCallbackScreen> {
  late final OmnichannelStore _store;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _processCallback());
  }

  Future<void> _processCallback() async {
    if (!mounted) return;

    final String? error = widget.error;
    if (error != null && error.isNotEmpty) {
      _finishWith(success: false, messageKey: 'omnichannel_messenger_connect_failed');
      return;
    }

    final String code = widget.code?.trim() ?? '';
    if (code.isEmpty) {
      _finishWith(
        success: false,
        messageKey: 'omnichannel_messenger_auth_code_required',
      );
      return;
    }

    if (widget.state != MessengerOauthConfig.state) {
      _finishWith(
        success: false,
        messageKey: 'omnichannel_messenger_connect_failed',
      );
      return;
    }

    _store.pendingMessengerAuthCode = code;
    await _store.connectMessenger();
    if (!mounted) return;

    _finishWith(
      success: _store.actionWasSuccess,
      messageKey:
          _store.actionMessageKey ?? 'omnichannel_messenger_connect_success',
    );
  }

  void _finishWith({required bool success, required String messageKey}) {
    if (_completed || !mounted) return;
    _completed = true;

    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.translate(messageKey)),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
    _store.clearActionMessage();

    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.messengerDashboard,
      (Route<dynamic> route) => route.settings.name == Routes.omnichannelHub,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('omnichannel_messenger_oauth_status_title')),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
