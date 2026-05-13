import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/crawl_interval_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Database query import — 2-step flow:
///   Step 1: Name + sync interval
///   Step 2: Connection (host/port/db/user/pass) + SQL query, with live test
///   button that calls `POST /test-database-query` and shows a row preview.
///
/// On submit we build a postgresql:// or sqlserver:// URI and import via
/// `POST /database-query`.
class DatabaseFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const DatabaseFormScreen({required this.store, super.key});

  @override
  State<DatabaseFormScreen> createState() => _DatabaseFormScreenState();
}

class _DatabaseFormScreenState extends State<DatabaseFormScreen> {
  static const _accent = Color(0xFF1A73E8);

  // Step 1
  final _nameController = TextEditingController();
  CrawlInterval _interval = CrawlInterval.once;

  // Step 2
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _dbController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _queryController = TextEditingController();
  bool _obscurePassword = true;
  DatabaseDialect _dialect = DatabaseDialect.postgresql;

  int _step = 1;
  bool _saving = false;
  String? _step1Error;
  String? _step2Error;

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _dbController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _queryController.dispose();
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
          onPressed: _saving
              ? null
              : () {
                  if (_step == 2) {
                    setState(() => _step = 1);
                    widget.store.resetDbTest();
                  } else {
                    Navigator.pop(context);
                  }
                },
        ),
        title: Text(
          _step == 1 ? 'Truy vấn CSDL — Bước 1/2' : 'Truy vấn CSDL — Bước 2/2',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(child: _step == 1 ? _buildStep1() : _buildStep2()),
          _bottomBar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 1
  // ---------------------------------------------------------------------------

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Tên', required: true),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: _decoration('Ví dụ: Sản phẩm catalog'),
            onChanged: (_) {
              if (_step1Error != null) setState(() => _step1Error = null);
            },
          ),
          if (_step1Error != null) ...[
            const SizedBox(height: 4),
            Text(
              _step1Error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 24),
          _label('Tự động làm mới định kỳ'),
          const SizedBox(height: 10),
          CrawlIntervalGrid(
            selected: _interval,
            onSelected: (v) => setState(() => _interval = v),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2
  // ---------------------------------------------------------------------------

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Loại CSDL'),
          const SizedBox(height: 6),
          DropdownButtonFormField<DatabaseDialect>(
            value: _dialect,
            decoration: _decoration(''),
            items: const [
              DropdownMenuItem(
                value: DatabaseDialect.postgresql,
                child: Text('PostgreSQL'),
              ),
              DropdownMenuItem(
                value: DatabaseDialect.sqlServer,
                child: Text('SQL Server'),
              ),
            ],
            onChanged: _saving
                ? null
                : (v) {
                    if (v == null) return;
                    setState(() => _dialect = v);
                    _onConfigChanged();
                  },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _field(
                  label: 'Địa chỉ host',
                  controller: _hostController,
                  hint: 'localhost hoặc 192.168.1.1',
                  required: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _field(
                  label: 'Cổng',
                  controller: _portController,
                  hint: _defaultPortHint(),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _field(
            label: 'Tên CSDL',
            controller: _dbController,
            hint: 'helpdesk_prod',
            required: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _field(
                  label: 'Tên người dùng',
                  controller: _userController,
                  hint: 'readonly_user',
                  required: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _passwordField(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _label('Câu truy vấn SQL', required: true),
          const SizedBox(height: 8),
          TextField(
            controller: _queryController,
            maxLines: 4,
            minLines: 3,
            decoration: _decoration(
              'SELECT id, title FROM articles WHERE active = true',
            ),
            onChanged: (_) => _onConfigChanged(),
          ),
          const SizedBox(height: 16),
          Observer(
            builder: (_) => SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.store.isTestingDb || _saving
                    ? null
                    : _testConnection,
                icon: widget.store.isTestingDb
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.wifi_protected_setup),
                label: Text(
                  widget.store.isTestingDb
                      ? 'Đang kiểm tra…'
                      : 'Kiểm tra kết nối + truy vấn',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _testResultBanner(),
          if (_step2Error != null) ...[
            const SizedBox(height: 12),
            _errorBanner(_step2Error!),
          ],
        ],
      ),
    );
  }

  Widget _testResultBanner() {
    return Observer(builder: (_) {
      final preview = widget.store.lastDbPreview;
      final err = widget.store.dbTestError;
      if (widget.store.isTestingDb) {
        return _statusBanner(
          message: 'Đang kết nối tới CSDL…',
          fg: _accent,
          bg: const Color(0xFFEFF6FF),
          icon: Icons.sync,
        );
      }
      if (err != null) {
        return _statusBanner(
          message: 'Kết nối thất bại: $err',
          fg: const Color(0xFFDC2626),
          bg: const Color(0xFFFEF2F2),
          icon: Icons.error_outline,
        );
      }
      if (preview == null) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusBanner(
            message: preview.message ??
                'Kết nối thành công — ${preview.rows.length} dòng kết quả.',
            fg: const Color(0xFF16A34A),
            bg: const Color(0xFFECFDF3),
            icon: Icons.check_circle_outline,
          ),
          if (preview.rows.isNotEmpty) ...[
            const SizedBox(height: 8),
            _previewTable(preview),
          ],
        ],
      );
    });
  }

  Widget _previewTable(DatabaseQueryPreview preview) {
    final cols = preview.columns.isNotEmpty
        ? preview.columns
        : (preview.rows.isNotEmpty
            ? preview.rows.first.keys.toList(growable: false)
            : <String>[]);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 36,
          dataRowMinHeight: 32,
          dataRowMaxHeight: 40,
          columns: [
            for (final c in cols)
              DataColumn(
                label: Text(
                  c,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
          ],
          rows: [
            for (final row in preview.rows.take(5))
              DataRow(
                cells: [
                  for (final c in cols)
                    DataCell(Text(row[c]?.toString() ?? '')),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: !_saving,
          decoration: _decoration(hint),
          onChanged: (_) => _onConfigChanged(),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Mật khẩu', required: true),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          enabled: !_saving,
          decoration: _decoration('mật khẩu DB').copyWith(
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: Colors.grey,
              ),
            ),
          ),
          onChanged: (_) => _onConfigChanged(),
        ),
      ],
    );
  }

  Widget _statusBanner({
    required String message,
    required Color fg,
    required Color bg,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorBanner(String msg) => _statusBanner(
        message: msg,
        fg: const Color(0xFFDC2626),
        bg: const Color(0xFFFEF2F2),
        icon: Icons.error_outline,
      );

  Widget _bottomBar() {
    final isStep1 = _step == 1;
    final canSubmit = isStep1
        ? !_saving
        : !_saving && widget.store.lastDbPreview != null;
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
            child: Observer(
              builder: (_) => ElevatedButton(
                onPressed: canSubmit ? (isStep1 ? _toStep2 : _submit) : null,
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
                    : Text(
                        isStep1 ? 'Tiếp theo' : 'Xác nhận',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
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
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
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

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void _onConfigChanged() {
    if (widget.store.lastDbPreview != null ||
        widget.store.dbTestError != null) {
      widget.store.resetDbTest();
    }
  }

  void _toStep2() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _step1Error = 'Vui lòng nhập tên nguồn');
      return;
    }
    widget.store.resetDbTest();
    setState(() => _step = 2);
  }

  Future<void> _testConnection() async {
    final uri = _buildUri();
    final query = _queryController.text.trim();
    if (uri == null || query.isEmpty) {
      setState(() => _step2Error = 'Cần điền đủ host/db/user/password và truy vấn.');
      return;
    }
    setState(() => _step2Error = null);
    await widget.store.testDatabaseQuery(query: query, uri: uri);
  }

  Future<void> _submit() async {
    final uri = _buildUri();
    final query = _queryController.text.trim();
    if (uri == null || query.isEmpty) {
      setState(() => _step2Error = 'Thiếu thông tin kết nối hoặc truy vấn.');
      return;
    }
    setState(() {
      _saving = true;
      _step2Error = null;
    });
    final result = await widget.store
        .importDatabaseQuery(
          name: _nameController.text.trim(),
          query: query,
          uri: uri,
          interval: _interval,
          dialect: _dialect,
        )
        .catchError((Object _) => null);
    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) {
      Navigator.pop(context);
    } else {
      setState(() {
        _step2Error =
            widget.store.errorMessage ?? 'Không tạo được nguồn CSDL.';
      });
    }
  }

  /// Builds a `<scheme>://<user>:<pass>@<host>:<port>/<db>` URI from the form.
  /// Returns null if any required piece is missing.
  String? _buildUri() {
    final host = _hostController.text.trim();
    final db = _dbController.text.trim();
    final user = _userController.text.trim();
    final pass = _passwordController.text;
    if (host.isEmpty || db.isEmpty || user.isEmpty || pass.isEmpty) {
      return null;
    }
    final scheme = _dialect == DatabaseDialect.postgresql
        ? 'postgresql'
        : 'sqlserver';
    final port = _portController.text.trim();
    final hostPart = port.isEmpty ? host : '$host:$port';
    final userPart =
        '${Uri.encodeComponent(user)}:${Uri.encodeComponent(pass)}';
    return '$scheme://$userPart@$hostPart/$db';
  }

  String _defaultPortHint() {
    return _dialect == DatabaseDialect.postgresql ? '5432' : '1433';
  }
}
