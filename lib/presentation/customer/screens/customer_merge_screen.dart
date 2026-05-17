import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CustomerMergeScreen extends StatefulWidget {
  final Customer customer;
  final CustomerStore store;
  final VoidCallback onBack;

  const CustomerMergeScreen({
    required this.customer,
    required this.store,
    required this.onBack,
    super.key,
  });

  @override
  State<CustomerMergeScreen> createState() => _CustomerMergeScreenState();
}

class _CustomerMergeScreenState extends State<CustomerMergeScreen> {
  late Customer _primary;
  Customer? _secondary;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _primary = widget.customer;
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _selectSecondary(Customer c) {
    setState(() {
      _secondary = c;
      _searchCtrl.clear();
      _searchQuery = '';
      FocusScope.of(context).unfocus();
    });
  }

  void _clearSecondary() {
    setState(() => _secondary = null);
  }

  Future<void> _onConfirmTap() async {
    if (_secondary == null) return;
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.translate('customer_merge_confirm_dialog_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.translate('customer_merge_consequence_data')),
            const SizedBox(height: 8),
            Text(l10n.translate('customer_merge_consequence_irreversible'),
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(l10n.translate('common_cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(
              l10n.translate('customer_merge_confirm_dialog_btn'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final success = await widget.store.mergeCustomers(
      primaryId: _primary.id,
      secondaryId: _secondary!.id,
    );
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('customer_merge_success'))),
      );
      widget.onBack();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_resolveErrorMessage(widget.store.errorMessage, l10n))),
      );
    }
  }

  String _resolveErrorMessage(String? code, AppLocalizations l10n) {
    switch (code) {
      case 'subscription_required':
        return l10n.translate('customer_merge_error_subscription');
      case 'permission_denied':
        return l10n.translate('customer_merge_error_permission');
      case 'generic':
      case null:
        return l10n.translate('customer_merge_error_generic');
      default:
        return code;
    }
  }

  List<Customer> _filteredCandidates(List<Customer> all) {
    final excludeIds = <String>{_primary.id, if (_secondary != null) _secondary!.id};
    final base = all.where((c) => !excludeIds.contains(c.id));
    if (_searchQuery.isEmpty) return base.toList();
    return base.where((c) {
      final hay = [
        c.fullName,
        ...c.emails,
        ...c.phones,
        ...c.zalos,
        ...c.messengers,
      ].join(' ').toLowerCase();
      return hay.contains(_searchQuery);
    }).toList();
  }

  String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  int _contactCount(Customer c) =>
      c.emails.length + c.phones.length + c.zalos.length + c.messengers.length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(l10n),
                  const SizedBox(height: 16),
                  _buildPrimaryCard(l10n),
                  const SizedBox(height: 16),
                  if (_secondary == null) _buildSearchAndCandidates(l10n) else _buildSecondaryCard(l10n),
                  if (_secondary != null) ...[
                    const SizedBox(height: 16),
                    _buildComparison(l10n),
                    const SizedBox(height: 16),
                    _buildConsequences(l10n),
                  ],
                  const SizedBox(height: 20),
                  _buildActions(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translate('customer_merge_title'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.translate('customer_merge_subtitle'),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: widget.onBack,
        ),
      ],
    );
  }

  Widget _buildPrimaryCard(AppLocalizations l10n) {
    return _CustomerSummaryCard(
      customer: _primary,
      badgeText: l10n.translate('customer_merge_keep_label'),
      badgeColor: Colors.green,
      contactCount: _contactCount(_primary),
      tagCount: _primary.tags.length,
      l10n: l10n,
      initials: _initials(_primary.fullName),
    );
  }

  Widget _buildSearchAndCandidates(AppLocalizations l10n) {
    return Observer(
      builder: (_) {
        final candidates = _filteredCandidates(widget.store.customers.toList());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: l10n.translate('customer_merge_search_hint'),
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: candidates.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.translate('customer_merge_no_candidates'),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: candidates.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final c = candidates[i];
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                            backgroundImage: (c.avatarUrl != null && c.avatarUrl!.isNotEmpty)
                                ? NetworkImage(c.avatarUrl!)
                                : null,
                            child: (c.avatarUrl == null || c.avatarUrl!.isEmpty)
                                ? Text(_initials(c.fullName),
                                    style: const TextStyle(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))
                                : null,
                          ),
                          title: Text(c.fullName, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                            [
                              if (c.emails.isNotEmpty) c.emails.first,
                              if (c.phones.isNotEmpty) c.phones.first,
                            ].join(' • '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () => _selectSecondary(c),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSecondaryCard(AppLocalizations l10n) {
    return Stack(
      children: [
        _CustomerSummaryCard(
          customer: _secondary!,
          badgeText: l10n.translate('customer_merge_archive_label'),
          badgeColor: Colors.orange,
          contactCount: _contactCount(_secondary!),
          tagCount: _secondary!.tags.length,
          l10n: l10n,
          initials: _initials(_secondary!.fullName),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: _clearSecondary,
            tooltip: l10n.translate('common_cancel'),
          ),
        ),
      ],
    );
  }

  Widget _buildComparison(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('customer_merge_section_compare'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _comparisonRow(
            l10n.translate('customer_detail_contact_info'),
            l10n.translate('customer_merge_field_contacts')
                .replaceAll('{n}', '${_contactCount(_primary)}'),
            l10n.translate('customer_merge_field_contacts')
                .replaceAll('{n}', '${_contactCount(_secondary!)}'),
          ),
          _comparisonRow(
            l10n.translate('customer_filter_tags'),
            l10n.translate('customer_merge_field_tags')
                .replaceAll('{n}', '${_primary.tags.length}'),
            l10n.translate('customer_merge_field_tags')
                .replaceAll('{n}', '${_secondary!.tags.length}'),
          ),
        ],
      ),
    );
  }

  Widget _comparisonRow(String label, String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ),
          Expanded(child: Text(left, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
          Expanded(child: Text(right, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildConsequences(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('customer_merge_consequences_title'),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 13),
          ),
          const SizedBox(height: 6),
          _bullet(l10n.translate('customer_merge_consequence_data')),
          _bullet(l10n.translate('customer_merge_consequence_keep_identity')),
          _bullet(l10n.translate('customer_merge_consequence_irreversible')),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 13)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildActions(AppLocalizations l10n) {
    return Observer(
      builder: (_) {
        final canMerge = _secondary != null && !widget.store.isSaving;
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: widget.store.isSaving ? null : widget.onBack,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(l10n.translate('common_cancel')),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: canMerge ? _onConfirmTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: widget.store.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      l10n.translate('customer_merge_btn'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _CustomerSummaryCard extends StatelessWidget {
  final Customer customer;
  final String badgeText;
  final Color badgeColor;
  final int contactCount;
  final int tagCount;
  final String initials;
  final AppLocalizations l10n;

  const _CustomerSummaryCard({
    required this.customer,
    required this.badgeText,
    required this.badgeColor,
    required this.contactCount,
    required this.tagCount,
    required this.initials,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: badgeColor.withValues(alpha: 0.15),
            backgroundImage: (customer.avatarUrl != null && customer.avatarUrl!.isNotEmpty)
                ? NetworkImage(customer.avatarUrl!)
                : null,
            child: (customer.avatarUrl == null || customer.avatarUrl!.isEmpty)
                ? Text(initials,
                    style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 14))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        customer.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.translate('customer_merge_field_contacts').replaceAll('{n}', '$contactCount')} • '
                  '${l10n.translate('customer_merge_field_tags').replaceAll('{n}', '$tagCount')}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                if (customer.emails.isNotEmpty || customer.phones.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (customer.emails.isNotEmpty) customer.emails.first,
                      if (customer.phones.isNotEmpty) customer.phones.first,
                    ].join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
