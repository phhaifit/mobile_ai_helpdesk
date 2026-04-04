import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/status_badge_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/priority_badge_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_source_widget.dart';

class TicketDetailHeaderWidget extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailHeaderWidget({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket ID + Source
            Row(
              children: [
                Text(
                  ticket.id,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                TicketSourceWidget(source: ticket.source),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              ticket.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            // Badges row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusBadgeWidget(status: ticket.status),
                PriorityBadgeWidget(priority: ticket.priority),
                _buildCategoryChip(ticket.category),
              ],
            ),
            const SizedBox(height: 12),
            // Dates
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Tạo: ${_formatDate(ticket.createdAt)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.update, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Cập nhật: ${_formatDate(ticket.updatedAt)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(TicketCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category.displayName,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
