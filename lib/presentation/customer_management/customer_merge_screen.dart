import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/entity/customer/customer.dart';
import 'store/customer_store.dart';

class CustomerMergeScreen extends StatefulWidget {
  final CustomerStore store;

  const CustomerMergeScreen({super.key, required this.store});

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
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: AppColors.textPrimary),
          onPressed: _step == 0 ? () => Navigator.pop(context) : _goBack,
        ),
        title: const Text(
          'H\u1ee3p nh\u1ea5t kh\u00e1ch h\u00e0ng',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: _step == 2 ? _buildPreview() : _buildSelectStep(),
          ),
        ],
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
          _stepChip(0, 'Ch\u1ecdn ch\u00ednh'),
          Expanded(
              child: Container(height: 1, color: Colors.grey.shade300)),
          _stepChip(1, 'Ch\u1ecdn ph\u1ee5'),
          Expanded(
              child: Container(height: 1, color: Colors.grey.shade300)),
          _stepChip(2, 'X\u00e1c nh\u1eadn'),
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
                    ? 'Ch\u1ecdn kh\u00e1ch h\u00e0ng ch\u00ednh (gi\u1eef l\u1ea1i)'
                    : 'Ch\u1ecdn kh\u00e1ch h\u00e0ng \u0111\u01b0\u1ee3c h\u1ee3p nh\u1ea5t v\u00e0o ch\u00ednh',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'T\u00ecm ki\u1ebfm...',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: Icon(Icons.search,
                      color: Colors.grey.shade400, size: 18),
                  filled: true,
                  fillColor: AppColors.backgroundGrey,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.primaryBlue),
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
                    'Kh\u00f4ng t\u00ecm th\u1ea5y kh\u00e1ch h\u00e0ng',
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey.shade500),
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
                    Text(c.phoneNumber!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  if (c.email?.isNotEmpty == true)
                    Text(c.email!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
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
            'Xem tr\u01b0\u1edbc k\u1ebft qu\u1ea3 h\u1ee3p nh\u1ea5t',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Two cards side by side
          Row(
            children: [
              Expanded(
                  child: _mergeCard(
                      'Ch\u00ednh (gi\u1eef l\u1ea1i)', primary, Colors.green)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.merge_type,
                    color: AppColors.primaryBlue, size: 28),
              ),
              Expanded(
                  child: _mergeCard(
                      'H\u1ee3p nh\u1ea5t v\u00e0o', secondary, Colors.orange)),
            ],
          ),
          const SizedBox(height: 16),
          // Result preview card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.preview_outlined,
                        size: 16, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'K\u1ebft qu\u1ea3 sau h\u1ee3p nh\u1ea5t',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _previewRow(Icons.person_outline, 'T\u00ean',
                    primary.fullName),
                if (mergedEmail?.isNotEmpty == true)
                  _previewRow(
                      Icons.email_outlined, 'Email', mergedEmail!),
                if (mergedPhone?.isNotEmpty == true)
                  _previewRow(Icons.phone_outlined,
                      '\u0110i\u1ec7n tho\u1ea1i', mergedPhone!),
                if (mergedTags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.label_outline,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: mergedTags
                              .map(
                                (t) => Chip(
                                  label: Text(t,
                                      style:
                                          const TextStyle(fontSize: 10)),
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
          // Warning banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange.shade600, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'H\u00e0nh \u0111\u1ed9ng n\u00e0y kh\u00f4ng th\u1ec3 ho\u00e0n t\u00e1c. Kh\u00e1ch h\u00e0ng ph\u1ee5 s\u1ebd b\u1ecb x\u00f3a.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.orange.shade800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _confirmMerge,
            icon: const Icon(Icons.merge_type, size: 18),
            label: const Text(
              'X\u00e1c nh\u1eadn h\u1ee3p nh\u1ea5t',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
          Text(title,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600)),
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
          Text('$label: ',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
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

  void _confirmMerge() {
    widget.store.mergeCustomers(_primary!.id, _secondary!.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('\u0110\u00e3 h\u1ee3p nh\u1ea5t kh\u00e1ch h\u00e0ng'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
