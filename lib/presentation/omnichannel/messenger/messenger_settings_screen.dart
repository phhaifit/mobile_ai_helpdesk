import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
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
  late final OmnichannelStore _store;

  bool _autoReply = false;
  String _language = 'vi';
  final TextEditingController _businessHourController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
    _store.fetchOverview().then((_) {
      final messenger = _store.overview?.messenger;
      if (messenger == null || !mounted) {
        return;
      }

      setState(() {
        _autoReply = messenger.autoReply;
        _language = messenger.language;
        _businessHourController.text = messenger.businessHours;
      });
    });
  }

  @override
  void dispose() {
    _businessHourController.dispose();
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
          _showActionMessageIfNeeded(context);

          if (_store.overview == null && _store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.overview == null) {
            return Center(
              child: Text(l.translate('omnichannel_generic_error')),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.translate('omnichannel_messenger_auto_reply')),
                value: _autoReply,
                onChanged: (value) => setState(() {
                  _autoReply = value;
                }),
              ),
              const SizedBox(height: 8),
              Text(l.translate('omnichannel_messenger_language')),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(value: 'vi', child: Text('Vietnamese')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _language = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(l.translate('omnichannel_messenger_business_hours')),
              const SizedBox(height: 6),
              TextField(
                controller: _businessHourController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l.translate(
                    'omnichannel_messenger_business_hours_hint',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _store.isLoading
                    ? null
                    : () {
                        _store.updateMessengerSettings(
                          autoReply: _autoReply,
                          language: _language,
                          businessHours: _businessHourController.text.trim(),
                        );
                      },
                icon: const Icon(Icons.save),
                label: Text(l.translate('omnichannel_save_button')),
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
