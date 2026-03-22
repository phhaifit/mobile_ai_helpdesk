import 'dart:math';

import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class ZaloPersonalMessageScreen extends StatefulWidget {
  const ZaloPersonalMessageScreen({super.key});

  @override
  State<ZaloPersonalMessageScreen> createState() =>
      _ZaloPersonalMessageScreenState();
}

class _ZaloPersonalMessageScreenState extends State<ZaloPersonalMessageScreen> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _recipientController,
            decoration: InputDecoration(
              labelText: l.translate('omnichannel_zalo_recipient_label'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: l.translate('omnichannel_zalo_message_label'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isSending ? null : _sendMockMessage,
            icon: const Icon(Icons.send),
            label: Text(l.translate('omnichannel_zalo_send_button')),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMockMessage() async {
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

    setState(() {
      _isSending = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    final bool success = Random().nextBool();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l.translate(
            success
                ? 'omnichannel_zalo_message_send_success'
                : 'omnichannel_zalo_message_send_failed',
          ),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      _messageController.clear();
    }

    setState(() {
      _isSending = false;
    });
  }
}
