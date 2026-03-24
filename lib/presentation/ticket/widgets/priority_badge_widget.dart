import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/core/widgets/badge_widget.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

/// Badge widget for displaying ticket priority with appropriate color
class PriorityBadgeWidget extends StatelessWidget {
  final TicketPriority priority;
  final EdgeInsets padding;

  const PriorityBadgeWidget({
    required this.priority,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      label: priority.englishName,
      backgroundColor: AppColors.getPriorityColor(priority),
      textColor: Colors.white,
      padding: padding,
    );
  }
}
