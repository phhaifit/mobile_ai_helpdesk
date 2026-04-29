import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/status_badge_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/priority_badge_widget.dart';

class TicketCardWidget extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TicketCardWidget({
    super.key,
    required this.ticket,
    this.onTap,
    this.onDelete,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.dividerColor, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: ID + badges
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${ticket.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadgeWidget(status: ticket.status),
                  const SizedBox(width: 6),
                  PriorityBadgeWidget(priority: ticket.priority),
                ],
              ),
              const SizedBox(height: 6),
              // Row 2: Title
              Text(
                ticket.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Row 3: Customer + date
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ticket.customerName,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(ticket.createdAt),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              // Row 4: Agent (if assigned)
              if (ticket.assignedAgentId != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.support_agent, size: 13, color: AppColors.primaryBlue),
                    const SizedBox(width: 4),
                    Text(
                      ticket.assignedAgentName ?? 'Agent',
                      style: const TextStyle(fontSize: 12, color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ],
              // Tap hint
              if (onTap != null) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryBlue.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 14, color: AppColors.primaryBlue.withValues(alpha: 0.8)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
