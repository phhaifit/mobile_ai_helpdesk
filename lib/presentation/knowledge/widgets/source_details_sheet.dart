import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/source_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Read-only details bottom sheet for a [KnowledgeSource].
///
/// Surfaces fields the list card cannot fit: full URL / file path / SQL
/// query, source ID (for support), created/updated timestamps, error message,
/// and a copy-to-clipboard affordance for the `path`-style identifier so users
/// can paste it elsewhere instead of squinting at a truncated card line.
///
/// The sheet is intentionally inert — it does not mutate the store; per-source
/// actions (reindex / delete / interval) stay on the card so the sheet
/// remains a quick reference panel that does not duplicate destructive ops.
class SourceDetailsSheet extends StatelessWidget {
  final KnowledgeSource source;

  const SourceDetailsSheet({required this.source, super.key});

  static const _accent = Color(0xFF1A73E8);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    source.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                SourceStatusBadge(status: source.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _typeLabel(source.type),
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _pathBlock(context),
            const SizedBox(height: 12),
            _metaRow(Icons.schedule, 'Tần suất', _intervalLabel(source.interval)),
            _metaRow(Icons.access_time, 'Cập nhật', _formatDateTime(source.updatedAt)),
            _metaRow(Icons.calendar_today, 'Tạo lúc', _formatDateTime(source.createdAt)),
            _metaRow(Icons.tag, 'ID', source.id, copyable: true, context: context),
            if (source.status == KnowledgeSourceStatus.failed &&
                source.errorMessage != null) ...[
              const SizedBox(height: 12),
              _errorBlock(source.errorMessage!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _pathBlock(BuildContext context) {
    final raw = source.name == _pathDisplay() ? null : _pathDisplay();
    if (raw == null || raw.isEmpty) return const SizedBox.shrink();

    final isUrl = raw.startsWith('http://') || raw.startsWith('https://');
    final isQuery = raw.trimLeft().toUpperCase().startsWith('SELECT');
    final label = isUrl ? 'URL' : (isQuery ? 'Truy vấn' : 'Đường dẫn');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  raw,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Sao chép',
            icon: const Icon(Icons.copy, size: 18, color: _accent),
            onPressed: () => _copy(context, raw, label: label),
          ),
        ],
      ),
    );
  }

  /// Best-effort full identifier for this source, depending on its type.
  ///
  /// Falls back to the display name when nothing better is in `config`
  /// (the BE list response only carries `name` + `path`, with the latter
  /// already collapsed into `name` for file sources via
  /// `_extractDisplayName` — so for file rows the path block is hidden).
  String _pathDisplay() {
    final cfg = source.config;
    final candidate = cfg['url'] ??
        cfg['webUrl'] ??
        cfg['path'] ??
        cfg['query'] ??
        cfg['fileName'];
    if (candidate is String && candidate.isNotEmpty) return candidate;
    return source.name;
  }

  Widget _metaRow(
    IconData icon,
    String label,
    String value, {
    bool copyable = false,
    BuildContext? context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.grey[500]),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (copyable && context != null)
            InkWell(
              onTap: () => _copy(context, value, label: label),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.copy, size: 14, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _errorBlock(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, size: 16, color: Color(0xFFDC2626)),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              message,
              style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copy(
    BuildContext context,
    String value, {
    required String label,
  }) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $label'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _typeLabel(KnowledgeSourceType t) {
    switch (t) {
      case KnowledgeSourceType.web:
        return 'Nguồn web';
      case KnowledgeSourceType.wholeSite:
        return 'Toàn bộ website';
      case KnowledgeSourceType.localFile:
        return 'Tệp tin';
      case KnowledgeSourceType.googleDrive:
        return 'Google Drive';
      case KnowledgeSourceType.databaseQuery:
        return 'Truy vấn CSDL';
    }
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

  String _formatDateTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')} '
        '${dt.day}/${dt.month}/${dt.year}';
  }
}
