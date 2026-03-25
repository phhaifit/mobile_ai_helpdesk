import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class OmnichannelHubScreen extends StatefulWidget {
  final bool showAppBar;

  const OmnichannelHubScreen({super.key, this.showAppBar = true});

  @override
  State<OmnichannelHubScreen> createState() => _OmnichannelHubScreenState();
}

class _OmnichannelHubScreenState extends State<OmnichannelHubScreen> {
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
    final body = _buildBody(context);

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('omnichannel_title'))),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Observer(
      builder: (_) {
        final data = _store.overview;

        if (data == null && _store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (data == null) {
          return Center(child: Text(l.translate('omnichannel_generic_error')));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildOverviewCard(context),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              title: l.translate('omnichannel_messenger_title'),
              subtitle: l.translate(
                connectionStatusKey(data.messenger.connectionStatus),
              ),
              icon: Icons.forum,
              color: Colors.blue,
              onTap: () =>
                  Navigator.pushNamed(context, Routes.messengerDashboard),
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              title: l.translate('omnichannel_zalo_title'),
              subtitle: l.translate(
                connectionStatusKey(data.zalo.connectionStatus),
              ),
              icon: Icons.chat_bubble,
              color: Colors.teal,
              onTap: () => Navigator.pushNamed(context, Routes.zaloOverview),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    final l = AppLocalizations.of(context);
    final data = _store.overview!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.translate('omnichannel_overview_title'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusTile(
                    context,
                    label: l.translate('omnichannel_messenger_title'),
                    value: l.translate(
                      connectionStatusKey(data.messenger.connectionStatus),
                    ),
                    color: connectionStatusColor(
                      data.messenger.connectionStatus,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusTile(
                    context,
                    label: l.translate('omnichannel_zalo_title'),
                    value: l.translate(
                      connectionStatusKey(data.zalo.connectionStatus),
                    ),
                    color: connectionStatusColor(data.zalo.connectionStatus),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
