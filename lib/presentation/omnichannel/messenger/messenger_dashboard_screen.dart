import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/messenger/messenger_page.dart';
import 'package:ai_helpdesk/presentation/messenger/store/messenger_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MessengerDashboardScreen extends StatefulWidget {
  const MessengerDashboardScreen({super.key});

  @override
  State<MessengerDashboardScreen> createState() =>
      _MessengerDashboardScreenState();
}

class _MessengerDashboardScreenState extends State<MessengerDashboardScreen> {
  late final MessengerStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<MessengerStore>();
    _store.fetchPages();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('omnichannel_messenger_dashboard_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l.translate('omnichannel_connect_page'),
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.messengerOauthStatus,
            ).then((_) => _store.fetchPages()),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_store.isLoading && _store.pages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.errorMessage.isNotEmpty && _store.pages.isEmpty) {
            return Center(child: Text(_store.errorMessage));
          }

          if (_store.pages.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pages_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(l.translate('omnichannel_no_pages_connected')),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l.translate('omnichannel_connect_page')),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.messengerOauthStatus,
                    ).then((_) => _store.fetchPages()),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _store.fetchPages,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _store.pages.length,
              itemBuilder: (_, i) => _PageTile(
                page: _store.pages[i],
                store: _store,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PageTile extends StatelessWidget {
  final MessengerPage page;
  final MessengerStore store;

  const _PageTile({required this.page, required this.store});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: page.connected
              ? Colors.green.shade100
              : Colors.grey.shade200,
          child: Icon(
            Icons.facebook,
            color: page.connected ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(page.name),
        subtitle: Text(
          page.connected
              ? l.translate('omnichannel_status_connected')
              : l.translate('omnichannel_status_disconnected'),
          style: TextStyle(
            color: page.connected ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: page.connected
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: l.translate('omnichannel_messenger_settings_title'),
                    onPressed: () {
                      store.selectPage(page);
                      Navigator.pushNamed(context, Routes.messengerSettings);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.link_off, color: Colors.red),
                    tooltip: l.translate('omnichannel_disconnect_button'),
                    onPressed: () => _confirmDisconnect(context, l),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Future<void> _confirmDisconnect(
    BuildContext context,
    AppLocalizations l,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.translate('omnichannel_disconnect_button')),
        content: Text(page.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.translate('ai_agent_cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l.translate('omnichannel_disconnect_button')),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await store.disconnectPage(page.id);
    }
  }
}
