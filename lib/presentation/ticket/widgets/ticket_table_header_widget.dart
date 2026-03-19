import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import '../store/ticket_column_visibility_store.dart';

class TicketTableHeaderWidget extends StatelessWidget {
  final List<TicketColumn> visibleColumns;
  final VoidCallback? onFilterPressed;

  const TicketTableHeaderWidget({
    super.key,
    this.visibleColumns = const [
      TicketColumn.title,
      TicketColumn.statusPriority,
      TicketColumn.customer,
      TicketColumn.source,
      TicketColumn.createdDate,
      TicketColumn.actions,
    ],
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Table(
        columnWidths: _getColumnWidths(),
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: AppColors.bubbleGrey,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.dividerColor,
                  width: 1,
                ),
              ),
            ),
            children: _buildHeaderCells(),
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

    // Remove columns that are not visible
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

  List<Widget> _buildHeaderCells() {
    final columnLabels = {
      TicketColumn.title: 'Tiêu đề',
      TicketColumn.statusPriority: 'Trạng thái & Độ ưu tiên',
      TicketColumn.customer: 'Khách hàng',
      TicketColumn.source: 'Nguồn tiếp nhận',
      TicketColumn.csAgent: 'Người hỗ trợ',
      TicketColumn.createdBy: 'Người tạo',
      TicketColumn.createdDate: 'Ngày tạo',
      TicketColumn.updatedDate: 'Ngày cập nhật gần nhất',
      TicketColumn.actions: '',
    };

    final cells = visibleColumns
        .map((column) => column == TicketColumn.actions
            ? _buildActionHeaderCell()
            : _buildHeaderCell(columnLabels[column] ?? ''))
        .toList();

    return cells;
  }

  Widget _buildActionHeaderCell() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SizedBox.shrink()),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onFilterPressed,
              icon: const Icon(Icons.tune, size: 18),
              tooltip: 'Chọn cột hiển thị',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 20.0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
