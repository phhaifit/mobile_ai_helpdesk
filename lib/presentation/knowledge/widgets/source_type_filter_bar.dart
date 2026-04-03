import 'package:flutter/material.dart';

class SourceTypeFilterBar extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelected;

  const SourceTypeFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _filters = [
    (null, 'Tất cả', Icons.apps_outlined),
    ('file', 'Tệp tin', Icons.insert_drive_file_outlined),
    ('web', 'Web', Icons.language),
    ('drive', 'Google Drive', Icons.add_to_drive),
    ('db', 'Truy vấn CSDL', Icons.storage_outlined),
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
          final (category, label, icon) = _filters[index];
          final isSelected = selected == category;
          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1A73E8)
                    : Colors.grey[100],
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
                    icon,
                    size: 14,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? Colors.white : Colors.grey[700],
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
