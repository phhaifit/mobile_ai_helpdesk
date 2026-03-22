import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:mobile_ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:mobile_ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MessengerDashboardScreen extends StatefulWidget {
  const MessengerDashboardScreen({super.key});

  @override
  State<MessengerDashboardScreen> createState() =>
      _MessengerDashboardScreenState();
}

class _MessengerDashboardScreenState extends State<MessengerDashboardScreen> {
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
        title: Text(l.translate('omnichannel_messenger_dashboard_title')),
      ),
      body: Observer(
        builder: (_) {
          final data = _store.overview?.messenger;

          if (data == null && _store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (data == null) {
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
                        data.pageName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.translate(connectionStatusKey(data.connectionStatus)),
                        style: TextStyle(
                          color: connectionStatusColor(data.connectionStatus),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l.translate('omnichannel_last_sync')}: ${formatDateTime(data.lastSyncAt)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_messenger_oauth_status_title'),
                subtitle: l.translate(oauthStatusKey(data.oauthState)),
                route: Routes.messengerOauthStatus,
              ),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_messenger_customer_sync_title'),
                subtitle:
                    '${data.syncedCustomers} ${l.translate('omnichannel_synced')} / ${data.failedCustomers} ${l.translate('omnichannel_failed')}',
                route: Routes.messengerCustomerSync,
              ),
              _buildNavTile(
                context,
                title: l.translate('omnichannel_messenger_settings_title'),
                subtitle: l.translate(
                  'omnichannel_messenger_settings_subtitle',
                ),
                route: Routes.messengerSettings,
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
    required String subtitle,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
