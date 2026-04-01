import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/crawl_interval_grid.dart';
import 'package:flutter/material.dart';

class GoogleDriveFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const GoogleDriveFormScreen({super.key, required this.store});

  @override
  State<GoogleDriveFormScreen> createState() => _GoogleDriveFormScreenState();
}

class _GoogleDriveFormScreenState extends State<GoogleDriveFormScreen> {
  final _nameController = TextEditingController();
  String? _selectedItem;
  CrawlInterval _crawlInterval = CrawlInterval.manual;
  bool _isSaving = false;
  bool _nameError = false;
  bool _fileError = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tập tin / Thư mục Google Drive',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Tên', required: true),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    onChanged: (_) {
                      if (_nameError) setState(() => _nameError = false);
                    },
                    decoration: _inputDecoration(
                            'Nhập tên cho nguồn tri thức này')
                        .copyWith(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _nameError
                              ? Colors.red
                              : Colors.grey[300]!,
                        ),
                      ),
                    ),
                  ),
                  if (_nameError) ...[
                    const SizedBox(height: 4),
                    const Text('Vui lòng nhập tên nguồn tri thức',
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                  const SizedBox(height: 20),
                  _buildLabel('Tập tin / Thư mục Google Drive',
                      required: true),
                  const SizedBox(height: 8),
                  _buildFilePicker(),
                  if (_fileError) ...[
                    const SizedBox(height: 4),
                    const Text(
                        'Vui lòng chọn tập tin hoặc thư mục Google Drive',
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    'Lưu ý: Sau mỗi lần chỉnh sửa, tài liệu cần khoảng 20 phút để được cập nhật lại.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel(
                      'Tự động kích hoạt làm mới nguồn tri thức theo khoảng thời gian định kỳ.'),
                  const SizedBox(height: 10),
                  CrawlIntervalGrid(
                    selected: _crawlInterval,
                    onSelected: (v) => setState(() => _crawlInterval = v),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
        children: required
            ? const [
                TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 13))
              ]
            : [],
      ),
    );
  }

  Widget _buildFilePicker() {
    if (_selectedItem != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1A73E8)),
        ),
        child: Row(
          children: [
            const Icon(Icons.folder, color: Color(0xFF1A73E8), size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_selectedItem!,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
            GestureDetector(
              onTap: () => setState(() => _selectedItem = null),
              child: const Icon(Icons.close, size: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: _mockPickItem,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: _fileError ? Colors.red : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/1/12/Google_Drive_icon_%282020%29.svg',
              width: 24,
              height: 24,
              errorBuilder: (_, __, ___) => const Icon(Icons.add_to_drive,
                  color: Color(0xFF0F9D58), size: 24),
            ),
            const SizedBox(width: 10),
            const Text('Chọn tập tin hoặc thư mục',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
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
              onPressed: _isSaving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Xác nhận',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1A73E8)),
      ),
    );
  }

  void _mockPickItem() {
    setState(() {
      _selectedItem = 'Helpdesk Docs';
      _fileError = false;
    });
  }

  Future<void> _submit() async {
    bool hasError = false;
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = true);
      hasError = true;
    }
    if (_selectedItem == null) {
      setState(() => _fileError = true);
      hasError = true;
    }
    if (hasError) return;

    setState(() => _isSaving = true);
    final source = KnowledgeSource(
      id: '',
      name: _nameController.text.trim(),
      type: KnowledgeSourceType.googleDrive,
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime.now(),
      crawlInterval: _crawlInterval,
      config: {
        'folderId': 'mock_folder_id',
        'folderName': _selectedItem,
      },
    );
    await widget.store.addSource(source);
    setState(() => _isSaving = false);
    if (mounted) Navigator.pop(context);
  }
}
