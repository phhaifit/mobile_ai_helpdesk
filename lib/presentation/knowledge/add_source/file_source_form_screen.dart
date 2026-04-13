import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:flutter/material.dart';

class FileSourceFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const FileSourceFormScreen({super.key, required this.store});

  @override
  State<FileSourceFormScreen> createState() => _FileSourceFormScreenState();
}

class _FileSourceFormScreenState extends State<FileSourceFormScreen> {
  String? _mockFileName;
  bool _isSaving = false;

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
        title: const Text('Tệp tin',
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
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
                  _buildLabel('Tệp tin', required: true),
                  const SizedBox(height: 10),
                  _buildFilePicker(),
                  if (_mockFileName != null) ...[
                    const SizedBox(height: 10),
                    _buildSelectedFile(),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Định dạng hỗ trợ: PDF, DOCX, TXT, CSV, XLSX',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[500]),
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
    return GestureDetector(
      onTap: _mockPickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          border: Border.all(
            color: _mockFileName != null
                ? const Color(0xFF1A73E8)
                : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined,
                size: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            const Text('Nhấn để tải lên tệp',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('PDF, DOCX, TXT, CSV, XLSX',
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFile() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file,
              color: Color(0xFF1A73E8), size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_mockFileName!,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text('204 KB',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _mockFileName = null),
            child: const Icon(Icons.close, size: 18, color: Colors.grey),
          ),
        ],
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
              onPressed: (_mockFileName == null || _isSaving) ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
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

  void _mockPickFile() {
    setState(() => _mockFileName = 'tai_lieu_noi_bo.docx');
  }

  Future<void> _submit() async {
    if (_mockFileName == null) return;
    setState(() => _isSaving = true);
    final source = KnowledgeSource(
      id: '',
      name: _mockFileName!,
      type: KnowledgeSourceType.localFile,
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime.now(),
      crawlInterval: CrawlInterval.manual,
      config: {'fileName': _mockFileName, 'fileSize': 204800},
    );
    await widget.store.addSource(source);
    setState(() => _isSaving = false);
    if (mounted) Navigator.pop(context);
  }
}
