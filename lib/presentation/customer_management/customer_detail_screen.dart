import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/entity/customer/customer.dart';
import '../../domain/entity/customer/support_ticket.dart';
import 'store/customer_store.dart';
import 'customer_add_edit_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  final CustomerStore store;
  final bool showAppBar;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;

  const CustomerDetailScreen({
    super.key,
    required this.customer,
    required this.store,
    this.showAppBar = true,
    this.onBack,
    this.onEdit,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Customer _customer;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
  }

  // ─── Email validation ────────────────────────────────────────────────────────
  String? _validateEmail(String value) {
    if (value.isEmpty) return null;
    final re = RegExp(r'^[\w\-.+]+@[a-zA-Z\d\-.]+\.[a-zA-Z]{2,}$');
    return re.hasMatch(value) ? null : 'Email không hợp lệ';
  }

  // ─── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!widget.showAppBar) {
      // Desktop view: no appbar, show as content panel
      return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(),
            const SizedBox(height: 12),
            _buildCustomerCard(),
            const SizedBox(height: 12),
            _buildTagsSection(),
            const SizedBox(height: 12),
            _buildContactInfoSection(),
            if (_customer.ticket != null) ...[
              const SizedBox(height: 12),
              _buildSupportTickets(),
            ],
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomerCard(),
            const SizedBox(height: 12),
            _buildTagsSection(),
            const SizedBox(height: 12),
            _buildContactInfoSection(),
            if (_customer.ticket != null) ...[
              const SizedBox(height: 12),
              _buildSupportTickets(),
            ],
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
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 4),
            const Text(
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
      leadingWidth: 110,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết khách hàng',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Customer info card ───────────────────────────────────────────────────────
  Widget _buildCustomerCard() {
    return _card(
      child: Row(
        children: [
          _avatarCircle(_customer.fullName, 56),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _customer.fullName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: _editCustomer,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _createTicket,
            icon: const Icon(Icons.add, size: 14),
            label: const Text('Tạo phiếu', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tags section ─────────────────────────────────────────────────────────────
  Widget _buildTagsSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nhãn',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _showAddTagSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Thêm nhãn',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _customer.tags.isEmpty
              ? Text(
                  'Chưa có nhãn nào',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _customer.tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(fontSize: 11),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 14),
                          onDeleted: () => _removeTag(tag),
                          backgroundColor: AppColors.primaryBlue.withOpacity(
                            0.1,
                          ),
                          labelStyle: const TextStyle(
                            color: AppColors.primaryBlue,
                          ),
                          side: const BorderSide(color: Colors.transparent),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }

  // ─── Contact info section ─────────────────────────────────────────────────────
  Widget _buildContactInfoSection() {
    final hasEmail = _customer.email?.isNotEmpty == true;
    final hasPhone = _customer.phoneNumber?.isNotEmpty == true;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin liên lạc',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _showAddContactSheet,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.add, size: 16, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasEmail)
            _buildContactRow(
              icon: Icons.email_outlined,
              iconColor: Colors.red.shade400,
              label: 'Email',
              value: _customer.email!,
              onEdit: () => _editContactField('email', _customer.email!),
              onDelete: () => _deleteContactField('email'),
            ),
          if (hasEmail && hasPhone)
            Divider(height: 1, color: Colors.grey.shade100),
          if (hasPhone)
            _buildContactRow(
              icon: Icons.phone_outlined,
              iconColor: Colors.green.shade500,
              label: 'Điện thoại',
              value: _customer.phoneNumber!,
              onEdit: () => _editContactField('phone', _customer.phoneNumber!),
              onDelete: () => _deleteContactField('phone'),
            ),
          if (!hasEmail && !hasPhone)
            Text(
              'Chưa có thông tin liên lạc',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.grey),
            onPressed: onEdit,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
            onPressed: onDelete,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ],
      ),
    );
  }

  // ─── Support tickets section ──────────────────────────────────────────────────
  Widget _buildSupportTickets() {
    final ticket = _customer.ticket!;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phiếu hỗ trợ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildTicketCard(ticket),
        ],
      ),
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.onlineGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  size: 14,
                  color: AppColors.onlineGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ticket.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tạo ngày: ${_formatDate(ticket.createdAt)}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _badge(_statusLabel(ticket.status), _statusColor(ticket.status)),
              const SizedBox(width: 8),
              _badge(
                _priorityLabel(ticket.priority),
                _priorityColor(ticket.priority),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }

  Widget _avatarCircle(String name, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryBlue, width: 2),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _statusLabel(TicketStatus s) {
    switch (s) {
      case TicketStatus.pending:
        return 'Chờ xử lý';
      case TicketStatus.inProgress:
        return 'Đang hỗ trợ';
      case TicketStatus.resolved:
        return 'Đã giải quyết';
      case TicketStatus.waitingForInfo:
        return 'Chờ thông tin';
      case TicketStatus.aiProcessing:
        return 'AI xử lý';
    }
  }

  Color _statusColor(TicketStatus s) {
    switch (s) {
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.inProgress:
        return Colors.green;
      case TicketStatus.resolved:
        return Colors.blue;
      case TicketStatus.waitingForInfo:
        return Colors.purple;
      case TicketStatus.aiProcessing:
        return Colors.teal;
    }
  }

  String _priorityLabel(TicketPriority p) {
    switch (p) {
      case TicketPriority.low:
        return 'Thấp';
      case TicketPriority.medium:
        return 'Trung bình';
      case TicketPriority.high:
        return 'Cao';
    }
  }

  Color _priorityColor(TicketPriority p) {
    switch (p) {
      case TicketPriority.low:
        return Colors.grey;
      case TicketPriority.medium:
        return Colors.orange;
      case TicketPriority.high:
        return Colors.red;
    }
  }

  // ─── Actions ──────────────────────────────────────────────────────────────────
  void _editCustomer() {
    // Desktop: use callback
    if (widget.onEdit != null) {
      widget.onEdit!();
      return;
    }

    // Mobile: push edit screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CustomerAddEditScreen(store: widget.store, customer: _customer),
      ),
    ).then((updated) {
      if (updated is Customer) setState(() => _customer = updated);
    });
  }

  void _createTicket() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng tạo phiếu sắp ra mắt')),
    );
  }

  void _showAddTagSheet() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dragHandle(),
            const SizedBox(height: 16),
            const Text(
              'Thêm nhãn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            // Existing tags available
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.store.allAvailableTags
                  .where((t) => !_customer.tags.contains(t))
                  .map(
                    (tag) => ActionChip(
                      label: Text(tag, style: const TextStyle(fontSize: 12)),
                      onPressed: () {
                        _addTag(tag);
                        Navigator.pop(context);
                      },
                      backgroundColor: AppColors.backgroundGrey,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: 'Tạo nhãn mới...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (ctrl.text.trim().isNotEmpty) {
                    _addTag(ctrl.text.trim());
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Thêm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addTag(String tag) {
    final updated = _customer.copyWith(tags: [..._customer.tags, tag]);
    setState(() => _customer = updated);
    widget.store.updateCustomer(updated);
  }

  void _removeTag(String tag) {
    final updated = _customer.copyWith(
      tags: _customer.tags.where((t) => t != tag).toList(),
    );
    setState(() => _customer = updated);
    widget.store.updateCustomer(updated);
  }

  void _showAddContactSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AddContactSheet(
        onAdd: (type, value) {
          final updated = type == 'email'
              ? _customer.copyWith(email: value)
              : _customer.copyWith(phoneNumber: value);
          setState(() => _customer = updated);
          widget.store.updateCustomer(updated);
        },
      ),
    );
  }

  void _editContactField(String field, String currentValue) {
    final ctrl = TextEditingController(text: currentValue);
    final isEmail = field == 'email';
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dragHandle(),
              const SizedBox(height: 16),
              Text(
                isEmail ? 'Chỉnh sửa Email' : 'Chỉnh sửa Số điện thoại',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                keyboardType: isEmail
                    ? TextInputType.emailAddress
                    : TextInputType.phone,
                onChanged: (v) {
                  if (isEmail) {
                    setModalState(() => errorText = _validateEmail(v));
                  }
                },
                decoration: InputDecoration(
                  hintText: isEmail ? 'example@email.com' : '0xxxxxxxxx',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: errorText,
                  suffixIcon: isEmail && ctrl.text.isNotEmpty
                      ? Icon(
                          errorText == null ? Icons.check_circle : Icons.error,
                          color: errorText == null ? Colors.green : Colors.red,
                          size: 18,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final v = ctrl.text.trim();
                    if (isEmail && errorText != null) return;
                    final updated = isEmail
                        ? _customer.copyWith(email: v)
                        : _customer.copyWith(phoneNumber: v);
                    setState(() => _customer = updated);
                    widget.store.updateCustomer(updated);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteContactField(String field) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xóa ${field == 'email' ? 'Email' : 'Số điện thoại'}'),
        content: const Text('Bạn có chắc muốn xóa thông tin này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final updated = field == 'email'
                  ? _customer.copyWith(email: '')
                  : _customer.copyWith(phoneNumber: '');
              setState(() => _customer = updated);
              widget.store.updateCustomer(updated);
              Navigator.pop(context);
            },
            child: Text('Xóa', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }

  Widget _dragHandle() => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

// ─── Add contact bottom sheet ─────────────────────────────────────────────────
class _AddContactSheet extends StatefulWidget {
  final Function(String type, String value) onAdd;
  const _AddContactSheet({required this.onAdd});

  @override
  State<_AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<_AddContactSheet> {
  String _type = 'email';
  final TextEditingController _ctrl = TextEditingController();
  String? _errorText;

  String? _validateEmail(String v) {
    if (v.isEmpty) return null;
    final re = RegExp(r'^[\w\-.+]+@[a-zA-Z\d\-.]+\.[a-zA-Z]{2,}$');
    return re.hasMatch(v) ? null : 'Email kh\u00f4ng h\u1ee3p l\u1ec7';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Thêm thông tin liên lạc',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'email', label: Text('Email')),
              ButtonSegment(value: 'phone', label: Text('Điện thoại')),
            ],
            selected: {_type},
            onSelectionChanged: (v) => setState(() {
              _type = v.first;
              _ctrl.clear();
              _errorText = null;
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            keyboardType: _type == 'email'
                ? TextInputType.emailAddress
                : TextInputType.phone,
            onChanged: (v) {
              if (_type == 'email') {
                setState(() => _errorText = _validateEmail(v));
              }
            },
            decoration: InputDecoration(
              hintText: _type == 'email' ? 'example@email.com' : '0xxxxxxxxx',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: _errorText,
              suffixIcon: _type == 'email' && _ctrl.text.isNotEmpty
                  ? Icon(
                      _errorText == null ? Icons.check_circle : Icons.error,
                      color: _errorText == null ? Colors.green : Colors.red,
                      size: 18,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final v = _ctrl.text.trim();
                if (v.isEmpty || (_type == 'email' && _errorText != null))
                  return;
                widget.onAdd(_type, v);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Thêm', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
