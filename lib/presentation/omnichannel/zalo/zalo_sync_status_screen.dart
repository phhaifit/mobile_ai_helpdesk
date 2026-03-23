import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:mobile_ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ZaloSyncStatusScreen extends StatefulWidget {
  const ZaloSyncStatusScreen({super.key});

  @override
  State<ZaloSyncStatusScreen> createState() => _ZaloSyncStatusScreenState();
}

class _ZaloSyncStatusScreenState extends State<ZaloSyncStatusScreen> {
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
        title: Text(l.translate('omnichannel_zalo_sync_status_title')),
      ),
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
                        '${l.translate('omnichannel_connection_status')}: ${l.translate(connectionStatusKey(zalo.connectionStatus))}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l.translate('omnichannel_sync_status')}: ${l.translate(syncStateKey(zalo.syncState))}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l.translate('omnichannel_last_sync')}: ${formatDateTime(zalo.lastMessageSyncAt)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _store.isLoading ? null : _store.retryZaloSync,
                icon: const Icon(Icons.refresh),
                label: Text(l.translate('omnichannel_retry_sync_button')),
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
