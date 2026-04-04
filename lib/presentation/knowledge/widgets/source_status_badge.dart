import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter/material.dart';

class SourceStatusBadge extends StatelessWidget {
  final KnowledgeSourceStatus status;

  const SourceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _backgroundColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == KnowledgeSourceStatus.indexing)
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(_backgroundColor),
              ),
            )
          else
            Icon(_icon, size: 12, color: _backgroundColor),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _backgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case KnowledgeSourceStatus.active:
        return const Color(0xFF16A34A);
      case KnowledgeSourceStatus.indexing:
        return const Color(0xFF7C3AED);
      case KnowledgeSourceStatus.error:
        return const Color(0xFFDC2626);
    }
  }

  IconData get _icon {
    switch (status) {
      case KnowledgeSourceStatus.active:
        return Icons.check_circle_outline;
      case KnowledgeSourceStatus.indexing:
        return Icons.sync;
      case KnowledgeSourceStatus.error:
        return Icons.error_outline;
    }
  }

  String get _label {
    switch (status) {
      case KnowledgeSourceStatus.active:
        return 'Hoạt động';
      case KnowledgeSourceStatus.indexing:
        return 'Đang đồng bộ';
      case KnowledgeSourceStatus.error:
        return 'Lỗi';
    }
  }
}
