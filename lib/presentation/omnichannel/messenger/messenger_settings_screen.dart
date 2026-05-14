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
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l.translate('omnichannel_messenger_auto_reply'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: _autoReply,
                        onChanged: (value) => setState(() {
                          _autoReply = value;
                        }),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        l.translate('omnichannel_messenger_business_hours'),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _businessHourController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: l.translate(
                            'omnichannel_messenger_business_hours_hint',
                          ),
                          hintStyle: const TextStyle(color: Colors.black26),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed:
                    _store.isLoading
                        ? null
                        : () {
                          _store.updateMessengerSettings(
                            autoReply: _autoReply,
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
