import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter/material.dart';

/// Full-screen detail picker for an existing source's sync interval.
/// Pops with the chosen [CrawlInterval] when the user taps "Lưu".
class CrawlIntervalConfigScreen extends StatefulWidget {
  final CrawlInterval current;

  const CrawlIntervalConfigScreen({required this.current, super.key});

  @override
  State<CrawlIntervalConfigScreen> createState() =>
      _CrawlIntervalConfigScreenState();
}

class _CrawlIntervalConfigScreenState
    extends State<CrawlIntervalConfigScreen> {
  static const _accent = Color(0xFF1A73E8);

  late CrawlInterval _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  static const _options = <_Option>[
    _Option(
      CrawlInterval.once,
      'Thủ công',
      'Chỉ đồng bộ khi bạn nhấn Reindex',
      Icons.touch_app,
    ),
    _Option(
      CrawlInterval.daily,
      'Hàng ngày',
      'Tự động đồng bộ lúc 00:00 mỗi ngày',
      Icons.today,
    ),
    _Option(
      CrawlInterval.weekly,
      'Hàng tuần',
      'Tự động đồng bộ vào 00:00 Thứ Hai',
      Icons.date_range,
    ),
    _Option(
      CrawlInterval.monthly,
      'Hàng tháng',
      'Tự động đồng bộ vào 00:00 ngày 1',
      Icons.calendar_month,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cấu hình tần suất đồng bộ'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: const Text('Lưu',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tần suất đồng bộ xác định mức độ thường xuyên hệ thống cập nhật nội dung từ nguồn dữ liệu.',
                    style: TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final o = _options[index];
                final isSelected = _selected == o.interval;
                return GestureDetector(
                  onTap: () => setState(() => _selected = o.interval),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? _accent : Colors.grey[200]!,
                        width: isSelected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? _accent.withValues(alpha: 0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _accent.withValues(alpha: 0.12)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            o.icon,
                            size: 22,
                            color: isSelected ? _accent : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                o.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isSelected ? _accent : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                o.desc,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Radio<CrawlInterval>(
                          value: o.interval,
                          groupValue: _selected,
                          onChanged: (v) =>
                              setState(() => _selected = v!),
                          activeColor: _accent,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selected),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Xác nhận',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Option {
  final CrawlInterval interval;
  final String title;
  final String desc;
  final IconData icon;
  const _Option(this.interval, this.title, this.desc, this.icon);
}
