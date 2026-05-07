import 'dart:io';

import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Local-file import form.  Uses the real `file_picker` plugin to pick a
/// document, multipart-uploads via `POST /local-file`, and shows live upload
/// progress reactively from the store.
class FileSourceFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const FileSourceFormScreen({required this.store, super.key});

  @override
  State<FileSourceFormScreen> createState() => _FileSourceFormScreenState();
}

class _FileSourceFormScreenState extends State<FileSourceFormScreen> {
  static const _accent = Color(0xFF1A73E8);
  static const _allowedExtensions = ['pdf', 'docx', 'doc', 'txt', 'csv', 'xlsx'];
  static const _maxSizeBytes = 50 * 1024 * 1024; // 50 MB

  File? _file;
  String? _fileName;
  int _fileSize = 0;
  String? _localError;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _saving ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Tệp tin',
          style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
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
                  _label('Tệp tin', required: true),
                  const SizedBox(height: 10),
                  _picker(),
                  if (_file != null) ...[
                    const SizedBox(height: 10),
                    _selected(),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Định dạng hỗ trợ: ${_allowedExtensions.map((e) => e.toUpperCase()).join(', ')} • Tối đa 50 MB',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  if (_localError != null) ...[
                    const SizedBox(height: 12),
                    _errorBanner(_localError!),
                  ],
                  Observer(builder: (_) {
                    if (widget.store.uploadProgress == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _uploadProgress(widget.store.uploadProgress!),
                    );
                  }),
                  Observer(builder: (_) {
                    final err = widget.store.errorMessage;
                    if (!_saving || err == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _errorBanner(err),
                    );
                  }),
                ],
              ),
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _picker() {
    return GestureDetector(
      onTap: _saving ? null : _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          border: Border.all(
            color: _file != null ? _accent : Colors.grey[300]!,
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
            const Text(
              'Nhấn để chọn tệp',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              _allowedExtensions.map((e) => e.toUpperCase()).join(', '),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selected() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: _accent, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatBytes(_fileSize),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: _saving
                ? null
                : () => setState(() {
                      _file = null;
                      _fileName = null;
                      _fileSize = 0;
                    }),
          ),
        ],
      ),
    );
  }

  Widget _uploadProgress(double progress) {
    final pct = (progress * 100).clamp(0, 100).toStringAsFixed(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đang tải lên… $pct%',
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(_accent),
          ),
        ),
      ],
    );
  }

  Widget _errorBanner(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: Color(0xFFDC2626), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
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
              onPressed: _saving ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Đóng',
                  style: TextStyle(color: Colors.black87)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: (_file == null || _saving) ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Tải lên',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ]
            : const [],
      ),
    );
  }

  Future<void> _pickFile() async {
    setState(() => _localError = null);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: false,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final picked = result.files.single;
    final path = picked.path;
    if (path == null) {
      setState(() => _localError = 'Không lấy được đường dẫn tệp.');
      return;
    }
    final size = picked.size;
    if (size > _maxSizeBytes) {
      setState(() {
        _localError =
            'Tệp vượt quá ${_formatBytes(_maxSizeBytes)} — vui lòng chọn tệp nhỏ hơn.';
      });
      return;
    }

    setState(() {
      _file = File(path);
      _fileName = picked.name;
      _fileSize = size;
    });
  }

  Future<void> _submit() async {
    final file = _file;
    final name = _fileName;
    if (file == null || name == null) return;
    setState(() {
      _saving = true;
      _localError = null;
    });
    final result = await widget.store
        .importLocalFile(file: file, fileName: name)
        .catchError((Object _) => null);
    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) {
      Navigator.pop(context);
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
