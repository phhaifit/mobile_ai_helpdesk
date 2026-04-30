import 'dart:io';

import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FileSourceFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const FileSourceFormScreen({required this.store, super.key});

  @override
  State<FileSourceFormScreen> createState() => _FileSourceFormScreenState();
}

class _FileSourceFormScreenState extends State<FileSourceFormScreen> {
  File? _pickedFile;
  String? _fileName;
  int? _fileSize;

  @override
  void initState() {
    super.initState();
    widget.store.resetUpload();
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
        title: const Text(
          'Tệp tin',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (widget.store.uploadSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) Navigator.pop(context);
            });
          }
          return Column(
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
                      if (_fileName != null) ...[
                        const SizedBox(height: 10),
                        _buildSelectedFile(),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Định dạng hỗ trợ: PDF, DOCX, TXT, CSV, XLSX',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      if (widget.store.uploadError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          widget.store.uploadError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
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
            : [],
      ),
    );
  }

  Widget _buildFilePicker() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                _fileName != null
                    ? const Color(0xFF1A73E8)
                    : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            const Text(
              'Nhấn để tải lên tệp',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'PDF, DOCX, TXT, CSV, XLSX',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFile() {
    final sizeLabel = _fileSize != null
        ? '${(_fileSize! / 1024).toStringAsFixed(0)} KB'
        : '';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file,
            color: Color(0xFF1A73E8),
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileName!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (sizeLabel.isNotEmpty)
                  Text(
                    sizeLabel,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              _pickedFile = null;
              _fileName = null;
              _fileSize = null;
            }),
            child: const Icon(Icons.close, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Observer(
      builder: (_) {
        final isUploading = widget.store.isUploading;
        return Container(
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            12 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      isUploading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Đóng',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      (_pickedFile == null || isUploading) ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: isUploading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Xác nhận',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['pdf', 'docx', 'txt', 'csv', 'xlsx'],
    );
    if (result == null || result.files.single.path == null) return;
    setState(() {
      _pickedFile = File(result.files.single.path!);
      _fileName = result.files.single.name;
      _fileSize = result.files.single.size;
    });
  }

  Future<void> _submit() async {
    if (_pickedFile == null) return;
    await widget.store.uploadFile(_pickedFile!);
  }
}
