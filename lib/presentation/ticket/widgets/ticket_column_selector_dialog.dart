import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import '../store/ticket_column_visibility_store.dart';

class TicketColumnSelectorDialog extends StatelessWidget {
  final TicketColumnVisibilityStore store;

  const TicketColumnSelectorDialog({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Chọn cột hiển thị',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Observer(
        builder: (_) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text(
                  'Tiêu đề',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showTitle,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.title, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  'Trạng thái & Độ ưu tiên',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showStatusPriority,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.statusPriority, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  'Khách hàng',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showCustomer,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.customer, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  'Nguồn tiếp nhận',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showSource,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.source, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  'Người tạo',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showCreatedBy,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.createdBy, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  'Người hỗ trợ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showCSAgent,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.csAgent, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  'Ngày tạo',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showCreatedDate,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.createdDate, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  'Ngày cập nhật gần nhất',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                value: store.showUpdatedDate,
                onChanged: (value) {
                  if (value != null) {
                    store.setColumnVisibility(TicketColumn.updatedDate, value);
                  }
                },
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Đóng',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
