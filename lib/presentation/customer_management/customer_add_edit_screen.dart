import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/entity/customer/customer.dart';
import 'store/customer_store.dart';

class CustomerAddEditScreen extends StatefulWidget {
  final CustomerStore store;
  final Customer? customer; // null = add mode

  const CustomerAddEditScreen({
    super.key,
    required this.store,
    this.customer,
  });

  @override
  State<CustomerAddEditScreen> createState() => _CustomerAddEditScreenState();
}

class _CustomerAddEditScreenState extends State<CustomerAddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _zaloCtrl;
  late final TextEditingController _messengerCtrl;
  final TextEditingController _tagCtrl = TextEditingController();

  String? _emailError;
  List<String> _tags = [];
  String? _selectedSegment;

  bool get _isEditMode => widget.customer != null;

  static const List<String> _segments = [
    'VIP',
    'Th\u01b0\u1eddng xuy\u00ean',
    'M\u1edbi',
    'Ti\u1ec1m n\u0103ng',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameCtrl = TextEditingController(text: c?.fullName ?? '');
    _emailCtrl = TextEditingController(text: c?.email ?? '');
    _phoneCtrl = TextEditingController(text: c?.phoneNumber ?? '');
    _zaloCtrl = TextEditingController(text: c?.zalo ?? '');
    _messengerCtrl = TextEditingController(text: c?.messenger ?? '');
    _tags = List.from(c?.tags ?? []);
    _selectedSegment = c?.segment;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _zaloCtrl.dispose();
    _messengerCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  // ─── Email validation ─────────────────────────────────────────────────────────
  String? _validateEmail(String value) {
    if (value.isEmpty) return null;
    final re = RegExp(r'^[\w\-.+]+@[a-zA-Z\d\-.]+\.[a-zA-Z]{2,}$');
    return re.hasMatch(value) ? null : 'Email kh\u00f4ng h\u1ee3p l\u1ec7';
  }

  // ─── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildSection(
              title: 'Th\u00f4ng tin c\u01a1 b\u1ea3n',
              children: [
                _buildTextField(
                  label: 'H\u1ecd t\u00ean',
                  controller: _nameCtrl,
                  hint: 'Nguy\u1ec5n V\u0103n A',
                  required: true,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vui l\u00f2ng nh\u1eadp h\u1ecd t\u00ean'
                      : null,
                ),
                const SizedBox(height: 12),
                _buildEmailField(),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'S\u1ed1 \u0111i\u1ec7n tho\u1ea1i',
                  controller: _phoneCtrl,
                  hint: '0xxxxxxxxx',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Zalo',
                  controller: _zaloCtrl,
                  hint: 'S\u1ed1/t\u00ean Zalo',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Messenger',
                  controller: _messengerCtrl,
                  hint: 'Link/t\u00ean Messenger',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSection(
              title: 'Ph\u00e2n lo\u1ea1i',
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Row(
          children: [
            SizedBox(width: 8),
            Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textPrimary),
            Text(
              'Quay l\u1ea1i',
              style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
      leadingWidth: 110,
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

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 6,
              offset: const Offset(0, 2)),
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
                  color: AppColors.textPrimary),
            ),
            if (required)
              const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
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

  // Email field with inline validation icon
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) => setState(() => _emailError = _validateEmail(v)),
          decoration: _inputDecoration('example@email.com').copyWith(
            errorText: _emailError,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _emailError != null ? Colors.red : Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _emailError != null ? Colors.red : AppColors.primaryBlue,
              ),
            ),
            suffixIcon: _emailCtrl.text.isNotEmpty
                ? Icon(
                    _emailError == null ? Icons.check_circle : Icons.error,
                    color: _emailError == null ? Colors.green : Colors.red,
                    size: 18,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ph\u00e2n kh\u00fac',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSegment,
              hint: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Ch\u1ecdn ph\u00e2n kh\u00fac',
                  style:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 8),
              isExpanded: true,
              borderRadius: BorderRadius.circular(8),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Kh\u00f4ng ch\u1ecdn',
                      style: TextStyle(fontSize: 13)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nh\u00e3n',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary),
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
                      label:
                          Text(tag, style: const TextStyle(fontSize: 11)),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => setState(() => _tags.remove(tag)),
                      backgroundColor:
                          AppColors.primaryBlue.withOpacity(0.1),
                      labelStyle:
                          const TextStyle(color: AppColors.primaryBlue),
                      side: const BorderSide(color: Colors.transparent),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  )
                  .toList(),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagCtrl,
                decoration: _inputDecoration('Th\u00eam nh\u00e3n...'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: AppColors.primaryBlue),
              onPressed: () {
                final tag = _tagCtrl.text.trim();
                if (tag.isNotEmpty && !_tags.contains(tag)) {
                  setState(() {
                    _tags.add(tag);
                    _tagCtrl.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _save,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: Text(
        _isEditMode ? 'L\u01b0u thay \u0111\u1ed5i' : 'Th\u00eam kh\u00e1ch h\u00e0ng',
        style:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: AppColors.backgroundGrey,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    if (_emailError != null) return;

    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final customer = Customer(
      id: widget.customer?.id ?? now,
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      phoneNumber:
          _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      zalo: _zaloCtrl.text.trim().isEmpty ? null : _zaloCtrl.text.trim(),
      messenger: _messengerCtrl.text.trim().isEmpty
          ? null
          : _messengerCtrl.text.trim(),
      tags: _tags,
      segment: _selectedSegment,
      isBlocked: widget.customer?.isBlocked ?? false,
      ticket: widget.customer?.ticket,
    );

    if (_isEditMode) {
      widget.store.updateCustomer(customer);
      Navigator.pop(context, customer);
    } else {
      widget.store.addCustomer(customer);
      Navigator.pop(context);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditMode
              ? '\u0110\u00e3 c\u1eadp nh\u1eadt kh\u00e1ch h\u00e0ng'
              : '\u0110\u00e3 th\u00eam kh\u00e1ch h\u00e0ng',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
