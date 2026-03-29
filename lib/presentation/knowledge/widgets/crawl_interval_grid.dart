import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter/material.dart';

class CrawlIntervalGrid extends StatelessWidget {
  final CrawlInterval selected;
  final ValueChanged<CrawlInterval> onSelected;

  const CrawlIntervalGrid({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _options = [
    (CrawlInterval.manual, '1 lần', 'Chạy 1 lần duy nhất và không lặp lại'),
    (CrawlInterval.daily, 'Hàng ngày', 'Chạy ngay bây giờ và lặp lại sau 1 ngày'),
    (CrawlInterval.weekly, 'Hàng tuần', 'Chạy ngay bây giờ và lặp lại sau 7 ngày'),
    (CrawlInterval.monthly, 'Hàng tháng', 'Chạy ngay bây giờ và lặp lại sau 30 ngày'),
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
        final (interval, title, subtitle) = option;
        final isSelected = selected == interval;
        return GestureDetector(
          onTap: () => onSelected(interval),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? const Color(0xFF1A73E8) : Colors.grey[200]!,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? const Color(0xFF1A73E8).withOpacity(0.05)
                  : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
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
                  subtitle,
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
