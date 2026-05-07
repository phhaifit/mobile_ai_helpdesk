import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter/material.dart';

/// Compact 2x2 picker for [CrawlInterval], used inside add-source forms.
class CrawlIntervalGrid extends StatelessWidget {
  final CrawlInterval selected;
  final ValueChanged<CrawlInterval> onSelected;

  const CrawlIntervalGrid({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  static const _options = <_Option>[
    _Option(CrawlInterval.once, '1 lần', 'Chạy 1 lần và không lặp lại'),
    _Option(CrawlInterval.daily, 'Hàng ngày', 'Lặp lại sau mỗi ngày'),
    _Option(CrawlInterval.weekly, 'Hàng tuần', 'Lặp lại sau mỗi tuần'),
    _Option(CrawlInterval.monthly, 'Hàng tháng', 'Lặp lại sau mỗi tháng'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: _options.map((option) {
        final isSelected = selected == option.interval;
        return GestureDetector(
          onTap: () => onSelected(option.interval),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1A73E8)
                    : Colors.grey[200]!,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? const Color(0xFF1A73E8).withValues(alpha: 0.05)
                  : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  option.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isSelected
                        ? const Color(0xFF1A73E8)
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  option.subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Option {
  final CrawlInterval interval;
  final String title;
  final String subtitle;
  const _Option(this.interval, this.title, this.subtitle);
}
