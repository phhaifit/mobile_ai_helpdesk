import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/source_status_badge.dart';
import 'package:flutter/material.dart';

class SourceListCard extends StatelessWidget {
  final KnowledgeSource source;
  final VoidCallback onConfigureInterval;
  final VoidCallback onReindex;
  final VoidCallback onDelete;

  const SourceListCard({
    required this.source,
    required this.onConfigureInterval,
    required this.onReindex,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
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
                Icon(Icons.access_time, size: 13, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(source.lastSyncAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.repeat, size: 13, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _intervalLabel(source.crawlInterval),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onConfigureInterval,
                  icon: const Icon(Icons.schedule, size: 16),
                  label: const Text(
                    'Cấu hình tần suất',
                    style: TextStyle(fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: onReindex,
                  icon: const Icon(Icons.sync, size: 16),
                  label: const Text('Reindex', style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1A73E8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                  ),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Xóa', style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                  ),
                ),
              ],
            ),
          ],
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
      case CrawlInterval.manual:
        return 'Thủ công';
      case CrawlInterval.hourly:
        return 'Mỗi giờ';
      case CrawlInterval.daily:
        return 'Mỗi ngày';
      case CrawlInterval.monthly:
        return 'Hàng tháng';
      case CrawlInterval.weekly:
        return 'Mỗi tuần';
    }
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
        color: _color.withAlpha(31),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(_icon, size: 20, color: _color),
    );
  }

  Color get _color {
    switch (type) {
      case KnowledgeSourceType.webSingle:
      case KnowledgeSourceType.webFull:
        return const Color(0xFF1A73E8);
      case KnowledgeSourceType.localFile:
        return const Color(0xFFEA8600);
      case KnowledgeSourceType.googleDrive:
        return const Color(0xFF0F9D58);
      case KnowledgeSourceType.postgresql:
      case KnowledgeSourceType.sqlServer:
        return const Color(0xFF7C3AED);
    }
  }

  IconData get _icon {
    switch (type) {
      case KnowledgeSourceType.webSingle:
        return Icons.link;
      case KnowledgeSourceType.webFull:
        return Icons.language;
      case KnowledgeSourceType.localFile:
        return Icons.insert_drive_file;
      case KnowledgeSourceType.googleDrive:
        return Icons.cloud;
      case KnowledgeSourceType.postgresql:
        return Icons.storage;
      case KnowledgeSourceType.sqlServer:
        return Icons.dns;
    }
  }
}
