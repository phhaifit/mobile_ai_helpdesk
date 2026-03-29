import 'package:flutter/material.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:intl/intl.dart';

class CustomerDetailScreen extends StatelessWidget {
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

  void _onDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa khách hàng'),
        content: const Text('Bạn có chắc chắn muốn xóa khách hàng này không? Mọi dữ liệu sẽ bị mất vĩnh viễn.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white))
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await store.deleteCustomer(customer.id);
      if (success) {
        onBack();
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
            const Divider(height: 24),
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
                Text(value.isEmpty ? 'Chưa cập nhật' : value, style: TextStyle(fontSize: 14, color: value.isEmpty ? Colors.grey : Colors.black87, fontWeight: value.isEmpty ? null : FontWeight.w500)),
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
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
        title: const Text('Hồ sơ khách hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primaryBlue), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.merge_type, color: Colors.orange), onPressed: onMerge),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _onDelete(context)),
        ],
      ),
      body: SingleChildScrollView(
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
                      child: Text(
                        _getInitials(customer.fullName),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(customer.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    if (customer.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: customer.tags.map((t) => Container(
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
                    ]
                  ],
                ),
              ),
            ),
            
            _buildInfoCard('Thông tin liên hệ', [
              if (customer.phones.isEmpty) _buildInfoRow(Icons.phone_outlined, 'Số điện thoại', ''),
              for (var p in customer.phones) _buildInfoRow(Icons.phone_outlined, 'Số điện thoại', p),
              if (customer.emails.isEmpty) _buildInfoRow(Icons.email_outlined, 'Email', ''),
              for (var e in customer.emails) _buildInfoRow(Icons.email_outlined, 'Email', e),
            ]),

            _buildInfoCard('Mạng xã hội', [
              if (customer.zalos.isEmpty) _buildInfoRow(Icons.chat_bubble_outline, 'Zalo', '', iconColor: Colors.blue),
              for (var z in customer.zalos) _buildInfoRow(Icons.chat_bubble_outline, 'Zalo', z, iconColor: Colors.blue),
              if (customer.messengers.isEmpty) _buildInfoRow(Icons.message_outlined, 'Messenger', '', iconColor: Colors.blueAccent),
              for (var m in customer.messengers) _buildInfoRow(Icons.message_outlined, 'Messenger', m, iconColor: Colors.blueAccent),
            ]),

            _buildInfoCard('Hoạt động', [
              _buildInfoRow(Icons.confirmation_num_outlined, 'Tổng số phiếu (Tickets)', '${customer.totalTickets}'),
              _buildInfoRow(Icons.access_time, 'Tạo lúc', dateFormat.format(customer.createdAt)),
              _buildInfoRow(Icons.update, 'Chăm sóc gần nhất', customer.lastContactedAt != null ? dateFormat.format(customer.lastContactedAt!) : ''),
            ]),
          ],
        ),
      ),
    );
  }
}
