import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

/// Bottom bar shown while searching messages in a chat room.
class ChatSearchNavigationBar extends StatelessWidget {
  const ChatSearchNavigationBar({
    required this.currentIndex,
    required this.resultCount,
    required this.onGoUp,
    required this.onGoDown,
    required this.onClose,
    super.key,
  });

  /// Zero-based index of the highlighted result, or `-1` when none selected.
  final int currentIndex;
  final int resultCount;

  /// Older match — visually up in the reversed message list.
  final VoidCallback? onGoUp;

  /// Newer match — visually down in the reversed message list.
  final VoidCallback? onGoDown;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final bool hasResults = resultCount > 0;
    final String positionLabel = hasResults && currentIndex >= 0
        ? '${currentIndex + 1}/$resultCount'
        : '0/$resultCount';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Tin nhắn mới hơn',
              onPressed: hasResults ? onGoDown : null,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              color: AppColors.messengerBlue,
            ),
            Expanded(
              child: Text(
                hasResults ? positionLabel : 'Không có kết quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: hasResults
                      ? AppColors.messengerBlue
                      : Colors.grey.shade600,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Tin nhắn cũ hơn',
              onPressed: hasResults ? onGoUp : null,
              icon: const Icon(Icons.keyboard_arrow_up_rounded),
              color: AppColors.messengerBlue,
            ),
            IconButton(
              tooltip: 'Đóng tìm kiếm',
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
