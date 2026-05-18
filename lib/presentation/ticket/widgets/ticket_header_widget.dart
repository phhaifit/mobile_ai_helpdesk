import 'package:ai_helpdesk/constants/colors.dart';
import 'package:flutter/material.dart';

class TicketHeaderWidget extends StatelessWidget {
  final String tabTitle;
  final int ticketCount;
  final VoidCallback? onExportPressed;
  final VoidCallback? onAddTicketPressed;

  const TicketHeaderWidget({
    required this.tabTitle, required this.ticketCount, super.key,
    this.onExportPressed,
    this.onAddTicketPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Title and count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tabTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng số phiếu: $ticketCount phiếu',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Right side: Action buttons.
          // Note: the global button theme (app_theme.dart) sets
          // `minimumSize: Size.fromHeight(N)` which Flutter resolves to
          // `Size(double.infinity, N)`. That works for full-width form
          // buttons but crashes any button placed inside a Row (infinite
          // width). We override `minimumSize` per-button here so the
          // buttons size to their content.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: onExportPressed,
                icon: const Icon(Icons.cloud_download_outlined),
                label: const Text('Xuất excel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  minimumSize: const Size(64, 40),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onAddTicketPressed,
                icon: const Icon(Icons.add),
                label: const Text('Thêm phiếu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(64, 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
