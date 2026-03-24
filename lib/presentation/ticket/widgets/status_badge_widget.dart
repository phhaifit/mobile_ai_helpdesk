import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/core/widgets/badge_widget.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

/// Badge widget for displaying ticket status with appropriate color
class StatusBadgeWidget extends StatelessWidget {
  final TicketStatus status;
  final EdgeInsets padding;

  const StatusBadgeWidget({
    required this.status,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      label: status.displayName,
      backgroundColor: AppColors.getStatusColor(status),
      textColor: Colors.white,
      padding: padding,
    );
  }
}
