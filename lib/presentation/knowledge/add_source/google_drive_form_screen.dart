import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/google_drive_oauth_service.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/crawl_interval_grid.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';
import 'package:flutter/material.dart';

/// "Import from Google Drive" form.
///
/// Flow: connect a Google account via the OAuth 2.0 Authorization Code + PKCE
/// flow ([GoogleDriveOAuthService]) → which yields an `accessToken` +
/// `refreshToken` → then `POST /api/v1/knowledges/{tenantId}/google-drive`
/// with `{ name, includePaths, customerSupportID, credentials, interval }`.
class GoogleDriveFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const GoogleDriveFormScreen({required this.store, super.key});

  @override
  State<GoogleDriveFormScreen> createState() => _GoogleDriveFormScreenState();
}

class _GoogleDriveFormScreenState extends State<GoogleDriveFormScreen> {
  // Google brand-ish accents reused from the other add-source forms.
  static const _accent = Color(0xFF1A73E8); // Google blue
  static const _driveGreen = Color(0xFF0F9D58);
  static const _danger = Color(0xFFDC2626);

  final _nameController = TextEditingController();
  final _pathsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _oauthService = GoogleDriveOAuthService();

  CrawlInterval _interval = CrawlInterval.once;
  GoogleDriveAuthResult? _auth;
  bool _connecting = false;
  bool _saving = false;
  String? _connectError;
  String? _submitError;

  bool get _isBusy => _connecting || _saving;
  bool get _canSubmit => _auth != null && !_isBusy;

  @override
  void dispose() {
    _nameController.dispose();
    _pathsController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Actions
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _connectGoogle() async {
    setState(() {
      _connecting = true;
      _connectError = null;
    });
    try {
      final result = await _oauthService.signIn();
      if (!mounted) return;
      // `null` ⇒ the user dismissed the browser — leave state untouched, no error.
      if (result != null) setState(() => _auth = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _connectError = e.toString());
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  void _disconnectGoogle() {
    setState(() {
      _auth = null;
      _connectError = null;
      _submitError = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final auth = _auth;
    if (auth == null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _submitError = null;
    });

    // TODO: `customerSupportID` currently comes from SessionStore.currentAgentId,
    // which is still a placeholder in this codebase. Wire it to the real
    // selected support assistant once that exists.
    final customerSupportId = getIt<SessionStore>().currentAgentId;

    final created = await widget.store
        .importGoogleDrive(
          name: _nameController.text.trim(),
          includePaths: _parsePaths(),
          customerSupportId: customerSupportId,
          credentials: auth.toCredentials(),
          interval: _interval,
        )
        .catchError((Object _) => null);

    if (!mounted) return;
    if (created != null) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _saving = false;
      _submitError = widget.store.errorMessage ??
          'Không thể tạo nguồn Google Drive. Vui lòng thử lại.';
    });
  }

  List<String> _parsePaths() => _pathsController.text
      .split(RegExp(r'[\n,]'))
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList(growable: false);

  // ───────────────────────────────────────────────────────────────────────────
  // Build
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _isBusy ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Nhập từ Google Drive',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Divider(height: 1),
            Expanded(
              child: AbsorbPointer(
                absorbing: _saving,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    _intro(),
                    const SizedBox(height: 24),

                    // 1 ─ Account ------------------------------------------------
                    _stepLabel(1, 'Kết nối tài khoản Google', required: true),
                    const SizedBox(height: 10),
                    _accountBox(),
                    if (_connectError != null) ...[
                      const SizedBox(height: 8),
                      _hintError(_connectError!),
                    ],
                    const SizedBox(height: 24),

                    // 2 ─ Name --------------------------------------------------
                    _stepLabel(2, 'Tên nguồn tri thức', required: true),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration('Ví dụ: Tài liệu nội bộ Q4'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Vui lòng nhập tên nguồn'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // 3 ─ Paths -------------------------------------------------
                    _stepLabel(3, 'Đường dẫn cần đồng bộ', required: true),
                    const SizedBox(height: 4),
                    Text(
                      'Mỗi đường dẫn trên một dòng (hoặc ngăn cách bởi dấu phẩy) '
                      '— ví dụ /Reports/2024.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pathsController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: _decoration('/Reports/2024\n/Docs/FAQ'),
                      validator: (_) => _parsePaths().isEmpty
                          ? 'Cần ít nhất một đường dẫn'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    _noteRow(
                      Icons.schedule_outlined,
                      'Sau mỗi lần chỉnh sửa trên Drive, hệ thống mất ~20 phút '
                      'để đồng bộ lại.',
                    ),
                    const SizedBox(height: 24),

                    // 4 ─ Interval ----------------------------------------------
                    _stepLabel(4, 'Tự động làm mới định kỳ'),
                    const SizedBox(height: 10),
                    CrawlIntervalGrid(
                      selected: _interval,
                      onSelected: _isBusy
                          ? (_) {}
                          : (v) => setState(() => _interval = v),
                    ),

                    if (_submitError != null) ...[
                      const SizedBox(height: 20),
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

  // ───────────────────────────────────────────────────────────────────────────
  // Pieces
  // ───────────────────────────────────────────────────────────────────────────

  Widget _intro() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE6FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDCE6FF)),
            ),
            child: const Icon(Icons.add_to_drive, color: _driveGreen, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Cấp quyền chỉ-đọc cho Drive, chọn các thư mục cần đồng bộ, rồi '
              'hệ thống sẽ tự lập chỉ mục tài liệu cho trợ lý AI.',
              style: TextStyle(fontSize: 13, height: 1.35, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountBox() {
    final auth = _auth;
    if (auth != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1FBF4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _driveGreen.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _driveGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: _driveGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đã kết nối Google Drive',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        auth.accountEmail ?? 'Đã cấp quyền truy cập Drive',
                        style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _isBusy ? null : _disconnectGoogle,
                  style: TextButton.styleFrom(foregroundColor: _accent),
                  child: const Text('Đổi tài khoản'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.lock_outline, size: 13, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Phạm vi: chỉ đọc Drive (drive.readonly). Token được gửi an '
                    'toàn cho máy chủ để lập chỉ mục.',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isBusy ? null : _connectGoogle,
        icon: _connecting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add_to_drive, color: _driveGreen, size: 20),
        label: Text(
          _connecting ? 'Đang mở phiên Google…' : 'Kết nối tài khoản Google',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _bottomBar() {
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
              onPressed: _isBusy ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Đóng', style: TextStyle(color: Colors.black87)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _canSubmit ? _submit : null,
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
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Tạo nguồn',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ── small reusable bits ──────────────────────────────────────────────────

  Widget _stepLabel(int step, String text, {bool required = false}) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$step',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _accent,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              children: required
                  ? const [
                      TextSpan(
                        text: '  *',
                        style: TextStyle(color: _danger, fontSize: 14),
                      ),
                    ]
                  : const [],
            ),
          ),
        ),
      ],
    );
  }

  Widget _noteRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 11.5, color: Colors.grey[600], height: 1.3),
          ),
        ),
      ],
    );
  }

  Widget _hintError(String msg) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, size: 14, color: _danger),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(color: _danger, fontSize: 12, height: 1.3),
            ),
          ),
        ],
      );

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: _danger, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(color: _danger, fontSize: 13, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: border(Colors.grey[300]!),
      enabledBorder: border(Colors.grey[300]!),
      focusedBorder: border(_accent),
      errorBorder: border(_danger),
      focusedErrorBorder: border(_danger),
    );
  }
}
