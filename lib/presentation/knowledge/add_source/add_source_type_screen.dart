import 'package:ai_helpdesk/presentation/knowledge/add_source/database_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/file_source_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/google_drive_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/web_source_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:flutter/material.dart';

/// Bottom-sheet picker shown when the user taps "Thêm nguồn".  Each option
/// pushes the matching form screen as a full-page route.
class AddSourceTypeScreen extends StatefulWidget {
  final KnowledgeStore store;

  const AddSourceTypeScreen({required this.store, super.key});

  @override
  State<AddSourceTypeScreen> createState() => _AddSourceTypeScreenState();
}

class _AddSourceTypeScreenState extends State<AddSourceTypeScreen> {
  static const _accent = Color(0xFF1A73E8);

  int _selectedIndex = 0;

  static const _options = <_SourceOption>[
    _SourceOption(
      icon: Icons.insert_drive_file_outlined,
      title: 'Tệp tin',
      subtitle: 'Tải lên PDF, DOCX, TXT, CSV, XLSX',
    ),
    _SourceOption(
      icon: Icons.language,
      title: 'Web',
      subtitle: 'Crawl một URL hoặc toàn bộ website',
    ),
    _SourceOption(
      icon: Icons.add_to_drive,
      title: 'Google Drive',
      subtitle: 'Đồng bộ folder/file từ Drive qua OAuth',
    ),
    _SourceOption(
      icon: Icons.storage_outlined,
      title: 'Truy vấn CSDL',
      subtitle: 'PostgreSQL hoặc SQL Server',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Text(
                  'Chọn nguồn tri thức',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final option = _options[index];
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? _accent : Colors.grey[200]!,
                        width: isSelected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? _accent.withValues(alpha: 0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _accent.withValues(alpha: 0.12)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            option.icon,
                            size: 20,
                            color: isSelected ? _accent : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isSelected
                                      ? _accent
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                option.subtitle,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Đóng',
                        style: TextStyle(color: Colors.black87)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Tiếp theo',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _goNext() {
    Navigator.pop(context);
    final navigator = Navigator.of(context, rootNavigator: false);
    Widget form;
    switch (_selectedIndex) {
      case 0:
        form = FileSourceFormScreen(store: widget.store);
        break;
      case 1:
        form = WebSourceFormScreen(store: widget.store);
        break;
      case 2:
        form = GoogleDriveFormScreen(store: widget.store);
        break;
      case 3:
        form = DatabaseFormScreen(store: widget.store);
        break;
      default:
        return;
    }
    navigator.push(MaterialPageRoute<void>(builder: (_) => form));
  }
}

class _SourceOption {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
