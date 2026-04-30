import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_oauth_config.dart';
import 'package:ai_helpdesk/presentation/omnichannel/messenger/messenger_oauth_launcher.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_ui_helpers.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/foundation.dart';
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
  late final OmnichannelStore _store;
  final TextEditingController _devAuthCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
    _store.fetchOverview();
  }

  @override
  void dispose() {
    _devAuthCodeController.dispose();
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

          final bool isConnected =
              messenger.connectionStatus ==
              IntegrationConnectionStatus.connected;

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
                        messenger.pageName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l.translate('omnichannel_connection_status')}: ${l.translate(connectionStatusKey(messenger.connectionStatus))}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l.translate('omnichannel_oauth_status')}: ${l.translate(oauthStatusKey(messenger.oauthState))}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (!isConnected) ...[
                Text(
                  l.translate('omnichannel_messenger_oauth_help'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 12),
              ],
              Stepper(
                physics: const NeverScrollableScrollPhysics(),
                currentStep: isConnected ? 2 : 0,
                controlsBuilder: (_, _) => const SizedBox.shrink(),
                steps: [
                  Step(
                    title: Text(l.translate('omnichannel_oauth_step_login')),
                    content: const SizedBox.shrink(),
                    isActive: true,
                  ),
                  Step(
                    title: Text(
                      l.translate('omnichannel_oauth_step_permission'),
                    ),
                    content: const SizedBox.shrink(),
                    isActive: isConnected,
                  ),
                  Step(
                    title: Text(l.translate('omnichannel_oauth_step_done')),
                    content: const SizedBox.shrink(),
                    isActive: isConnected,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed:
                    _store.isLoading
                        ? null
                        : () => _handlePrimaryAction(isConnected: isConnected),
                icon: Icon(isConnected ? Icons.link_off : Icons.verified_user),
                label: Text(
                  l.translate(
                    isConnected
                        ? 'omnichannel_disconnect_button'
                        : 'omnichannel_messenger_verify_and_connect_button',
                  ),
                ),
              ),
              if (!EnvConfig.instance.isProd) ...[
                const SizedBox(height: 12),
                ExpansionTile(
                  title: Text(
                    l.translate('omnichannel_messenger_dev_tools_title'),
                  ),
                  subtitle: Text(
                    l.translate('omnichannel_messenger_dev_tools_subtitle'),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    TextField(
                      controller: _devAuthCodeController,
                      maxLines: 2,
                      minLines: 1,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: l.translate(
                          'omnichannel_messenger_auth_code_label',
                        ),
                        hintText: l.translate(
                          'omnichannel_messenger_auth_code_hint',
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            _store.isLoading ? null : _handleDevAuthCodeSubmit,
                        child: Text(
                          l.translate(
                            'omnichannel_messenger_dev_tools_submit_code_button',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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

  Future<void> _handlePrimaryAction({required bool isConnected}) async {
    if (isConnected) {
      await _store.disconnectMessenger();
      return;
    }

    if (!kIsWeb) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.translate('omnichannel_messenger_connect_failed')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String redirectUri = _resolveOauthRedirectUri();
    launchMessengerOauth(
      MessengerOauthConfig.buildAuthorizeUrl(redirectUri: redirectUri),
    );
  }

  String _resolveOauthRedirectUri() {
    if (EnvConfig.instance.isDev) {
      return MessengerOauthConfig.prodRedirectUri;
    }

    return '${currentOrigin()}${MessengerOauthConfig.redirectPath}';
  }

  Future<void> _handleDevAuthCodeSubmit() async {
    final String authCode = _devAuthCodeController.text.trim();
    if (authCode.isEmpty) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.translate('omnichannel_messenger_auth_code_required'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _store.pendingMessengerAuthCode = authCode;
    await _store.connectMessenger();

    if (!mounted) {
      return;
    }

    if (_store.actionWasSuccess) {
      _devAuthCodeController.clear();
    }
  }
}
