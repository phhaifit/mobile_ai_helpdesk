import 'package:flutter/material.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:get_it/get_it.dart';

import 'customer_list_screen.dart';
import 'customer_detail_screen.dart';
import 'customer_add_edit_screen.dart';
import 'customer_merge_screen.dart';

enum CustomerViewInfo { list, detail, add, edit, merge }

class CustomerMainScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const CustomerMainScreen({super.key, required this.onMenuTap});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  late CustomerStore _store;
  CustomerViewInfo _currentView = CustomerViewInfo.list;
  Customer? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _store = GetIt.instance<CustomerStore>();
  }

  void _showList() {
    setState(() {
      _currentView = CustomerViewInfo.list;
      _selectedCustomer = null;
    });
  }

  void _showDetail(Customer customer) {
    setState(() {
      _currentView = CustomerViewInfo.detail;
      _selectedCustomer = customer;
    });
  }

  void _showAdd() {
    setState(() {
      _currentView = CustomerViewInfo.add;
    });
  }

  void _showEdit() {
    setState(() {
      _currentView = CustomerViewInfo.edit;
    });
  }

  void _showMerge() {
    setState(() {
      _currentView = CustomerViewInfo.merge;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentView) {
      case CustomerViewInfo.detail:
        return CustomerDetailScreen(
          customer: _selectedCustomer!,
          store: _store,
          onBack: _showList,
          onEdit: _showEdit,
          onMerge: _showMerge,
        );
      case CustomerViewInfo.add:
        return CustomerAddEditScreen(
          store: _store,
          onBack: _showList,
        );
      case CustomerViewInfo.edit:
        return CustomerAddEditScreen(
          customer: _selectedCustomer,
          store: _store,
          onBack: _showList,
        );
      case CustomerViewInfo.merge:
        return CustomerMergeScreen(
          customer: _selectedCustomer!,
          store: _store,
          onBack: () => _showDetail(_selectedCustomer!),
        );
      case CustomerViewInfo.list:
        return CustomerListScreen(
          store: _store,
          onMenuTap: widget.onMenuTap,
          onSelectCustomer: _showDetail,
          onAddCustomer: _showAdd,
        );
    }
  }
}
