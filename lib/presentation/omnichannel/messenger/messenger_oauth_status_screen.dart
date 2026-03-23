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
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
    _store.fetchOverview();
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
              Stepper(
                physics: const NeverScrollableScrollPhysics(),
                currentStep: isConnected ? 2 : _currentStep,
                controlsBuilder: (_, __) => const SizedBox.shrink(),
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
                onPressed: _store.isLoading
                    ? null
                    : () async {
                        if (isConnected) {
                          await _store.disconnectMessenger();
                          if (mounted) {
                            setState(() {
                              _currentStep = 0;
                            });
                          }
                          return;
                        }

                        setState(() {
                          _currentStep = 1;
                        });
                        await Future.delayed(const Duration(milliseconds: 400));
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          _currentStep = 2;
                        });
                        await _store.connectMessenger();
                      },
                icon: Icon(isConnected ? Icons.link_off : Icons.verified_user),
                label: Text(
                  l.translate(
                    isConnected
                        ? 'omnichannel_disconnect_button'
                        : 'omnichannel_oauth_verify_button',
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
}
