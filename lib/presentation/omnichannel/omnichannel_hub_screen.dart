import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class OmnichannelHubScreen extends StatefulWidget {
  final bool showAppBar;

  const OmnichannelHubScreen({super.key, this.showAppBar = true});

  @override
  State<OmnichannelHubScreen> createState() => _OmnichannelHubScreenState();
}

class _OmnichannelHubScreenState extends State<OmnichannelHubScreen> {
  late final OmnichannelStore _store;
  int _rowsPerPage = 10;

  static const List<int> _pageSizeOptions = <int>[10, 20, 50];

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
    _store.fetchOverview();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final body = _buildBody(context);

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('omnichannel_title'))),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Observer(
      builder: (_) {
        final data = _store.overview;

        if (data == null && _store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (data == null) {
          return Center(child: Text(l.translate('omnichannel_generic_error')));
        }

        _showActionMessageIfNeeded(context);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l.translate('omnichannel_apps_integration_title'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l.translate('omnichannel_apps_integration_subtitle'),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Text(
              l.translate('omnichannel_integrated_apps_title'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _buildIntegratedAppsCard(context, data),
            const SizedBox(height: 24),
            Text(
              l.translate('omnichannel_add_app_title'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l.translate('omnichannel_app_type_omnichannel'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildMessengerAppCard(context, data.messenger),
          ],
        );
      },
    );
  }

  Widget _buildIntegratedAppsCard(
    BuildContext context,
    OmnichannelOverview data,
  ) {
    final l = AppLocalizations.of(context);

    final List<_IntegratedAppItem> integratedApps = <_IntegratedAppItem>[
      if (data.messenger.connectionStatus ==
          IntegrationConnectionStatus.connected)
        _IntegratedAppItem(
          appName: data.messenger.pageName,
          appType: l.translate('omnichannel_messenger_title'),
          onTap: () => Navigator.pushNamed(context, Routes.messengerDashboard),
        ),
      if (data.zalo.connectionStatus == IntegrationConnectionStatus.connected)
        _IntegratedAppItem(
          appName: data.zalo.accountName,
          appType: l.translate('omnichannel_zalo_title'),
          onTap: () => Navigator.pushNamed(context, Routes.zaloOverview),
        ),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.translate('omnichannel_table_app_name'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l.translate('omnichannel_table_app_type'),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (integratedApps.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 18),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/img_no_jobs.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l.translate('omnichannel_integrated_empty_title'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l.translate('omnichannel_integrated_empty_subtitle'),
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: integratedApps.length,
                separatorBuilder:
                    (_, _) => Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                itemBuilder: (BuildContext context, int index) {
                  final _IntegratedAppItem item = integratedApps[index];
                  return InkWell(
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.appName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.appType,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black.withValues(alpha: 0.08),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Text(
                    '${l.translate('omnichannel_rows_per_page')}:',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.black87),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.15),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _rowsPerPage,
                        items: _pageSizeOptions
                            .map(
                              (int value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value'),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (int? value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _rowsPerPage = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '1',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessengerAppCard(
    BuildContext context,
    MessengerIntegrationState messenger,
  ) {
    final l = AppLocalizations.of(context);
    final bool isConnected =
        messenger.connectionStatus == IntegrationConnectionStatus.connected;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        color: Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openMessengerModal(context, messenger),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF7059FF), Color(0xFF14A0FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.chat_rounded, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.translate('omnichannel_messenger_title'),
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (isConnected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l.translate('omnichannel_connected_badge'),
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.translate('omnichannel_messenger_card_description'),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openMessengerModal(
    BuildContext context,
    MessengerIntegrationState messenger,
  ) async {
    final l = AppLocalizations.of(context);

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Observer(
          builder: (_) {
            final bool isConnected =
                (_store.overview?.messenger.connectionStatus ??
                    messenger.connectionStatus) ==
                IntegrationConnectionStatus.connected;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.translate('omnichannel_messenger_modal_title'),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF7059FF), Color(0xFF14A0FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.chat_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l.translate('omnichannel_messenger_modal_intro'),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l.translate('omnichannel_messenger_modal_hint'),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _store.isLoading
                                ? null
                                : () async {
                                  if (isConnected) {
                                    Navigator.of(dialogContext).pop();
                                    if (!dialogContext.mounted) {
                                      return;
                                    }
                                    await Navigator.pushNamed(
                                      dialogContext,
                                      Routes.messengerDashboard,
                                    );
                                    return;
                                  }

                                  Navigator.of(dialogContext).pop();
                                  if (!dialogContext.mounted) {
                                    return;
                                  }

                                  await Navigator.pushNamed(
                                    dialogContext,
                                    Routes.messengerOauthStatus,
                                  );

                                  if (!mounted) {
                                    return;
                                  }

                                  await _store.fetchOverview();
                                },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l.translate(
                            isConnected
                                ? 'omnichannel_open_dashboard_button'
                                : 'omnichannel_messenger_modal_connect_button',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F4FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.info_outline,
                              color: Color(0xFF0B5F85),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.translate(
                                    'omnichannel_messenger_modal_info_title',
                                  ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0B5F85),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l.translate(
                                    'omnichannel_messenger_modal_info_body',
                                  ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    color: const Color(0xFF0B5F85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(l.translate('omnichannel_close_button')),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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

class _IntegratedAppItem {
  final String appName;
  final String appType;
  final VoidCallback onTap;

  const _IntegratedAppItem({
    required this.appName,
    required this.appType,
    required this.onTap,
  });
}
