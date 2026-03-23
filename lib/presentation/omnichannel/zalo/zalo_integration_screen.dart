import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ZaloIntegrationScreen extends StatefulWidget {
  const ZaloIntegrationScreen({super.key});

  @override
  State<ZaloIntegrationScreen> createState() => _ZaloIntegrationScreenState();
}

class _ZaloIntegrationScreenState extends State<ZaloIntegrationScreen> {
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
        title: Text(l.translate('omnichannel_zalo_overview_title')),
      ),
      body: Observer(
        builder: (_) {
          final zalo = _store.overview?.zalo;
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
              const SizedBox(height: 12),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_zalo_qr_title'),
                route: Routes.zaloConnectQr,
              ),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_zalo_oauth_title'),
                route: Routes.zaloOauthManagement,
              ),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_zalo_sync_status_title'),
                route: Routes.zaloSyncStatus,
              ),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_zalo_assignment_title'),
                route: Routes.zaloAccountAssignment,
              ),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_zalo_personal_message_title'),
                route: Routes.zaloPersonalMessage,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context, {
    required String title,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
