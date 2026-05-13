import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/external_browser_launcher.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_oauth_config.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/foundation.dart';
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

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed:
                      _store.isLoading
                          ? null
                          : () =>
                              _handlePrimaryAction(isConnected: isConnected),
                  icon: Icon(isConnected ? Icons.link_off : Icons.link),
                  label: Text(
                    l.translate(
                      isConnected
                          ? 'omnichannel_disconnect_button'
                          : 'omnichannel_messenger_verify_and_connect_button',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showActionMessageIfNeeded(BuildContext context) {
    final messageKey = _store.actionMessageKey;
    if (messageKey == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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

  Future<void> _handlePrimaryAction({required bool isConnected}) async {
    if (isConnected) {
      await _store.disconnectMessenger();
      return;
    }
    await _confirmAndOpenWebsite();
  }

  Future<void> _confirmAndOpenWebsite() async {
    final l = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogCtx) => AlertDialog(
            title: Text(
              l.translate('omnichannel_messenger_oauth_status_title'),
            ),
            content: Text(
              l.translate('omnichannel_messenger_connect_via_website_message'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(false),
                child: Text(l.translate('common_cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogCtx).pop(true),
                child: Text(
                  l.translate('omnichannel_messenger_open_website_button'),
                ),
              ),
            ],
          ),
    );

    if (confirmed != true || !mounted) return;

    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.translate('omnichannel_messenger_connect_failed')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    openExternalUrl(MessengerOauthConfig.websiteConnectUrl);
  }
}
