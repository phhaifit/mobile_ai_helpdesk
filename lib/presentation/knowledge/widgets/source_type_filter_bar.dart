import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter/material.dart';

/// Horizontal scroller of "All / Web / File / Drive / DB" pills.
/// Each pill maps to either `null` (all) or a [KnowledgeSourceType] used by
/// the store's `setTypeFilter`.
class SourceTypeFilterBar extends StatelessWidget {
  final KnowledgeSourceType? selected;
  final ValueChanged<KnowledgeSourceType?> onSelected;

  const SourceTypeFilterBar({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  static const _filters = <_Filter>[
    _Filter(null, 'Tất cả', Icons.apps_outlined),
    _Filter(KnowledgeSourceType.web, 'Web', Icons.link),
    _Filter(KnowledgeSourceType.wholeSite, 'Toàn site', Icons.language),
    _Filter(KnowledgeSourceType.localFile, 'Tệp tin',
        Icons.insert_drive_file_outlined),
    _Filter(KnowledgeSourceType.googleDrive, 'Drive', Icons.add_to_drive),
    _Filter(KnowledgeSourceType.databaseQuery, 'CSDL', Icons.storage_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final f = _filters[index];
          final isSelected = selected == f.type;
          return GestureDetector(
            onTap: () => onSelected(f.type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF1A73E8) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1A73E8)
                      : Colors.grey[200]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    f.icon,
                    size: 14,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    f.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Filter {
  final KnowledgeSourceType? type;
  final String label;
  final IconData icon;
  const _Filter(this.type, this.label, this.icon);
}
