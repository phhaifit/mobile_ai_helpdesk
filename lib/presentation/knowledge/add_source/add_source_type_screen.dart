import 'package:ai_helpdesk/presentation/knowledge/add_source/database_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/file_source_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/google_drive_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/web_source_form_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:flutter/material.dart';

class AddSourceTypeScreen extends StatefulWidget {
  final KnowledgeStore store;

  const AddSourceTypeScreen({super.key, required this.store});

  @override
  State<AddSourceTypeScreen> createState() => _AddSourceTypeScreenState();
}

class _AddSourceTypeScreenState extends State<AddSourceTypeScreen> {
  int _selectedIndex = 0;

  static const _sourceTypes = [
    (
      Icons.insert_drive_file_outlined,
      'Tệp tin',
      'Tải lên tệp tin với các định dạng pdf, txt, docx, doc,...',
      Color(0xFF1A73E8),
    ),
    (
      Icons.language,
      'Web',
      'Kết nối đến trang web để lấy và xử lý dữ liệu',
      Color(0xFF1A73E8),
    ),
    (
      Icons.add_to_drive,
      'Google Drive',
      'Kết nối đến Google Drive để lấy và xử lý dữ liệu',
      Color(0xFF1A73E8),
    ),
    (
      Icons.storage_outlined,
      'Truy vấn CSDL',
      'Kết nối đến cơ sở dữ liệu để truy vấn và xử lý dữ liệu',
      Color(0xFF1A73E8),
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _sourceTypes.length,
              itemBuilder: (context, index) {
                final (icon, title, subtitle, color) = _sourceTypes[index];
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[200]!,
                        width: isSelected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? color.withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withOpacity(0.12)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon,
                              size: 20,
                              color: isSelected ? color : Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isSelected ? color : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
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
                      backgroundColor: const Color(0xFF1A73E8),
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
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => form));
  }
}
