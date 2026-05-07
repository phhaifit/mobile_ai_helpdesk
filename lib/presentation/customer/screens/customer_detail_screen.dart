import 'package:flutter/material.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:intl/intl.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  final CustomerStore store;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onMerge;

  const CustomerDetailScreen({
    super.key,
    required this.customer,
    required this.store,
    required this.onBack,
    required this.onEdit,
    required this.onMerge,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Customer _customer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    final updated = await widget.store.loadCustomerById(_customer.id);
    if (updated != null && mounted) {
      setState(() {
        _customer = updated;
      });
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onDelete(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.translate('customer_detail_delete_title')),
        content: Text(localizations.translate('customer_detail_delete_confirm')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: Text(localizations.translate('common_cancel'), style: const TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(localizations.translate('customer_detail_delete_btn'), style: const TextStyle(color: Colors.white))
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await widget.store.deleteCustomer(_customer.id);
      if (success) {
        widget.onBack();
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'C';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(height: 24, color: Colors.grey.shade300),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? AppLocalizations.of(context).translate('customer_detail_not_updated') : value, 
                  style: TextStyle(
                    fontSize: 14, 
                    color: value.isEmpty ? Colors.grey : Colors.black87, 
                    fontWeight: value.isEmpty ? null : FontWeight.w500
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
        title: Text(AppLocalizations.of(context).translate('customer_detail_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primaryBlue), onPressed: widget.onEdit),
          IconButton(icon: const Icon(Icons.merge_type, color: Colors.orange), onPressed: widget.onMerge),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _onDelete(context)),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                     CircleAvatar(
                       radius: 40,
                       backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                       backgroundImage: _customer.avatarUrl != null && _customer.avatarUrl!.isNotEmpty 
                         ? NetworkImage(_customer.avatarUrl!) 
                         : null,
                       child: (_customer.avatarUrl == null || _customer.avatarUrl!.isEmpty)
                         ? Text(
                             _getInitials(_customer.fullName),
                             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                           )
                         : null,
                     ),
                    const SizedBox(height: 16),
                    Text(_customer.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    if (_customer.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _customer.tags.map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            t.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                          ),
                        )).toList(),
                      ),
                    ],
                    if (_customer.groups.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context).translate('customer_detail_groups'), 
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _customer.groups.map((g) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            border: Border.all(color: Colors.green.shade200),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            g,
                            style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                          ),
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            _buildInfoCard(AppLocalizations.of(context).translate('customer_detail_contact_info'), [
              if (_customer.phones.isEmpty) _buildInfoRow(Icons.phone_outlined, AppLocalizations.of(context).translate('customer_detail_phone'), ''),
              for (var p in _customer.phones) _buildInfoRow(Icons.phone_outlined, AppLocalizations.of(context).translate('customer_detail_phone'), p),
              if (_customer.emails.isEmpty) _buildInfoRow(Icons.email_outlined, AppLocalizations.of(context).translate('customer_detail_email'), ''),
              for (var e in _customer.emails) _buildInfoRow(Icons.email_outlined, AppLocalizations.of(context).translate('customer_detail_email'), e),
            ]),

            _buildInfoCard(AppLocalizations.of(context).translate('customer_detail_social'), [
              if (_customer.zalos.isEmpty) _buildInfoRow(Icons.chat_bubble_outline, AppLocalizations.of(context).translate('customer_detail_zalo'), '', iconColor: Colors.blue),
              for (var z in _customer.zalos) _buildInfoRow(Icons.chat_bubble_outline, AppLocalizations.of(context).translate('customer_detail_zalo'), z, iconColor: Colors.blue),
              if (_customer.messengers.isEmpty) _buildInfoRow(Icons.message_outlined, AppLocalizations.of(context).translate('customer_detail_messenger'), '', iconColor: Colors.blueAccent),
              for (var m in _customer.messengers) _buildInfoRow(Icons.message_outlined, AppLocalizations.of(context).translate('customer_detail_messenger'), m, iconColor: Colors.blueAccent),
            ]),

            _buildInfoCard(AppLocalizations.of(context).translate('customer_detail_activity'), [
              if (_customer.tenantName != null) 
                _buildInfoRow(Icons.business_outlined, AppLocalizations.of(context).translate('customer_detail_tenant'), _customer.tenantName!),
              _buildInfoRow(Icons.confirmation_num_outlined, AppLocalizations.of(context).translate('customer_detail_tickets'), '${_customer.totalTickets}'),
              _buildInfoRow(Icons.access_time, AppLocalizations.of(context).translate('customer_detail_created_at'), dateFormat.format(_customer.createdAt)),
              if (_customer.lastContactedAt != null)
                _buildInfoRow(Icons.update, AppLocalizations.of(context).translate('customer_detail_last_contact'), dateFormat.format(_customer.lastContactedAt!)),
            ]),
          ],
        ),
      ),
    );
  }
}
