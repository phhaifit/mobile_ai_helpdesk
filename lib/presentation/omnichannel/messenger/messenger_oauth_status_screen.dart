import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MessengerOauthStatusScreen extends StatefulWidget {
  const MessengerOauthStatusScreen({super.key});

  @override
  State<MessengerOauthStatusScreen> createState() =>
      _MessengerOauthStatusScreenState();
}

class _MessengerOauthStatusScreenState
    extends State<MessengerOauthStatusScreen> {
  late final OmnichannelStore _store;
  late final TextEditingController _authCodeController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
    _authCodeController = TextEditingController();
    _authCodeController.addListener(_handleAuthCodeChanged);
    _store.fetchOverview();
  }

  @override
  void dispose() {
    _authCodeController.removeListener(_handleAuthCodeChanged);
    _authCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('omnichannel_messenger_oauth_status_title')),
      ),
      body: Observer(
        builder: (_) {
          final messenger = _store.overview?.messenger;
          _showActionMessageIfNeeded(context);

          if (messenger == null && _store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (messenger == null) {
            return Center(
              child: Text(l.translate('omnichannel_generic_error')),
            );
          }

          final bool isConnected =
              messenger.connectionStatus ==
              IntegrationConnectionStatus.connected;
          final bool hasAuthCode = _authCodeController.text.trim().isNotEmpty;
          final int currentStep =
              isConnected ? 2 : (_currentStep == 2 ? 1 : _currentStep);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messenger.pageName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l.translate('omnichannel_connection_status')}: ${l.translate(connectionStatusKey(messenger.connectionStatus))}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l.translate('omnichannel_oauth_status')}: ${l.translate(oauthStatusKey(messenger.oauthState))}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (!isConnected) ...[
                TextField(
                  controller: _authCodeController,
                  enabled: !_store.isLoading,
                  decoration: InputDecoration(
                    labelText: l.translate(
                      'omnichannel_messenger_auth_code_label',
                    ),
                    hintText: l.translate(
                      'omnichannel_messenger_auth_code_hint',
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.translate('omnichannel_messenger_oauth_help'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 12),
              ],
              Stepper(
                physics: const NeverScrollableScrollPhysics(),
                currentStep: currentStep,
                controlsBuilder: (_, _) => const SizedBox.shrink(),
                steps: [
                  Step(
                    title: Text(l.translate('omnichannel_oauth_step_login')),
                    content: const SizedBox.shrink(),
                    isActive: true,
                  ),
                  Step(
                    title: Text(
                      l.translate('omnichannel_oauth_step_permission'),
                    ),
                    content: const SizedBox.shrink(),
                    isActive: isConnected || _currentStep >= 1,
                  ),
                  Step(
                    title: Text(l.translate('omnichannel_oauth_step_done')),
                    content: const SizedBox.shrink(),
                    isActive: isConnected || _currentStep >= 2,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed:
                    _store.isLoading
                        ? null
                        : () => _handlePrimaryAction(
                          isConnected: isConnected,
                          hasAuthCode: hasAuthCode,
                        ),
                icon: Icon(isConnected ? Icons.link_off : Icons.verified_user),
                label: Text(
                  l.translate(
                    isConnected
                        ? 'omnichannel_disconnect_button'
                        : 'omnichannel_messenger_verify_and_connect_button',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showActionMessageIfNeeded(BuildContext context) {
    final messageKey = _store.actionMessageKey;
    if (messageKey == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.translate(messageKey)),
          backgroundColor: _store.actionWasSuccess ? Colors.green : Colors.red,
        ),
      );
      _store.clearActionMessage();
    });
  }

  Future<void> _handlePrimaryAction({
    required bool isConnected,
    required bool hasAuthCode,
  }) async {
    if (isConnected) {
      await _store.disconnectMessenger();
      if (mounted) {
        setState(() {
          _currentStep = 0;
        });
      }
      return;
    }

    if (!hasAuthCode) {
      _store.pendingMessengerAuthCode = null;
      await _store.connectMessenger();
      return;
    }

    if (mounted) {
      setState(() {
        _currentStep = 1;
      });
    }

    _store.pendingMessengerAuthCode = _authCodeController.text;
    await _store.connectMessenger();

    if (mounted && _store.actionWasSuccess) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _handleAuthCodeChanged() {
    if (!mounted) {
      return;
    }

    if (_currentStep > 0) {
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    setState(() {});
  }
}
