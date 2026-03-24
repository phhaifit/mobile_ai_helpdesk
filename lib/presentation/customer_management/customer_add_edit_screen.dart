import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../domain/entity/customer/customer.dart';
import 'store/customer_store.dart';

class CustomerAddEditScreen extends StatefulWidget {
  final CustomerStore store;
  final Customer? customer; // null = add mode
  final bool showAppBar;
  final VoidCallback? onBack;

  const CustomerAddEditScreen({
    required this.store,
    super.key,
    this.customer,
    this.showAppBar = true,
    this.onBack,
  });

  @override
  State<CustomerAddEditScreen> createState() => _CustomerAddEditScreenState();
}

class _CustomerAddEditScreenState extends State<CustomerAddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;

  // Contact info stored as map: {"type": "email", "value": "..."}
  final List<Map<String, String>> _contactInfo = [];

  List<String> _tags = [];
  String? _selectedSegment;

  bool get _isEditMode => widget.customer != null;

  static const List<String> _segments = [
    'VIP',
    'Thường xuyên',
    'Mới',
    'Tiềm năng',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameCtrl = TextEditingController(text: c?.fullName ?? '');

    // Initialize contact info from existing customer
    if (c != null) {
      if (c.email?.isNotEmpty ?? false) {
        _contactInfo.add({'type': 'Email', 'value': c.email!});
      }
      if (c.phoneNumber?.isNotEmpty ?? false) {
        _contactInfo.add({'type': 'Phone', 'value': c.phoneNumber!});
      }
      if (c.zalo?.isNotEmpty ?? false) {
        _contactInfo.add({'type': 'Zalo', 'value': c.zalo!});
      }
      if (c.messenger?.isNotEmpty ?? false) {
        _contactInfo.add({'type': 'Messenger', 'value': c.messenger!});
      }
    }

    _tags = List.from(c?.tags ?? []);
    _selectedSegment = c?.segment;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAppBar) {
      // Desktop view: no appbar, show as content panel
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(),
              const SizedBox(height: 12),
              _buildSection(
                title: 'Thông tin cơ bản',
                children: [
                  _buildTextField(
                    label: 'Họ tên',
                    controller: _nameCtrl,
                    hint: 'Nguyễn Văn A',
                    required: true,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Vui lòng nhập họ tên'
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSection(
                title: 'Thông tin liên lạc',
                children: [_buildContactInfoSection()],
              ),
              const SizedBox(height: 12),
              _buildSection(
                title: 'Phân loại',
                children: [
                  _buildSegmentDropdown(),
                  const SizedBox(height: 12),
                  _buildTagsInput(),
                ],
              ),
              const SizedBox(height: 20),
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildSection(
              title: 'Thông tin cơ bản',
              children: [
                _buildTextField(
                  label: 'Họ tên',
                  controller: _nameCtrl,
                  hint: 'Nguyễn Văn A',
                  required: true,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vui lòng nhập họ tên'
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection(
              title: 'Thông tin liên lạc',
              children: [_buildContactInfoSection()],
            ),
            const SizedBox(height: 12),
            _buildSection(
              title: 'Phân loại',
              children: [
                _buildSegmentDropdown(),
                const SizedBox(height: 12),
                _buildTagsInput(),
              ],
            ),
            const SizedBox(height: 20),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: widget.onBack != null
            ? () => widget.onBack!()
            : () => Navigator.pop(context),
        child: const Row(
          children: [
            Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textPrimary),
            SizedBox(width: 4),
            Text(
              'Quay lại',
              style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Row(
          children: [
            SizedBox(width: 25),
            Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textPrimary),
          ],
        ),
      ),
      title: Text(
        _isEditMode
            ? 'Ch\u1ec9nh s\u1eeda kh\u00e1ch h\u00e0ng'
            : 'Th\u00eam kh\u00e1ch h\u00e0ng',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Divider(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool required = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  // ─── Contact info section ────────────────────────────────────────────────────
  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đã thêm: ${_contactInfo.length} thông tin',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            ElevatedButton.icon(
              onPressed: _showAddContactModal,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Thêm', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_contactInfo.isEmpty)
          Text(
            'Chưa có thông tin liên lạc',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          )
        else
          Column(
            children: _contactInfo.asMap().entries.map((entry) {
              final idx = entry.key;
              final info = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info['type']!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              info['value']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => setState(() {
                          _contactInfo.removeAt(idx);
                        }),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSegmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phân khúc',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSegment,
              hint: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Chọn phân khúc',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 8),
              isExpanded: true,
              borderRadius: BorderRadius.circular(8),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Không chọn', style: TextStyle(fontSize: 13)),
                ),
                ..._segments.map(
                  (s) => DropdownMenuItem<String>(
                    value: s,
                    child: Text(s, style: const TextStyle(fontSize: 13)),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _selectedSegment = v),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsInput() {
    return StatefulBuilder(
      builder: (context, setTagState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhãn',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          if (_tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () => setTagState(() => _tags.remove(tag)),
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        labelStyle: const TextStyle(
                          color: AppColors.primaryBlue,
                        ),
                        side: const BorderSide(color: Colors.transparent),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    )
                    .toList(),
              ),
            ),
          Observer(
            builder: (_) {
              final availableTags = widget.store.allAvailableTags
                  .where((t) => !_tags.contains(t))
                  .toList();
              return Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              'Thêm nhãn',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(8),
                          items: availableTags
                              .map(
                                (tag) => DropdownMenuItem<String>(
                                  value: tag,
                                  child: Text(
                                    tag,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (selectedTag) {
                            if (selectedTag != null &&
                                !_tags.contains(selectedTag)) {
                              setTagState(() => _tags.add(selectedTag));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _save,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: Text(
        _isEditMode
            ? 'L\u01b0u thay \u0111\u1ed5i'
            : 'Th\u00eam kh\u00e1ch h\u00e0ng',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: AppColors.backgroundGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    // Validate at least 1 contact info
    if (_contactInfo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng thêm tối thiểu 1 thông tin liên lạc'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Extract contact info from list
    String? email, phoneNumber, zalo, messenger;
    for (final info in _contactInfo) {
      switch (info['type']) {
        case 'Email':
          email = info['value'];
          break;
        case 'Phone':
          phoneNumber = info['value'];
          break;
        case 'Zalo':
          zalo = info['value'];
          break;
        case 'Messenger':
          messenger = info['value'];
          break;
      }
    }

    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final customer = Customer(
      id: widget.customer?.id ?? now,
      fullName: _nameCtrl.text.trim(),
      email: email,
      phoneNumber: phoneNumber,
      zalo: zalo,
      messenger: messenger,
      tags: _tags,
      segment: _selectedSegment,
      isBlocked: widget.customer?.isBlocked ?? false,
      ticket: widget.customer?.ticket,
    );

    if (_isEditMode) {
      widget.store.updateCustomer(customer);
    } else {
      widget.store.addCustomer(customer);
    }

    // Desktop: use callback to go back
    if (widget.onBack != null) {
      widget.onBack!();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode ? 'Đã cập nhật khách hàng' : 'Đã thêm khách hàng',
          ),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    // Mobile: pop with result
    if (_isEditMode) {
      Navigator.pop(context, customer);
    } else {
      Navigator.pop(context);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditMode ? 'Đã cập nhật khách hàng' : 'Đã thêm khách hàng',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddContactModal() {
    final ctrlInput = TextEditingController();
    String contactType = 'Email';
    String? emailError;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Thêm liên hệ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: contactType,
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(8),
                    items: const [
                      DropdownMenuItem(
                        value: 'Email',
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Email', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Phone',
                        child: Row(
                          children: [
                            Icon(Icons.phone_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Điện thoại', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Zalo',
                        child: Row(
                          children: [
                            Icon(Icons.chat_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Zalo', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Messenger',
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 16),
                            SizedBox(width: 8),
                            Text('Messenger', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) => setDialogState(() {
                      contactType = value ?? 'Email';
                      ctrlInput.clear();
                      emailError = null;
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              TextField(
                controller: ctrlInput,
                onChanged: (v) {
                  if (contactType == 'Email') {
                    setDialogState(() => emailError = _validateEmail(v));
                  }
                },
                keyboardType: contactType == 'Email'
                    ? TextInputType.emailAddress
                    : contactType == 'Phone'
                    ? TextInputType.phone
                    : TextInputType.text,
                decoration: InputDecoration(
                  hintText: contactType == 'Email'
                      ? 'example@email.com'
                      : contactType == 'Phone'
                      ? '0xxxxxxxxx'
                      : contactType == 'Zalo'
                      ? 'Số/tên Zalo'
                      : 'Tên Messenger',
                  filled: true,
                  fillColor: AppColors.backgroundGrey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  errorText: emailError,
                  suffixIcon:
                      contactType == 'Email' && ctrlInput.text.isNotEmpty
                      ? Icon(
                          emailError == null ? Icons.check_circle : Icons.error,
                          color: emailError == null ? Colors.green : Colors.red,
                          size: 18,
                        )
                      : null,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = ctrlInput.text.trim();
                if (value.isEmpty) return;
                if (contactType == 'Email' && emailError != null) return;

                setState(() {
                  _contactInfo.add({'type': contactType, 'value': value});
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return null;
    final re = RegExp(r'^[\w\-.+]+@[a-zA-Z\d\-.]+\.[a-zA-Z]{2,}$');
    return re.hasMatch(value) ? null : 'Email không hợp lệ';
  }
}
