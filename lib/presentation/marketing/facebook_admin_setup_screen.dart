import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_broadcast_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FacebookAdminSetupScreen extends StatefulWidget {
  const FacebookAdminSetupScreen({super.key});

  @override
  State<FacebookAdminSetupScreen> createState() =>
      _FacebookAdminSetupScreenState();
}

class _FacebookAdminSetupScreenState extends State<FacebookAdminSetupScreen> {
  late final MarketingBroadcastStore _store;
  final _accountIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _tokenController = TextEditingController();
  final _reauthTokenController = TextEditingController();
  bool _obscureToken = true;
  bool _obscureReauthToken = true;

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingBroadcastStore>();
    _store.fetchFacebookAdminAccounts();
  }

  @override
  void dispose() {
    _accountIdController.dispose();
    _nameController.dispose();
    _tokenController.dispose();
    _reauthTokenController.dispose();
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
                      'Nhập Access Token để kết nối hoặc re-auth tài khoản Facebook Admin.',
                      style: TextStyle(fontSize: isSmall ? 12 : 13),
                    ),
                  ),
                  SizedBox(height: isSmall ? 10 : 12),
                  if (_store.facebookAccounts.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      initialValue: _store.selectedFacebookAccountId,
                      decoration: const InputDecoration(
                        labelText: 'Facebook account',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items:
                          _store.facebookAccounts
                              .map(
                                (a) => DropdownMenuItem<String>(
                                  value: a.id,
                                  child: Text(
                                    a.adminName ?? a.adminEmail ?? a.id,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          _store.isSubmitting
                              ? null
                              : (value) {
                                _store.setSelectedFacebookAccount(value);
                                if (value != null && value.isNotEmpty) {
                                  _store.fetchFacebookAdminPages(value);
                                }
                              },
                    ),
                    SizedBox(height: isSmall ? 10 : 12),
                  ],
                  TextField(
                    controller: _accountIdController,
                    decoration: InputDecoration(
                      labelText: 'Account ID (optional)',
                      hintText: 'Facebook Ad Account ID',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.account_balance_outlined),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isSmall ? 8 : 12,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmall ? 10 : 12),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Account Name (optional)',
                      hintText: 'Display name for this account',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.label_outline),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isSmall ? 8 : 12,
                        horizontal: 12,
                      ),
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
                            () =>
                                setState(() => _obscureToken = !_obscureToken),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmall ? 12 : 16),
                  SizedBox(width: double.infinity,
                    child: FilledButton.icon(
                      onPressed:
                          _store.isSubmitting ||
                                  _tokenController.text.trim().isEmpty
                              ? null
                              : () => _store.createFacebookAdminAccount(
                                FacebookAdminAccountCreateData(
                                  accountId: _accountIdController.text
                                      .trim()
                                      .isEmpty
                                      ? null
                                      : _accountIdController.text.trim(),
                                  name: _nameController.text.trim().isEmpty
                                      ? null
                                      : _nameController.text.trim(),
                                  accessToken: _tokenController.text.trim(),
                                ),
                              ),
                      icon: const Icon(Icons.facebook),
                      label: Text(
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
                  if (_store.selectedFacebookAccount != null) ...[
                    SizedBox(height: isSmall ? 10 : 12),
                    TextField(
                      controller: _reauthTokenController,
                      obscureText: _obscureReauthToken,
                      decoration: InputDecoration(
                        labelText:
                            '${l.translate('marketing_tv_access_token')} (re-auth)',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.refresh_rounded),
                        isDense: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureReauthToken
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    _obscureReauthToken = !_obscureReauthToken,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmall ? 10 : 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                _store.isSubmitting ||
                                        _reauthTokenController.text
                                            .trim()
                                            .isEmpty
                                    ? null
                                    : () => _store.reauthFacebookAdminAccount(
                                      accountId:
                                          _store.selectedFacebookAccount!.id,
                                      accessToken:
                                          _reauthTokenController.text.trim(),
                                    ),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Re-auth'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                _store.isSubmitting
                                    ? null
                                    : () =>
                                        _store.disconnectFacebookAdminAccount(
                                          _store.selectedFacebookAccount!.id,
                                        ),
                            icon: const Icon(Icons.link_off, color: Colors.red),
                            label: Text(
                              l.translate('marketing_btn_disconnect_facebook'),
                              style: const TextStyle(color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (_store.facebookPages.isNotEmpty &&
                      _store.selectedFacebookAccount != null) ...[
                    SizedBox(height: isSmall ? 10 : 12),
                    DropdownButtonFormField<String>(
                      initialValue: _store.selectedFacebookAccount?.pageId,
                      decoration: InputDecoration(
                        labelText: l.translate('marketing_tv_facebook_page'),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      items:
                          _store.facebookPages
                              .map(
                                (p) => DropdownMenuItem<String>(
                                  value: p.id,
                                  child: Text(
                                    p.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          _store.isSubmitting
                              ? null
                              : (value) {
                                if (value == null || value.isEmpty) {
                                  return;
                                }
                                _store.selectFacebookAdminPage(
                                  accountId: _store.selectedFacebookAccount!.id,
                                  pageId: value,
                                );
                              },
                    ),
                  ],
                  if (_store.isSubmitting) ...[
                    SizedBox(height: isSmall ? 10 : 12),
                    const LinearProgressIndicator(),
                  ],
                  if (_store.errorMessage != null) ...[
                    SizedBox(height: isSmall ? 12 : 16),
                    _buildErrorBanner(l),
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
    final fa = _store.selectedFacebookAccount;
    final isConnected = _store.hasValidFacebookIntegration;
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
                    color: isConnected ? Colors.green : Colors.grey,
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
              _infoRow(Icons.person_outline, 'Admin', fa?.adminName ?? ''),
              SizedBox(height: isSmall ? 4 : 6),
              _infoRow(Icons.email_outlined, 'Email', fa?.adminEmail ?? ''),
              SizedBox(height: isSmall ? 4 : 6),
              _infoRow(
                Icons.pages_outlined,
                l.translate('marketing_tv_facebook_page'),
                fa?.pageName ?? '',
              ),
              if (fa?.connectedAt != null) ...[
                SizedBox(height: isSmall ? 4 : 6),
                _infoRow(
                  Icons.calendar_today_outlined,
                  'Kết nối lúc',
                  _formatDate(fa!.connectedAt!),
                ),
              ],
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

  Widget _buildErrorBanner(AppLocalizations l) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 10 : 12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: isSmall ? 18 : 20),
          SizedBox(width: isSmall ? 6 : 8),
          Expanded(
            child: Text(
              l.translate(_store.errorMessage ?? ''),
              style: TextStyle(fontSize: isSmall ? 12 : 13),
              maxLines: 3,
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
