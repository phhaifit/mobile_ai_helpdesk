import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/google_drive_oauth_service.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/crawl_interval_grid.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';
import 'package:flutter/material.dart';

/// Google Drive import form.  Wraps the OAuth implicit flow + a paths editor
/// + interval picker, then submits via `POST /google-drive`.
class GoogleDriveFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const GoogleDriveFormScreen({required this.store, super.key});

  @override
  State<GoogleDriveFormScreen> createState() => _GoogleDriveFormScreenState();
}

class _GoogleDriveFormScreenState extends State<GoogleDriveFormScreen> {
  static const _accent = Color(0xFF1A73E8);
  static const _driveGreen = Color(0xFF0F9D58);

  final _nameController = TextEditingController();
  final _pathsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _oauthService = GoogleDriveOAuthService();

  CrawlInterval _interval = CrawlInterval.once;
  GoogleDriveCredentials? _credentials;
  bool _signingIn = false;
  bool _saving = false;
  String? _signInError;
  String? _submitError;

  @override
  void dispose() {
    _nameController.dispose();
    _pathsController.dispose();
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
          'Google Drive',
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
                    _label('Tên', required: true),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      enabled: !_saving,
                      decoration: _decoration('Ví dụ: Tài liệu nội bộ Q4'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Vui lòng nhập tên nguồn'
                              : null,
                    ),
                    const SizedBox(height: 20),
                    _label('Tài khoản Google', required: true),
                    const SizedBox(height: 8),
                    _signInBox(),
                    if (_signInError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _signInError!,
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _label(
                      'Đường dẫn cần đồng bộ',
                      required: true,
                      hint:
                          'Mỗi đường dẫn trên một dòng — ví dụ /Reports/2024',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pathsController,
                      enabled: !_saving,
                      maxLines: 4,
                      minLines: 3,
                      decoration: _decoration(
                        '/Reports/2024\n/Docs/FAQ',
                      ),
                      validator: (_) =>
                          _parsePaths().isEmpty ? 'Cần ít nhất một đường dẫn' : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lưu ý: sau mỗi lần chỉnh sửa trên Drive, hệ thống mất ~20 phút để đồng bộ lại.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    _label(
                      'Tự động làm mới định kỳ',
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

  Widget _signInBox() {
    if (_credentials != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _accent),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: _driveGreen),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Đã kết nối Google Drive',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: _saving
                  ? null
                  : () => setState(() => _credentials = null),
              child: const Text('Đăng nhập lại'),
            ),
          ],
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: _signingIn || _saving ? null : _signIn,
      icon: _signingIn
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.add_to_drive, color: _driveGreen),
      label: Text(
        _signingIn
            ? 'Đang mở phiên Google…'
            : 'Đăng nhập với Google Drive',
        style: const TextStyle(color: Colors.black87),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    final canSubmit = _credentials != null && !_saving;
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
              onPressed: canSubmit ? _submit : null,
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
                      'Xác nhận',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, {bool required = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
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
        ),
        if (hint != null) ...[
          const SizedBox(height: 2),
          Text(
            hint,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ],
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

  List<String> _parsePaths() {
    return _pathsController.text
        .split(RegExp(r'[\n,]'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
  }

  Future<void> _signIn() async {
    setState(() {
      _signingIn = true;
      _signInError = null;
    });
    try {
      final creds = await _oauthService.signIn();
      if (!mounted) return;
      setState(() => _credentials = creds);
    } catch (e) {
      if (!mounted) return;
      setState(() => _signInError = e.toString());
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final creds = _credentials;
    if (creds == null) return;

    setState(() {
      _saving = true;
      _submitError = null;
    });

    final supportId = getIt<SessionStore>().currentAgentId;

    final result = await widget.store
        .importGoogleDrive(
          name: _nameController.text.trim(),
          includePaths: _parsePaths(),
          customerSupportId: supportId,
          credentials: creds,
          interval: _interval,
        )
        .catchError((Object _) => null);

    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) {
      Navigator.pop(context);
    } else {
      setState(() {
        _submitError = widget.store.errorMessage ??
            'Không thể tạo nguồn Google Drive.';
      });
    }
  }
}
