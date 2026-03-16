import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';

class TicketTableHeaderWidget extends StatelessWidget {
  const TicketTableHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1.2),
        },
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
            children: [
              _buildHeaderCell('Tiêu đề'),
              _buildHeaderCell('Trạng thái & Độ ưu tiên'),
              _buildHeaderCell('Khách hàng'),
              _buildHeaderCell('Nguồn tiếp nhận'),
              _buildHeaderCell('Ngày tạo'),
              _buildHeaderCell(''),
            ],
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
