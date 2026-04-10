import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ZaloOauthManagementScreen extends StatefulWidget {
  const ZaloOauthManagementScreen({super.key});

  @override
  State<ZaloOauthManagementScreen> createState() =>
      _ZaloOauthManagementScreenState();
}

class _ZaloOauthManagementScreenState extends State<ZaloOauthManagementScreen> {
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
      appBar: AppBar(title: Text(l.translate('omnichannel_zalo_oauth_title'))),
      body: Observer(
        builder: (_) {
          final zalo = _store.overview?.zalo;
          _showActionMessageIfNeeded(context);

          if (zalo == null && _store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (zalo == null) {
            return Center(
              child: Text(l.translate('omnichannel_generic_error')),
            );
          }

          final bool isConnected =
              zalo.connectionStatus == IntegrationConnectionStatus.connected;

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
                          zalo.accountName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${l.translate('omnichannel_connection_status')}: ${l.translate(connectionStatusKey(zalo.connectionStatus))}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l.translate('omnichannel_oauth_status')}: ${l.translate(oauthStatusKey(zalo.oauthState))}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _store.isLoading
                      ? null
                      : () {
                          if (isConnected) {
                            _store.disconnectZalo();
                          } else {
                            _store.connectZaloFromQr();
                          }
                        },
                  icon: Icon(isConnected ? Icons.link_off : Icons.link),
                  label: Text(
                    l.translate(
                      isConnected
                          ? 'omnichannel_disconnect_button'
                          : 'omnichannel_connect_button',
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
