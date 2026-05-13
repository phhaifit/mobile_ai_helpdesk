import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/crawl_interval_grid.dart';
import 'package:flutter/material.dart';

/// Web import form — single page or whole site.  Submits via the real
/// `POST /web` endpoint and pops with the new source on success.
class WebSourceFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const WebSourceFormScreen({required this.store, super.key});

  @override
  State<WebSourceFormScreen> createState() => _WebSourceFormScreenState();
}

class _WebSourceFormScreenState extends State<WebSourceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _wholeSite = false;
  CrawlInterval _interval = CrawlInterval.once;
  bool _saving = false;
  String? _submitError;

  static const _accent = Color(0xFF1A73E8);

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
          onPressed: _saving ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Web',
          style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
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
                    _label('URL', required: true),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _urlController,
                      enabled: !_saving,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      decoration: _decoration('https://example.com/article'),
                      validator: _validateUrl,
                    ),
                    const SizedBox(height: 20),
                    _label('Loại'),
                    const SizedBox(height: 10),
                    _typeToggle(),
                    const SizedBox(height: 12),
                    _infoBox(),
                    const SizedBox(height: 24),
                    _label(
                      'Tự động kích hoạt làm mới nguồn tri thức theo khoảng thời gian định kỳ.',
                    ),
                    const SizedBox(height: 10),
                    CrawlIntervalGrid(
                      selected: _interval,
                      onSelected: _saving
                          ? (_) {}
                          : (v) => setState(() => _interval = v),
                    ),
                    if (_submitError != null) ...[
                      const SizedBox(height: 16),
                      _errorBanner(_submitError!),
                    ],
                  ],
                ),
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  String? _validateUrl(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Vui lòng nhập URL';
    final uri = Uri.tryParse(v);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'URL không hợp lệ';
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return 'URL phải bắt đầu bằng http(s)';
    }
    return null;
  }

  Widget _typeToggle() {
    return Row(
      children: [
        Expanded(
          child: _toggleCard(
            selected: !_wholeSite,
            title: 'Một trang',
            subtitle: 'Chỉ lấy nội dung từ URL trên',
            onTap: () => setState(() => _wholeSite = false),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _toggleCard(
            selected: _wholeSite,
            title: 'Toàn bộ',
            subtitle: 'Lấy nội dung của các trang liên quan',
            onTap: () => setState(() => _wholeSite = true),
          ),
        ),
      ],
    );
  }

  Widget _toggleCard({
    required bool selected,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _saving ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? _accent : Colors.grey[200]!,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: selected ? _accent.withValues(alpha: 0.05) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: selected ? _accent : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lưu ý:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          SizedBox(height: 8),
          _Bullet('Việc nhập toàn bộ trang có thể mất một thời gian.'),
          _Bullet('Tối đa 100 trang mỗi lần crawl.'),
        ],
      ),
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
              onPressed: _saving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
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
                      'Xác nhận',
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

  InputDecoration _decoration(String hint) {
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
        borderSide: const BorderSide(color: _accent),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _submitError = null;
    });
    final result = await widget.store
        .importWeb(
          url: _urlController.text.trim(),
          type: _wholeSite
              ? KnowledgeSourceType.wholeSite
              : KnowledgeSourceType.web,
          interval: _interval,
        )
        .catchError((Object _) => null);
    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) {
      Navigator.pop(context);
    } else {
      setState(() {
        _submitError =
            widget.store.errorMessage ?? 'Không thể tạo nguồn web. Vui lòng thử lại.';
      });
    }
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
