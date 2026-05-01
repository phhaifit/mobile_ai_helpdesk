import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/source_status_badge.dart';
import 'package:flutter/material.dart';

/// Card representing a single knowledge source.
///
/// Renders type icon + name + status badge, sub-line with last-sync time and
/// configured interval, an optional progress bar when [isBusy] or status is
/// in flight, an error message when the source has failed, and three actions
/// (interval, reindex, delete).
class SourceListCard extends StatelessWidget {
  final KnowledgeSource source;
  final bool isBusy;
  final VoidCallback onConfigureInterval;
  final VoidCallback onReindex;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const SourceListCard({
    required this.source,
    required this.isBusy,
    required this.onConfigureInterval,
    required this.onReindex,
    required this.onDelete,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final showProgress = source.status.isInFlight;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TypeIcon(type: source.type),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      source.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SourceStatusBadge(status: source.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 13, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(source.updatedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.repeat, size: 13, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _intervalLabel(source.interval),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (showProgress) ...[
                const SizedBox(height: 10),
                _ProgressBar(progress: source.progress),
              ],
              if (source.status == KnowledgeSourceStatus.failed &&
                  source.errorMessage != null) ...[
                const SizedBox(height: 10),
                _ErrorMessage(message: source.errorMessage!),
              ],
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionButton(
                    icon: Icons.schedule,
                    label: 'Tần suất',
                    color: Colors.grey[700]!,
                    onPressed: isBusy ? null : onConfigureInterval,
                  ),
                  _ActionButton(
                    icon: Icons.sync,
                    label: 'Reindex',
                    color: const Color(0xFF1A73E8),
                    busy: isBusy,
                    onPressed: isBusy ? null : onReindex,
                  ),
                  _ActionButton(
                    icon: Icons.delete_outline,
                    label: 'Xóa',
                    color: const Color(0xFFDC2626),
                    onPressed: isBusy ? null : onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')} '
        '${dt.day}/${dt.month}/${dt.year}';
  }

  String _intervalLabel(CrawlInterval interval) {
    switch (interval) {
      case CrawlInterval.once:
        return 'Thủ công';
      case CrawlInterval.daily:
        return 'Mỗi ngày';
      case CrawlInterval.weekly:
        return 'Mỗi tuần';
      case CrawlInterval.monthly:
        return 'Mỗi tháng';
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final double? progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Đang xử lý',
              style: TextStyle(fontSize: 12, color: Color(0xFF1A73E8)),
            ),
            const Spacer(),
            if (progress != null)
              Text(
                '${(progress! * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1A73E8),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress, // null → indeterminate animation
            minHeight: 4,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Color(0xFF1A73E8)),
          ),
        ),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;
  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline,
              size: 14, color: Color(0xFFDC2626)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool busy;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: busy
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            )
          : Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 32),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final KnowledgeSourceType type;
  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(_icon, size: 20, color: _color),
    );
  }

  Color get _color {
    switch (type) {
      case KnowledgeSourceType.web:
      case KnowledgeSourceType.wholeSite:
        return const Color(0xFF1A73E8);
      case KnowledgeSourceType.localFile:
        return const Color(0xFFEA8600);
      case KnowledgeSourceType.googleDrive:
        return const Color(0xFF0F9D58);
      case KnowledgeSourceType.databaseQuery:
        return const Color(0xFF7C3AED);
    }
  }

  IconData get _icon {
    switch (type) {
      case KnowledgeSourceType.web:
        return Icons.link;
      case KnowledgeSourceType.wholeSite:
        return Icons.language;
      case KnowledgeSourceType.localFile:
        return Icons.insert_drive_file;
      case KnowledgeSourceType.googleDrive:
        return Icons.cloud;
      case KnowledgeSourceType.databaseQuery:
        return Icons.storage;
    }
  }
}
