/// WIDGET TREE:
/// Scaffold
///   AppBar(title: marketing_tv_facebook_admin)
///   Observer
///     SingleChildScrollView
///       Column(padding: 16)
///         _buildStatusCard()   // connected: show info + disconnect; not connected: show connect form
///         if not connected:
///           TextField (accessToken, obscured with toggle)
///           FilledButton.icon (connect)
///         if isSubmitting: LinearProgressIndicator
///         if actionMessageKey != null: _buildFeedbackBanner()

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';

class FacebookAdminSetupScreen extends StatefulWidget {
  const FacebookAdminSetupScreen({super.key});

  @override
  State<FacebookAdminSetupScreen> createState() =>
      _FacebookAdminSetupScreenState();
}

class _FacebookAdminSetupScreenState extends State<FacebookAdminSetupScreen> {
  late final MarketingStore _store;
  final _tokenController = TextEditingController();
  bool _obscureToken = true;

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
    _tokenController.addListener(
      () => _store.setFacebookAccessTokenDraft(_tokenController.text),
    );
    if (_store.overview == null) _store.fetchOverview();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('marketing_tv_facebook_admin'))),
      body: Observer(
        builder:
            (_) => SingleChildScrollView(
              padding: EdgeInsets.all(isSmall ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(l),
                  SizedBox(height: isSmall ? 12 : 16),
                  if (_store.facebookAdmin.status !=
                      FacebookAdminStatus.connected) ...[
                    const Divider(),
                    SizedBox(height: isSmall ? 12 : 16),
                    Text(
                      l.translate('marketing_tv_facebook_admin'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 14 : 16,
                      ),
                    ),
                    SizedBox(height: isSmall ? 6 : 8),
                    Container(
                      padding: EdgeInsets.all(isSmall ? 10 : 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Nhập Access Token từ Facebook Business Manager để kết nối tài khoản Admin. Token này sẽ cho phép gửi tin nhắn qua Messenger.',
                        style: TextStyle(fontSize: isSmall ? 12 : 13),
                      ),
                    ),
                    SizedBox(height: isSmall ? 10 : 12),
                    TextField(
                      controller: _tokenController,
                      obscureText: _obscureToken,
                      decoration: InputDecoration(
                        labelText: l.translate('marketing_tv_access_token'),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isSmall ? 8 : 12,
                          horizontal: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureToken
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed:
                              () => setState(
                                () => _obscureToken = !_obscureToken,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmall ? 12 : 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed:
                            _store.isSubmitting || _tokenController.text.isEmpty
                                ? null
                                : _store.connectFacebookAdmin,
                        icon: const Icon(Icons.facebook),
                        label:
                            _store.isSubmitting
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  l.translate('marketing_btn_connect_facebook'),
                                ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F2),
                          padding: EdgeInsets.symmetric(
                            vertical: isSmall ? 10 : 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (_store.isSubmitting) ...[
                    SizedBox(height: isSmall ? 10 : 12),
                    const LinearProgressIndicator(),
                  ],
                  if (_store.actionMessageKey != null) ...[
                    SizedBox(height: isSmall ? 12 : 16),
                    _buildFeedbackBanner(l),
                  ],
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildStatusCard(AppLocalizations l) {
    final fa = _store.facebookAdmin;
    final isConnected = fa.status == FacebookAdminStatus.connected;
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isConnected
                            ? Colors.green
                            : (fa.status == FacebookAdminStatus.connecting
                                ? Colors.orange
                                : Colors.grey),
                  ),
                ),
                SizedBox(width: isSmall ? 6 : 8),
                Text(
                  isConnected
                      ? l.translate('marketing_tv_facebook_connected')
                      : 'Chưa kết nối',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall ? 13 : 15,
                  ),
                ),
              ],
            ),
            if (isConnected) ...[
              const Divider(height: 20),
              _infoRow(Icons.person_outline, 'Admin', fa.adminName ?? ''),
              SizedBox(height: isSmall ? 4 : 6),
              _infoRow(Icons.email_outlined, 'Email', fa.adminEmail ?? ''),
              SizedBox(height: isSmall ? 4 : 6),
              _infoRow(
                Icons.pages_outlined,
                l.translate('marketing_tv_facebook_page'),
                fa.pageName ?? '',
              ),
              if (fa.connectedAt != null) ...[
                SizedBox(height: isSmall ? 4 : 6),
                _infoRow(
                  Icons.calendar_today_outlined,
                  'Kết nối lúc',
                  _formatDate(fa.connectedAt!),
                ),
              ],
              SizedBox(height: isSmall ? 10 : 12),
              SizedBox(
                width: double.infinity,
                child:
                    isSmall
                        ? OutlinedButton.icon(
                          onPressed:
                              _store.isSubmitting
                                  ? null
                                  : _store.disconnectFacebookAdmin,
                          icon: const Icon(
                            Icons.link_off,
                            color: Colors.red,
                            size: 18,
                          ),
                          label: Text(
                            l.translate('marketing_btn_disconnect_facebook'),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        )
                        : OutlinedButton.icon(
                          onPressed:
                              _store.isSubmitting
                                  ? null
                                  : _store.disconnectFacebookAdmin,
                          icon: const Icon(Icons.link_off, color: Colors.red),
                          label: Text(
                            l.translate('marketing_btn_disconnect_facebook'),
                            style: const TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
              ),
            ] else ...[
              SizedBox(height: isSmall ? 6 : 8),
              Text(
                'Kết nối Facebook Admin để gửi tin nhắn Messenger từ hệ thống.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isSmall ? 12 : 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Row(
      children: [
        Icon(icon, size: isSmall ? 14 : 16, color: Colors.grey),
        SizedBox(width: isSmall ? 6 : 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: isSmall ? 12 : 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: isSmall ? 12 : 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackBanner(AppLocalizations l) {
    final isSuccess = _store.actionWasSuccess;
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 10 : 12),
      decoration: BoxDecoration(
        color: (isSuccess ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isSuccess ? Colors.green : Colors.red).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            color: isSuccess ? Colors.green : Colors.red,
            size: isSmall ? 18 : 20,
          ),
          SizedBox(width: isSmall ? 6 : 8),
          Expanded(
            child: Text(
              l.translate(_store.actionMessageKey ?? ''),
              style: TextStyle(fontSize: isSmall ? 12 : 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _store.clearActionFeedback,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
}
