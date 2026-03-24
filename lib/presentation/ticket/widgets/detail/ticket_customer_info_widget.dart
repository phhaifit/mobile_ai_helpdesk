import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

class TicketCustomerInfoWidget extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onViewHistory;

  const TicketCustomerInfoWidget({
    super.key,
    required this.ticket,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Thông tin khách hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onViewHistory,
                  icon: const Icon(Icons.history, size: 18),
                  label: const Text('Xem lịch sử'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person, ticket.customerName),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, ticket.customerEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Text(
          value.isNotEmpty ? value : '-',
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
