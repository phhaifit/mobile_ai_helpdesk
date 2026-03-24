import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';

/// Empty state widget displayed when no items are available
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? icon;
  final EdgeInsets padding;

  const EmptyStateWidget({
    required this.title,
    required this.subtitle,
    this.icon,
    this.padding = const EdgeInsets.all(24.0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 24),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
