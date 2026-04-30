import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/messenger/store/messenger_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MessengerSettingsScreen extends StatefulWidget {
  const MessengerSettingsScreen({super.key});

  @override
  State<MessengerSettingsScreen> createState() =>
      _MessengerSettingsScreenState();
}

class _MessengerSettingsScreenState extends State<MessengerSettingsScreen> {
  late final MessengerStore _store;
  bool _autoReply = false;
  final TextEditingController _greetingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<MessengerStore>();
  }

  @override
  void dispose() {
    _greetingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('omnichannel_messenger_settings_title')),
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
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    page.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.translate('omnichannel_messenger_auto_reply')),
                value: _autoReply,
                onChanged: (v) => setState(() => _autoReply = v),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _greetingController,
                decoration: InputDecoration(
                  labelText: l.translate('omnichannel_messenger_greeting'),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _store.isLoading
                    ? null
                    : () => _store.updatePageConfig(
                          channelId: page.id,
                          autoReply: _autoReply,
                          greeting: _greetingController.text.trim(),
                        ),
                icon: const Icon(Icons.save),
                label: Text(l.translate('omnichannel_save_button')),
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
                ? AppLocalizations.of(context).translate('omnichannel_save_success')
                : _store.errorMessage,
          ),
          backgroundColor: _store.actionSuccess ? Colors.green : Colors.red,
        ),
      );
    });
  }
}
