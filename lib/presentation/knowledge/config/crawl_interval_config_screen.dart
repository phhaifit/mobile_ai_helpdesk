import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter/material.dart';

class CrawlIntervalConfigScreen extends StatefulWidget {
  final CrawlInterval current;

  const CrawlIntervalConfigScreen({super.key, required this.current});

  @override
  State<CrawlIntervalConfigScreen> createState() =>
      _CrawlIntervalConfigScreenState();
}

class _CrawlIntervalConfigScreenState
    extends State<CrawlIntervalConfigScreen> {
  late CrawlInterval _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  static const _options = [
    (
      CrawlInterval.manual,
      'Thủ công',
      'Chỉ đồng bộ khi bạn nhấn Reindex',
      Icons.touch_app,
    ),
    (
      CrawlInterval.hourly,
      'Mỗi giờ',
      'Tự động đồng bộ mỗi 60 phút',
      Icons.timer,
    ),
    (
      CrawlInterval.daily,
      'Mỗi ngày',
      'Tự động đồng bộ lúc 00:00 hàng ngày',
      Icons.today,
    ),
    (
      CrawlInterval.weekly,
      'Mỗi tuần',
      'Tự động đồng bộ vào 00:00 Thứ Hai hàng tuần',
      Icons.date_range,
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
                final (interval, title, desc, icon) = _options[index];
                final isSelected = _selected == interval;
                return GestureDetector(
                  onTap: () => setState(() => _selected = interval),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A73E8)
                            : Colors.grey[200]!,
                        width: isSelected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? const Color(0xFF1A73E8).withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A73E8).withOpacity(0.12)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            icon,
                            size: 22,
                            color: isSelected
                                ? const Color(0xFF1A73E8)
                                : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isSelected
                                      ? const Color(0xFF1A73E8)
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                desc,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Radio<CrawlInterval>(
                          value: interval,
                          groupValue: _selected,
                          onChanged: (v) =>
                              setState(() => _selected = v!),
                          activeColor: const Color(0xFF1A73E8),
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
                  backgroundColor: const Color(0xFF1A73E8),
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
