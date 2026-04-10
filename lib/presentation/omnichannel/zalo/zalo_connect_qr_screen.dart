import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ZaloConnectQrScreen extends StatefulWidget {
  const ZaloConnectQrScreen({super.key});

  @override
  State<ZaloConnectQrScreen> createState() => _ZaloConnectQrScreenState();
}

class _ZaloConnectQrScreenState extends State<ZaloConnectQrScreen> {
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
      appBar: AppBar(title: Text(l.translate('omnichannel_zalo_qr_title'))),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: const Center(
                          child: Icon(Icons.qr_code_2, size: 120),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l.translate('omnichannel_zalo_qr_hint'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text(zalo.accountName),
                  subtitle: Text(
                    l.translate(connectionStatusKey(zalo.connectionStatus)),
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
                icon: Icon(isConnected ? Icons.link_off : Icons.qr_code),
                label: Text(
                  l.translate(
                    isConnected
                        ? 'omnichannel_disconnect_button'
                        : 'omnichannel_zalo_connect_qr_button',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.zaloSyncStatus),
                icon: const Icon(Icons.sync),
                label: Text(l.translate('omnichannel_zalo_sync_status_title')),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.zaloAccountAssignment),
                icon: const Icon(Icons.manage_accounts),
                label: Text(l.translate('omnichannel_zalo_assignment_title')),
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
