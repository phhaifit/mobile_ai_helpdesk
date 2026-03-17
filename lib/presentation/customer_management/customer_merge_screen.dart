import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/entity/customer/customer.dart';
import 'store/customer_store.dart';

class CustomerMergeScreen extends StatefulWidget {
  final CustomerStore store;
  final bool showAppBar;
  final VoidCallback? onBack;

  const CustomerMergeScreen({
    super.key,
    required this.store,
    this.showAppBar = true,
    this.onBack,
  });

  @override
  State<CustomerMergeScreen> createState() => _CustomerMergeScreenState();
}

class _CustomerMergeScreenState extends State<CustomerMergeScreen> {
  Customer? _primary;
  Customer? _secondary;

  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  /// Current step: 0 = pick primary, 1 = pick secondary, 2 = preview/confirm
  int _step = 0;

  List<Customer> get _activeCustomers =>
      widget.store.customers.where((c) => !c.isBlocked).toList();

  List<Customer> get _filtered {
    final q = _searchQuery.toLowerCase();
    return _activeCustomers.where((c) {
      if (_step == 1 && c.id == _primary?.id) return false;
      return q.isEmpty ||
          c.fullName.toLowerCase().contains(q) ||
          (c.phoneNumber?.contains(q) ?? false) ||
          (c.email?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAppBar) {
      return Column(
        children: [
          _buildBackButton(),
          const SizedBox(height: 8),
          _buildStepIndicator(),
          Expanded(child: _step == 2 ? _buildPreview() : _buildSelectStep()),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.textPrimary,
          ),
          onPressed: _step == 0 ? () => Navigator.pop(context) : _goBack,
        ),
        title: const Text(
          'Hợp nhất khách hàng',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(child: _step == 2 ? _buildPreview() : _buildSelectStep()),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: _step == 0
            ? (widget.onBack != null
                  ? () => widget.onBack!()
                  : () => Navigator.pop(context))
            : _goBack,
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

  // ─── Step indicator ───────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Row(
        children: [
          _stepChip(0, 'Chọn chính'),
          Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
          _stepChip(1, 'Chọn phụ'),
          Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
          _stepChip(2, 'Xác nhận'),
        ],
      ),
    );
  }

  Widget _stepChip(int idx, String label) {
    final active = _step >= idx;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryBlue : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${idx + 1}',
              style: TextStyle(
                color: active ? Colors.white : Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? AppColors.primaryBlue : Colors.grey.shade500,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // ─── Select step (0 & 1) ──────────────────────────────────────────────────────
  Widget _buildSelectStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _step == 0
                    ? 'Chọn khách hàng chính (giữ lại)'
                    : 'Chọn khách hàng được hợp nhất vào chính',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundGrey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Text(
                    'Không tìm thấy khách hàng',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final c = _filtered[i];
                    return _buildSelectableCard(c);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSelectableCard(Customer c) {
    return InkWell(
      onTap: () => _selectCustomer(c),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            _avatar(c, 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.fullName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (c.phoneNumber?.isNotEmpty == true)
                    Text(
                      c.phoneNumber!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  if (c.email?.isNotEmpty == true)
                    Text(
                      c.email!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // ─── Preview / confirm step ───────────────────────────────────────────────────
  Widget _buildPreview() {
    final primary = _primary!;
    final secondary = _secondary!;

    final mergedEmail = primary.email ?? secondary.email;
    final mergedPhone = primary.phoneNumber ?? secondary.phoneNumber;
    final mergedTags = {...primary.tags, ...secondary.tags}.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xem trước kết quả hợp nhất',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _mergeCard('Chính (giữ lại)', primary, Colors.green),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.merge_type,
                  color: AppColors.primaryBlue,
                  size: 28,
                ),
              ),
              Expanded(
                child: _mergeCard('Hợp nhất vào', secondary, Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.preview_outlined,
                      size: 16,
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Kết quả sau hợp nhất',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _previewRow(Icons.person_outline, 'Tên', primary.fullName),
                if (mergedEmail?.isNotEmpty == true)
                  _previewRow(Icons.email_outlined, 'Email', mergedEmail!),
                if (mergedPhone?.isNotEmpty == true)
                  _previewRow(Icons.phone_outlined, 'Điện thoại', mergedPhone!),
                if (mergedTags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.label_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: mergedTags
                              .map(
                                (t) => Chip(
                                  label: Text(
                                    t,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade600,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hành động này không thể hoàn tác. Khách hàng phụ sẽ bị xóa.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _handleConfirmMerge(),
            icon: const Icon(Icons.merge_type, size: 18),
            label: const Text(
              'Xác nhận hợp nhất',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _mergeCard(String title, Customer c, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _avatar(c, 44),
          const SizedBox(height: 8),
          Text(
            c.fullName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _previewRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(Customer c, double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          c.fullName.isNotEmpty ? c.fullName[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }

  // ─── Navigation helpers ───────────────────────────────────────────────────────
  void _selectCustomer(Customer c) {
    setState(() {
      if (_step == 0) {
        _primary = c;
        _step = 1;
        _searchCtrl.clear();
        _searchQuery = '';
      } else {
        _secondary = c;
        _step = 2;
      }
    });
  }

  void _goBack() {
    setState(() {
      if (_step == 2) {
        _step = 1;
        _secondary = null;
      } else {
        _step = 0;
        _primary = null;
        _searchCtrl.clear();
        _searchQuery = '';
      }
    });
  }

  void _handleConfirmMerge() {
    // Check if we can navigate
    if (widget.showAppBar) {
      // Mobile mode: use Navigator
      _performMergeWithNavigator();
    } else {
      // Desktop mode: use callback
      _performMergeWithCallback();
    }
  }

  Future<void> _performMergeWithNavigator() async {
    if (!mounted) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          const Center(child: CircularProgressIndicator()),
    );

    try {
      print('Merging customers: ${_primary!.id} and ${_secondary!.id}');

      // Perform the merge operation
      await widget.store.mergeCustomers(_primary!.id, _secondary!.id);

      print('Merge completed successfully');

      // Dismiss loading dialog
      if (mounted) {
        Navigator.of(context).pop(); // Pop the dialog
      }

      // Wait a bit for dialog to dismiss
      await Future.delayed(const Duration(milliseconds: 300));

      // Pop the merge screen and return to list
      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }

      // Show success message (after screens are popped)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã hợp nhất khách hàng thành công'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Merge error: $e');
      print('Stack trace: $stackTrace');

      // Dismiss loading dialog
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi hợp nhất: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _performMergeWithCallback() async {
    if (!mounted) return;

    try {
      print(
        'Merging customers (desktop mode): ${_primary!.id} and ${_secondary!.id}',
      );

      // Perform the merge operation
      await widget.store.mergeCustomers(_primary!.id, _secondary!.id);

      print('Merge completed successfully');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã hợp nhất khách hàng thành công'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Call back to parent to update state
      if (widget.onBack != null) {
        widget.onBack!();
      }
    } catch (e, stackTrace) {
      print('Merge error: $e');
      print('Stack trace: $stackTrace');

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi hợp nhất: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
