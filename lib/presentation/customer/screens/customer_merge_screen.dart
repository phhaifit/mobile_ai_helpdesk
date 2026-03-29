import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CustomerMergeScreen extends StatefulWidget {
  final Customer customer;
  final CustomerStore store;
  final VoidCallback onBack;

  const CustomerMergeScreen({
    required this.customer,
    required this.store,
    required this.onBack,
    super.key,
  });

  @override
  State<CustomerMergeScreen> createState() => _CustomerMergeScreenState();
}

class _CustomerMergeScreenState extends State<CustomerMergeScreen> {
  Customer? _customer1;
  Customer? _customer2;

  String? _selectedNameId;
  final Set<String> _selectedEmails = {};
  final Set<String> _selectedPhones = {};
  final Set<String> _selectedZalos = {};
  final Set<String> _selectedMessengers = {};

  @override
  void initState() {
    super.initState();
    _customer1 = widget.customer;
    
    final others = widget.store.customers.where((c) => c.id != _customer1?.id).toList();
    if (others.isNotEmpty) {
      _customer2 = others.first;
    }
    _initializeSelections();
  }

  void _initializeSelections() {
    _selectedNameId = _customer1?.id;
    _selectedEmails.clear();
    _selectedPhones.clear();
    _selectedZalos.clear();
    _selectedMessengers.clear();

    if (_customer1 != null) {
      _selectedEmails.addAll(_customer1!.emails);
      _selectedPhones.addAll(_customer1!.phones);
      _selectedZalos.addAll(_customer1!.zalos);
      _selectedMessengers.addAll(_customer1!.messengers);
    }

    if (_customer2 != null) {
      _selectedEmails.addAll(_customer2!.emails);
      _selectedPhones.addAll(_customer2!.phones);
      _selectedZalos.addAll(_customer2!.zalos);
      _selectedMessengers.addAll(_customer2!.messengers);
    }
  }

  void _onCustomer1Changed(Customer? c) {
    setState(() {
      _customer1 = c;
      if (_customer1?.id == _customer2?.id) {
        _customer2 = null;
      }
      _initializeSelections();
    });
  }

  void _onCustomer2Changed(Customer? c) {
    setState(() {
      _customer2 = c;
      if (_customer2?.id == _customer1?.id) {
        _customer1 = null;
      }
      _initializeSelections();
    });
  }

  Future<void> _onMerge() async {
    if (_customer1 == null || _customer2 == null) return;

    final targetId = _customer1!.id;
    final sourceId = _customer2!.id;

    final nameToKeep = _selectedNameId == _customer2!.id ? _customer2!.fullName : _customer1!.fullName;
    // Cập nhật target customer trước
    final updatedTarget = _customer1!.copyWith(
      fullName: nameToKeep,
      emails: _selectedEmails.toList(),
      phones: _selectedPhones.toList(),
      zalos: _selectedZalos.toList(),
      messengers: _selectedMessengers.toList(),
    );

    final saved = await widget.store.saveCustomer(updatedTarget);
    if (!saved) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Có lỗi khi cập nhật thông tin.')));
      }
      return;
    }

    final success = await widget.store.mergeCustomers(
      targetId: targetId,
      sourceId: sourceId,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hợp nhất thành công')));
      widget.onBack();
    }
  }

  Widget _buildDropdown(Customer? selected, ValueChanged<Customer?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<Customer>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.store.customers.map((c) {
          return DropdownMenuItem<Customer>(
            value: c,
            child: Text(c.fullName, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckbox(IconData icon, String value, Set<String> selectionSet) {
    if (value.isEmpty) return const SizedBox.shrink();
    final isChecked = selectionSet.contains(value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (val) {
              setState(() {
                if (val ?? false) {
                  selectionSet.add(value);
                } else {
                  selectionSet.remove(value);
                }
              });
            },
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildCustomerColumn(Customer? customer, int customerIndex) {
    if (customer == null) {
      return const Center(child: Text('Vui lòng chọn khách hàng'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khách hàng $customerIndex',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          customerIndex == 1 ? _customer1 : _customer2,
          customerIndex == 1 ? _onCustomer1Changed : _onCustomer2Changed,
        ),
        const SizedBox(height: 16),
        const Text(
          'Tên khách hàng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(customer.fullName, overflow: TextOverflow.ellipsis),
                value: customer.id,
                // ignore: deprecated_member_use
                groupValue: _selectedNameId,
                contentPadding: EdgeInsets.zero,
                // ignore: deprecated_member_use
                onChanged: (val) {
                  setState(() => _selectedNameId = val);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Thông tin liên lạc',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        if (customer.emails.isNotEmpty) ...customer.emails.map((e) => _buildCheckbox(Icons.email, e, _selectedEmails)),
        if (customer.phones.isNotEmpty) ...customer.phones.map((p) => _buildCheckbox(Icons.phone, p, _selectedPhones)),
        if (customer.zalos.isNotEmpty) ...customer.zalos.map((z) => _buildCheckbox(Icons.chat_bubble, z, _selectedZalos)),
        if (customer.messengers.isNotEmpty) ...customer.messengers.map((m) => _buildCheckbox(Icons.message, m, _selectedMessengers)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45, // To act like a modal overlay
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hợp nhất thông tin khách hàng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCustomerColumn(_customer1, 1)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCustomerColumn(_customer2, 2)),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: widget.onBack,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 12),
                    Observer(
                      builder: (_) {
                        final canMerge = _customer1 != null && _customer2 != null && !widget.store.isSaving;
                        return ElevatedButton(
                          onPressed: canMerge ? _onMerge : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: widget.store.isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Hợp nhất khách hàng', style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
