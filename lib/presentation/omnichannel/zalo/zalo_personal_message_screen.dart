import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ZaloPersonalMessageScreen extends StatefulWidget {
  const ZaloPersonalMessageScreen({super.key});

  @override
  State<ZaloPersonalMessageScreen> createState() =>
      _ZaloPersonalMessageScreenState();
}

class _ZaloPersonalMessageScreenState extends State<ZaloPersonalMessageScreen> {
  late final OmnichannelStore _store;
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('omnichannel_zalo_personal_message_title')),
      ),
      body: Observer(
        builder: (_) {
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
                      Text(
                        l.translate('omnichannel_zalo_recipient_label'),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _recipientController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'e.g. 0912345678',
                          hintStyle: const TextStyle(color: Colors.black26),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l.translate('omnichannel_zalo_message_label'),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _messageController,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: l.translate('omnichannel_zalo_message_label'),
                          hintStyle: const TextStyle(color: Colors.black26),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _store.isLoading ? null : _sendMessage,
                icon: _store.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(l.translate('omnichannel_zalo_send_button')),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _sendMessage() async {
    final l = AppLocalizations.of(context);
    final recipient = _recipientController.text.trim();
    final message = _messageController.text.trim();

    if (recipient.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.translate('omnichannel_zalo_message_validation')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _store.sendZaloMessage(recipient: recipient, message: message);

    if (!mounted) {
      return;
    }

    final success = _store.actionWasSuccess;
    final messageKey = _store.actionMessageKey ?? 
        (success ? 'omnichannel_zalo_message_send_success' : 'omnichannel_zalo_message_send_failed');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.translate(messageKey)),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      _messageController.clear();
      _store.clearActionMessage();
    }
  }
}
