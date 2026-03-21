import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MessengerCustomerSyncScreen extends StatefulWidget {
  const MessengerCustomerSyncScreen({super.key});

  @override
  State<MessengerCustomerSyncScreen> createState() =>
      _MessengerCustomerSyncScreenState();
}

class _MessengerCustomerSyncScreenState
    extends State<MessengerCustomerSyncScreen> {
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
        title: Text(l.translate('omnichannel_messenger_customer_sync_title')),
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
                        '${l.translate('omnichannel_last_sync')}: ${formatDateTime(messenger.lastSyncAt)}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l.translate('omnichannel_synced_customers')}: ${messenger.syncedCustomers}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l.translate('omnichannel_failed_customers')}: ${messenger.failedCustomers}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _store.isLoading ? null : _store.syncMessengerData,
                icon: const Icon(Icons.sync),
                label: Text(l.translate('omnichannel_sync_now_button')),
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
