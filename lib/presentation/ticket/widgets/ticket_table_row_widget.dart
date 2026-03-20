import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import '../store/ticket_column_visibility_store.dart';
import 'status_priority_badge_widget.dart';
import 'ticket_source_widget.dart';

class TicketTableRowWidget extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onAcceptPressed;
  final VoidCallback? onDetailPressed;
  final int selectedTabIndex;
  final List<TicketColumn> visibleColumns;

  const TicketTableRowWidget({
    super.key,
    required this.ticket,
    this.onAcceptPressed,
    this.onDetailPressed,
    this.selectedTabIndex = 1,
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
        columnWidths: _getColumnWidths(),
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
            children: _buildRowCells(),
          ),
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths() {
    final widths = {
      0: const FlexColumnWidth(2),    // title
      1: const FlexColumnWidth(1.5),  // statusPriority
      2: const FlexColumnWidth(1.5),  // customer
      3: const FlexColumnWidth(1),    // source
      4: const FlexColumnWidth(1),    // createdBy
      5: const FlexColumnWidth(1),    // csAgent
      6: const FlexColumnWidth(1),    // createdDate
      7: const FlexColumnWidth(1),    // updatedDate
      8: const FlexColumnWidth(1.2),  // actions
    };

    final filteredWidths = <int, TableColumnWidth>{};
    int columnIndex = 0;
    final columnOrder = [
      TicketColumn.title,
      TicketColumn.statusPriority,
      TicketColumn.customer,
      TicketColumn.source,
      TicketColumn.createdBy,
      TicketColumn.csAgent,
      TicketColumn.createdDate,
      TicketColumn.updatedDate,
      TicketColumn.actions,
    ];

    for (int i = 0; i < columnOrder.length; i++) {
      if (visibleColumns.contains(columnOrder[i])) {
        filteredWidths[columnIndex] = widths[i]!;
        columnIndex++;
      }
    }

    return filteredWidths;
  }

  List<Widget> _buildRowCells() {
    final cells = <Widget>[];

    for (final column in visibleColumns) {
      cells.add(_buildCell(column));
    }

    return cells;
  }

  Widget _buildCell(TicketColumn column) {
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
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: selectedTabIndex == 0
              ? const SizedBox.shrink()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: onAcceptPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                      child: const Text(
                        'Tiếp nhận',
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton(
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
                      child: const Text(
                        'Chi tiết',
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
        );
    }
  }
}
