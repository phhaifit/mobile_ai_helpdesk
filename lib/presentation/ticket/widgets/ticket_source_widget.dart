import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

class TicketSourceWidget extends StatelessWidget {
  final TicketSource source;

  const TicketSourceWidget({
    super.key,
    required this.source,
  });

  IconData _getSourceIcon(TicketSource source) {
    switch (source) {
      case TicketSource.email:
        return Icons.email_outlined;
      case TicketSource.messenger:
        return Icons.chat_bubble_outline;
      case TicketSource.zalo:
        return Icons.message_outlined;
      case TicketSource.phone:
        return Icons.phone_outlined;
      case TicketSource.web:
        return Icons.language_outlined;
    }
  }

  String _getSourceText(TicketSource source) {
    switch (source) {
      case TicketSource.email:
        return 'Email';
      case TicketSource.messenger:
        return 'Messenger';
      case TicketSource.zalo:
        return 'Zalo';
      case TicketSource.phone:
        return 'Phone';
      case TicketSource.web:
        return 'Web';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getSourceIcon(source),
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          _getSourceText(source),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
