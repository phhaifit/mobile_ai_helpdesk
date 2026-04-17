import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/messenger/store/messenger_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MessengerOauthStatusScreen extends StatefulWidget {
  const MessengerOauthStatusScreen({super.key});

  @override
  State<MessengerOauthStatusScreen> createState() =>
      _MessengerOauthStatusScreenState();
}

class _MessengerOauthStatusScreenState
    extends State<MessengerOauthStatusScreen> {
  late final MessengerStore _store;
  final _pageIdCtrl = TextEditingController();
  final _accessTokenCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<MessengerStore>();
  }

  @override
  void dispose() {
    _pageIdCtrl.dispose();
    _accessTokenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('omnichannel_messenger_oauth_status_title')),
      ),
      body: Observer(
        builder: (_) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_store.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _store.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (_store.actionSuccess)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    l.translate('omnichannel_connect_success'),
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              Text(
                l.translate('omnichannel_messenger_oauth_status_title'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pageIdCtrl,
                decoration: InputDecoration(
                  labelText: l.translate('omnichannel_page_id'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _accessTokenCtrl,
                decoration: InputDecoration(
                  labelText: l.translate('omnichannel_access_token'),
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.link),
                label: Text(l.translate('omnichannel_connect_page')),
                onPressed: _pageIdCtrl.text.trim().isEmpty ||
                        _accessTokenCtrl.text.trim().isEmpty
                    ? null
                    : () async {
                        await _store.connectPage(
                          _pageIdCtrl.text.trim(),
                          _accessTokenCtrl.text.trim(),
                        );
                        if (_store.actionSuccess && mounted) {
                          Navigator.pop(context);
                        }
                      },
              ),
            ],
          );
        },
      ),
    );
  }
}
