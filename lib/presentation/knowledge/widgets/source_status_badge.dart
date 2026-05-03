import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter/material.dart';

/// Compact pill displaying the live status of a knowledge source.
/// Maps the four backend statuses to colour + label + icon, plus an
/// inline spinner when the source is in flight.
class SourceStatusBadge extends StatelessWidget {
  final KnowledgeSourceStatus status;

  const SourceStatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = _StatusTheme.of(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.foreground.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.foreground, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status.isInFlight)
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(theme.foreground),
              ),
            )
          else
            Icon(theme.icon, size: 12, color: theme.foreground),
          const SizedBox(width: 4),
          Text(
            theme.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTheme {
  final Color foreground;
  final IconData icon;
  final String label;

  const _StatusTheme(this.foreground, this.icon, this.label);

  factory _StatusTheme.of(KnowledgeSourceStatus s) {
    switch (s) {
      case KnowledgeSourceStatus.completed:
        return const _StatusTheme(
          Color(0xFF16A34A),
          Icons.check_circle_outline,
          'Hoạt động',
        );
      case KnowledgeSourceStatus.processing:
        return const _StatusTheme(
          Color(0xFF1A73E8),
          Icons.sync,
          'Đang đồng bộ',
        );
      case KnowledgeSourceStatus.pending:
        return const _StatusTheme(
          Color(0xFF7C3AED),
          Icons.pending_outlined,
          'Đang chờ',
        );
      case KnowledgeSourceStatus.failed:
        return const _StatusTheme(
          Color(0xFFDC2626),
          Icons.error_outline,
          'Lỗi',
        );
    }
  }
}
