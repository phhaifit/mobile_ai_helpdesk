import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/customer/tag.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/constants/colors.dart';

class CustomerAddEditScreen extends StatefulWidget {
  final Customer? customer;
  final CustomerStore store;
  final VoidCallback onBack;

  const CustomerAddEditScreen({
    super.key,
    this.customer,
    required this.store,
    required this.onBack,
  });

  @override
  State<CustomerAddEditScreen> createState() => _CustomerAddEditScreenState();
}

enum ContactType { email, phone, zalo, messenger }

class ContactField {
  final ContactType type;
  final TextEditingController controller;
  ContactField(this.type, String initialValue) : controller = TextEditingController(text: initialValue);
}

class _CustomerAddEditScreenState extends State<CustomerAddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  final List<ContactField> _contacts = [];
  late List<Tag> _selectedTags;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.customer?.fullName ?? '');
    
    if (widget.customer != null) {
      for (var e in widget.customer!.emails) { _contacts.add(ContactField(ContactType.email, e)); }
      for (var p in widget.customer!.phones) { _contacts.add(ContactField(ContactType.phone, p)); }
      for (var z in widget.customer!.zalos) { _contacts.add(ContactField(ContactType.zalo, z)); }
      for (var m in widget.customer!.messengers) { _contacts.add(ContactField(ContactType.messenger, m)); }
    } else {
      _contacts.add(ContactField(ContactType.phone, ''));
    }

    _selectedTags = widget.customer?.tags.toList() ?? [];
  }

  bool _isValidEmail(String email) {
    if (email.isEmpty) return true;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _save(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final emails = _contacts.where((c) => c.type == ContactType.email && c.controller.text.trim().isNotEmpty).map((c) => c.controller.text.trim()).toList();
      final phones = _contacts.where((c) => c.type == ContactType.phone && c.controller.text.trim().isNotEmpty).map((c) => c.controller.text.trim()).toList();
      final zalos = _contacts.where((c) => c.type == ContactType.zalo && c.controller.text.trim().isNotEmpty).map((c) => c.controller.text.trim()).toList();
      final messengers = _contacts.where((c) => c.type == ContactType.messenger && c.controller.text.trim().isNotEmpty).map((c) => c.controller.text.trim()).toList();

      final newCustomer = Customer(
        id: widget.customer?.id ?? '', 
        fullName: _nameCtrl.text,
        emails: emails,
        phones: phones,
        zalos: zalos,
        messengers: messengers,
        createdAt: widget.customer?.createdAt ?? DateTime.now(),
        tags: _selectedTags,
      );

      final success = await widget.store.saveCustomer(newCustomer);
      if (!context.mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Lưu thông tin khách hàng thành công!'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
        widget.onBack();
      } else if (widget.store.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.store.errorMessage!),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _showAddTagDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm thẻ mới (Tag)', style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: 'Tên thẻ', 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey.shade50
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          Observer(
            builder: (_) {
              if (widget.store.isSaving) return const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
              return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                onPressed: () async {
                  if (ctrl.text.trim().isEmpty) return;
                  final newTag = await widget.store.createNewTag(ctrl.text.trim());
                  if (newTag != null) {
                    setState(() {
                      _selectedTags.add(newTag);
                    });
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Thêm', style: TextStyle(color: Colors.white)),
              );
            }
          )
        ],
      )
    );
  }

  String _getContactLabel(ContactType type) {
    switch (type) {
      case ContactType.email: return 'Email';
      case ContactType.phone: return 'Số điện thoại';
      case ContactType.zalo: return 'Zalo';
      case ContactType.messenger: return 'Messenger';
    }
  }

  IconData _getContactIcon(ContactType type) {
    switch (type) {
      case ContactType.email: return Icons.email_outlined;
      case ContactType.phone: return Icons.phone_outlined;
      case ContactType.zalo: return Icons.chat_bubble_outline;
      case ContactType.messenger: return Icons.message_outlined;
    }
  }

  void _showAddContactModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Chọn loại liên hệ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                onTap: () => _addContact(ContactType.email),
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Số điện thoại'),
                onTap: () => _addContact(ContactType.phone),
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text('Zalo'),
                onTap: () => _addContact(ContactType.zalo),
              ),
              ListTile(
                leading: const Icon(Icons.message_outlined),
                title: const Text('Messenger'),
                onTap: () => _addContact(ContactType.messenger),
              ),
            ],
          ),
        );
      }
    );
  }

  void _addContact(ContactType type) {
    Navigator.pop(context);
    setState(() {
      _contacts.add(ContactField(type, ''));
    });
  }

  InputDecoration _buildInputDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey.shade500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: widget.onBack),
        title: Text(widget.customer == null ? 'Thêm khách hàng' : 'Sửa khách hàng', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: _buildInputDeco('Họ tên *', Icons.person_outline),
              validator: (v) => v!.isEmpty ? 'Vui lòng nhập họ tên' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thông tin liên hệ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
                  onPressed: _showAddContactModal,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Thêm liên hệ'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._contacts.asMap().entries.map((entry) {
              final idx = entry.key;
              final contact = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: contact.controller,
                        decoration: _buildInputDeco(_getContactLabel(contact.type), _getContactIcon(contact.type)),
                        keyboardType: contact.type == ContactType.email ? TextInputType.emailAddress : (contact.type == ContactType.phone ? TextInputType.phone : null),
                        validator: contact.type == ContactType.email 
                          ? (v) => !_isValidEmail(v ?? '') ? 'Email không hợp lệ' : null 
                          : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          final c = _contacts.removeAt(idx);
                          c.controller.dispose();
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Thẻ (Tags)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
                        onPressed: () => _showAddTagDialog(context),
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        label: const Text('Thẻ mới'),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Observer(
                    builder: (_) {
                      if (widget.store.availableTags.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Không có thẻ nào để chọn.', style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
                        );
                      }
                      return Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: widget.store.availableTags.map((tag) {
                          final isSelected = _selectedTags.any((t) => t.id == tag.id);
                          return FilterChip(
                            label: Text(tag.name, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.removeWhere((t) => t.id == tag.id);
                                }
                              });
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: AppColors.primaryBlue,
                            checkmarkColor: Colors.white,
                            side: BorderSide(color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Observer(builder: (_) {
              return widget.store.isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _save(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Lưu thông tin',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    for (var c in _contacts) {
      c.controller.dispose();
    }
    super.dispose();
  }
}
