import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/constants/dimens.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimens.horizontalPadding,
        vertical: Dimens.verticalPadding,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: ID and Status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ticket.id,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  StatusBadgeWidget(status: ticket.status),
                ],
              ),
              const SizedBox(height: 8.0),

              // Title
              Text(
                ticket.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),

              // Customer and Priority row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer:',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          ticket.customerName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PriorityBadgeWidget(priority: ticket.priority),
                ],
              ),
              const SizedBox(height: 8.0),

              // Agent assignment
              if (ticket.assignedAgentId != null)
                Text(
                  'Assigned to: ${ticket.assignedAgentName ?? "Unknown"}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
              else
                Text(
                  'Unassigned',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.errorRed,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: 8.0),

              // Footer: Created date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created: ${ticket.createdAt.toString().split('.')[0]}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onDelete,
                      color: AppColors.errorRed,
                      iconSize: 18,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
