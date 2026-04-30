import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/messenger/store/messenger_store.dart';
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
  late final MessengerStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<MessengerStore>();
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
          _showSnackIfNeeded(context);

          final page = _store.selectedPage;
          if (page == null) {
            return Center(child: Text(l.translate('omnichannel_no_page_selected')));
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
                        page.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Page ID: ${page.pageId}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _store.isLoading
                    ? null
                    : () => _store.resyncPage(page.id),
                icon: _store.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(l.translate('omnichannel_sync_now_button')),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnackIfNeeded(BuildContext context) {
    if (!_store.actionSuccess && _store.errorMessage.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _store.actionSuccess
                ? AppLocalizations.of(context).translate('omnichannel_sync_success')
                : _store.errorMessage,
          ),
          backgroundColor: _store.actionSuccess ? Colors.green : Colors.red,
        ),
      );
    });
  }
}
