import 'package:flutter/material.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

class StatusPriorityBadgeWidget extends StatelessWidget {
  final TicketStatus status;
  final TicketPriority priority;

  const StatusPriorityBadgeWidget({
    super.key,
    required this.status,
    required this.priority,
  });

  Color _getStatusBadgeColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return const Color(0xFFEF5350); // Đỏ
      case TicketStatus.inProgress:
        return const Color(0xFFFFA726); // Cam
      case TicketStatus.resolved:
        return const Color(0xFF66BB6A); // Xanh lá
      case TicketStatus.closed:
        return const Color(0xFF757575); // Xám
      case TicketStatus.pending:
        return const Color(0xFFFFA726); // Cam
      case TicketStatus.processingByAI:
        return const Color(0xFF2196F3); // Xanh dương
    }
  }

  String _getStatusDisplayText(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Chưa tiếp nhận';
      case TicketStatus.inProgress:
        return 'Đang xử lý';
      case TicketStatus.resolved:
        return 'Đã giải quyết';
      case TicketStatus.closed:
        return 'Đã đóng';
      case TicketStatus.pending:
        return 'Đang chờ';
      case TicketStatus.processingByAI:
        return 'Đang xử lý bởi AI';
    }
  }

  Color _getPriorityBadgeColor(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return const Color(0xFF42A5F5); // Xanh
      case TicketPriority.medium:
        return const Color(0xFFFDD835); // Vàng
      case TicketPriority.high:
        return const Color(0xFFFFA726); // Cam
      case TicketPriority.urgent:
        return const Color(0xFFEF5350); // Đỏ
    }
  }

  String _getPriorityDisplayText(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return 'Thấp';
      case TicketPriority.medium:
        return 'Trung bình';
      case TicketPriority.high:
        return 'Cao';
      case TicketPriority.urgent:
        return 'Khẩn cấp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: _getStatusBadgeColor(status),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            _getStatusDisplayText(status),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Priority badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: _getPriorityBadgeColor(priority),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            _getPriorityDisplayText(priority),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
