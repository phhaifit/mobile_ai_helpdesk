import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import '../store/ticket_column_visibility_store.dart';
import 'status_priority_badge_widget.dart';
import 'ticket_table_columns.dart';
import 'ticket_source_widget.dart';

class TicketTableRowWidget extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onAcceptPressed;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onDetailPressed;
  final int selectedTabIndex;
  final String currentAgentId;
  final List<TicketColumn> visibleColumns;

  const TicketTableRowWidget({
    super.key,
    required this.ticket,
    this.onAcceptPressed,
    this.onCancelPressed,
    this.onDetailPressed,
    this.selectedTabIndex = 1,
    required this.currentAgentId,
    this.visibleColumns = const [
      TicketColumn.title,
      TicketColumn.statusPriority,
      TicketColumn.customer,
      TicketColumn.source,
      TicketColumn.createdDate,
      TicketColumn.actions,
    ],
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Table(
        columnWidths: TicketTableColumns.buildTableWidths(visibleColumns),
        children: [
          TableRow(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.dividerColor,
                  width: 1,
                ),
              ),
            ),
            children: _buildRowCells(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRowCells(BuildContext context) {
    final cells = <Widget>[];

    for (final column in visibleColumns) {
      cells.add(_buildCell(column, context));
    }

    return cells;
  }

  Widget _buildPrimaryActionButton(BuildContext context) {
    final l = AppLocalizations.of(context);

    return ElevatedButton(
      onPressed: onAcceptPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      ),
      child: Text(
        "Tiếp nhận",
        style: const TextStyle(fontSize: 9),
      ),
    );
  }

  Widget _buildCancelActionButton(BuildContext context) {
    final l = AppLocalizations.of(context);
    return OutlinedButton(
      onPressed: onCancelPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.warningOrange,
        side: const BorderSide(
          color: AppColors.warningOrange,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      ),
      child: Text(
        "Hủy",
        style: const TextStyle(fontSize: 9),
      ),
    );
  }

  Widget _buildDetailButton(BuildContext context) {
    final l = AppLocalizations.of(context);
    return OutlinedButton(
      onPressed: onDetailPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(
          color: AppColors.primaryBlue,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
      ),
      child: Text(
        "Chi tiết",
        style: const TextStyle(fontSize: 9),
      ),
    );
  }

  Widget _buildCell(TicketColumn column, BuildContext context) {
    switch (column) {
      case TicketColumn.title:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Text(
            ticket.title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case TicketColumn.statusPriority:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: StatusPriorityBadgeWidget(
            status: ticket.status,
            priority: ticket.priority,
          ),
        );
      case TicketColumn.customer:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Text(
            ticket.customerName,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case TicketColumn.source:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: TicketSourceWidget(source: ticket.source),
        );
      case TicketColumn.createdBy:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Text(
            ticket.createdByName,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case TicketColumn.csAgent:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Text(
            ticket.assignedAgentName ?? 'Chưa có',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case TicketColumn.createdDate:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Text(
            _formatDate(ticket.createdAt),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        );
      case TicketColumn.updatedDate:
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          child: Text(
            _formatDate(ticket.updatedAt),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        );
      case TicketColumn.actions:
        final showAcceptAction = selectedTabIndex == 1 ||
            (selectedTabIndex == 2 && ticket.assignedAgentId == null);
        final showCancelAction = selectedTabIndex == 0 ||
            (selectedTabIndex == 2 &&
                ticket.assignedAgentId == currentAgentId);
        final showPrimaryAction = showAcceptAction || showCancelAction;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showPrimaryAction)
                showAcceptAction
                    ? _buildPrimaryActionButton(context)
                    : _buildCancelActionButton(context),
              if (showPrimaryAction) const SizedBox(width: 6),
              _buildDetailButton(context),
            ],
          ),
        );
    }
  }
}
