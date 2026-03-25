import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';

class DeleteTicketDialog extends StatelessWidget {
  final String ticketTitle;

  const DeleteTicketDialog({super.key, required this.ticketTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 28),
          SizedBox(width: 12),
          Text('Xóa phiếu hỗ trợ?'),
        ],
      ),
      content: Text(
        'Bạn có chắc chắn muốn xóa phiếu "$ticketTitle"? Hành động này không thể hoàn tác.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed,
            foregroundColor: Colors.white,
          ),
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
