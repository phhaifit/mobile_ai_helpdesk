import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import '../store/ticket_column_visibility_store.dart';
import 'ticket_table_columns.dart';

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
        columnWidths: TicketTableColumns.buildTableWidths(visibleColumns),
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
