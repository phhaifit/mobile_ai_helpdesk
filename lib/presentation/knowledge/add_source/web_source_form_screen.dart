import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/crawl_interval_grid.dart';
import 'package:flutter/material.dart';

class WebSourceFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const WebSourceFormScreen({super.key, required this.store});

  @override
  State<WebSourceFormScreen> createState() => _WebSourceFormScreenState();
}

class _WebSourceFormScreenState extends State<WebSourceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _fullSite = false;
  CrawlInterval _crawlInterval = CrawlInterval.manual;
  bool _isSaving = false;

  @override
  void dispose() {
    _urlController.dispose();
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
        title: const Text('Web',
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('URL', required: true),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _urlController,
                      decoration: _inputDecoration(
                          'Địa chỉ URL của nguồn tri thức'),
                      keyboardType: TextInputType.url,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Vui lòng nhập URL';
                        if (!v.startsWith('http')) {
                          return 'URL phải bắt đầu bằng http(s)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildLabel('Loại'),
                    const SizedBox(height: 10),
                    _buildTypeToggle(),
                    const SizedBox(height: 12),
                    _buildInfoBox(),
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

  Widget _buildTypeToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _fullSite = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: !_fullSite
                      ? const Color(0xFF1A73E8)
                      : Colors.grey[200]!,
                  width: !_fullSite ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: !_fullSite
                    ? const Color(0xFF1A73E8).withOpacity(0.05)
                    : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Một trang',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: !_fullSite
                            ? const Color(0xFF1A73E8)
                            : Colors.black87,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    'Chỉ lấy nội dung từ trang web với URL trên',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _fullSite = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _fullSite
                      ? const Color(0xFF1A73E8)
                      : Colors.grey[200]!,
                  width: _fullSite ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: _fullSite
                    ? const Color(0xFF1A73E8).withOpacity(0.05)
                    : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Toàn bộ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _fullSite
                            ? const Color(0xFF1A73E8)
                            : Colors.black87,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    'Lấy nội dung của các trang liên quan.',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Giới hạn hiện tại:',
              style:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          _buildBullet(
              'Việc nhập toàn bộ trang web có thể mất một thời gian để hoàn thành. Bạn có thể tải tối đa 100 trang cùng lúc'),
          const SizedBox(height: 4),
          _buildBullet('Cần thêm? hello@jarvis.cx'),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 13)),
        Expanded(
            child: Text(text,
                style:
                    const TextStyle(fontSize: 12, color: Colors.black87))),
      ],
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final source = KnowledgeSource(
      id: '',
      name: _urlController.text.trim(),
      type: _fullSite
          ? KnowledgeSourceType.webFull
          : KnowledgeSourceType.webSingle,
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime.now(),
      crawlInterval: _crawlInterval,
      config: {
        'url': _urlController.text.trim(),
        'fullSite': _fullSite,
      },
    );
    await widget.store.addSource(source);
    setState(() => _isSaving = false);
    if (mounted) Navigator.pop(context);
  }
}
