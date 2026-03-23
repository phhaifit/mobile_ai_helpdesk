import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/crawl_interval_grid.dart';
import 'package:flutter/material.dart';

class DatabaseFormScreen extends StatefulWidget {
  final KnowledgeStore store;

  const DatabaseFormScreen({super.key, required this.store});

  @override
  State<DatabaseFormScreen> createState() => _DatabaseFormScreenState();
}

class _DatabaseFormScreenState extends State<DatabaseFormScreen> {
  // Step 1
  final _nameController = TextEditingController();
  CrawlInterval _crawlInterval = CrawlInterval.manual;
  bool _nameError = false;

  // Step 2
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _dbController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _sqlController = TextEditingController();
  bool _obscurePassword = true;
  String _dbType = 'PostgreSQL';

  bool _isSaving = false;
  int _step = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _dbController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _sqlController.dispose();
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
          icon: Icon(
            _step == 1 ? Icons.arrow_back : Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            if (_step == 2) {
              setState(() => _step = 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Truy vấn CSDL',
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
            child: _step == 1 ? _buildStep1() : _buildStep2(),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 1: Name + Interval
  // ---------------------------------------------------------------------------
  Widget _buildStep1() {
    return SingleChildScrollView(
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
            decoration: _inputDecoration('Nhập tên cho nguồn tri thức này')
                .copyWith(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _nameError ? Colors.red : Colors.grey[300]!,
                ),
              ),
            ),
          ),
          if (_nameError) ...[
            const SizedBox(height: 4),
            const Text('Vui lòng nhập tên nguồn tri thức',
                style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
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
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2: Connection Details
  // ---------------------------------------------------------------------------
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DB type dropdown (acts as sync interval label in web)
          DropdownButtonFormField<String>(
            value: _crawlInterval == CrawlInterval.manual ? 'Thủ công' : 'Hàng ngày',
            items: const [
              DropdownMenuItem(value: 'Thủ công', child: Text('Thủ công')),
              DropdownMenuItem(value: 'Hàng ngày', child: Text('Hàng ngày')),
              DropdownMenuItem(value: 'Hàng tuần', child: Text('Hàng tuần')),
              DropdownMenuItem(value: 'Hàng tháng', child: Text('Hàng tháng')),
            ],
            onChanged: (_) {},
            decoration: InputDecoration(
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
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildFieldColumn(
                  'Địa chỉ host',
                  _hostController,
                  'Ví dụ: localhost hoặc 192.168.1.1',
                  required: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildFieldColumn(
                  'Cổng',
                  _portController,
                  'Tùy chọn, ví dụ: 5432',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildFieldColumn(
                  'Tên CSDL',
                  _dbController,
                  'Ví dụ: my_database',
                  required: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _dbType,
                      items: const [
                        DropdownMenuItem(
                            value: 'PostgreSQL', child: Text('PostgreSQL')),
                        DropdownMenuItem(
                            value: 'SQL Server', child: Text('SQL Server')),
                      ],
                      onChanged: (v) => setState(() => _dbType = v!),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFieldColumn(
                  'Tên người dùng',
                  _userController,
                  'Tên đăng nhập vào cơ sở dữ liệu',
                  required: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildPasswordColumn(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabel('Câu truy vấn SQL', required: true),
          const SizedBox(height: 8),
          TextField(
            controller: _sqlController,
            maxLines: 4,
            decoration: _inputDecoration(
                'Nhập câu truy vấn SQL để lấy dữ liệu từ CSDL'),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldColumn(
    String label,
    TextEditingController controller,
    String hint, {
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: required),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildPasswordColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Mật khẩu', required: true),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _inputDecoration('Mật khẩu kết nối cơ sở dữ liệu')
              .copyWith(
            suffixIcon: GestureDetector(
              onTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 18,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final isStep1 = _step == 1;
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
              onPressed: _isSaving
                  ? null
                  : (isStep1 ? _goToStep2 : _submit),
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
                  : Text(
                      isStep1 ? 'Tiếp theo' : 'Tiếp theo',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
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

  InputDecoration _inputDecoration(String hint) {
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
        borderSide: const BorderSide(color: Color(0xFF1A73E8)),
      ),
    );
  }

  void _goToStep2() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    setState(() => _step = 2);
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    final source = KnowledgeSource(
      id: '',
      name: _nameController.text.trim(),
      type: _dbType == 'SQL Server'
          ? KnowledgeSourceType.sqlServer
          : KnowledgeSourceType.postgresql,
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime.now(),
      crawlInterval: _crawlInterval,
      config: {
        'host': _hostController.text.trim(),
        'port': _portController.text.trim(),
        'database': _dbController.text.trim(),
        'username': _userController.text.trim(),
        'sql': _sqlController.text.trim(),
        'dbType': _dbType,
      },
    );
    await widget.store.addSource(source);
    setState(() => _isSaving = false);
    if (mounted) Navigator.pop(context);
  }
}
