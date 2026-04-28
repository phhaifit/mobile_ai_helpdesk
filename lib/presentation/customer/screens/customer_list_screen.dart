import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import '../widgets/customer_filter_sheet.dart';

class CustomerListScreen extends StatefulWidget {
  final CustomerStore store;
  final VoidCallback onMenuTap;
  final Function(Customer) onSelectCustomer;
  final VoidCallback onAddCustomer;

  const CustomerListScreen({
    super.key,
    required this.store,
    required this.onMenuTap,
    required this.onSelectCustomer,
    required this.onAddCustomer,
  });

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.store.loadCustomers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      widget.store.loadCustomers(isLoadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerFilterSheet(store: widget.store),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'C';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenuTap,
        ),
        title: const Text('Khách hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: AppColors.primaryBlue),
            onPressed: widget.onAddCustomer,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm tên, email, sđt...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (val) => widget.store.setSearchQuery(val),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.primaryBlue),
                    onPressed: () => _showFilter(context),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                if (widget.store.isLoading && widget.store.customers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (widget.store.customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('Không tìm thấy khách hàng nào', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: widget.store.customers.length + (widget.store.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= widget.store.customers.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final customer = widget.store.customers[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => widget.onSelectCustomer(customer),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                                backgroundImage: customer.avatarUrl != null && customer.avatarUrl!.isNotEmpty 
                                  ? NetworkImage(customer.avatarUrl!) 
                                  : null,
                                child: (customer.avatarUrl == null || customer.avatarUrl!.isEmpty)
                                  ? Text(
                                      _getInitials(customer.fullName),
                                      style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
                                    )
                                  : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            customer.fullName, 
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (customer.tags.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBlue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              customer.tags.first.name,
                                              style: const TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Builder(
                                      builder: (context) {
                                        final List<Widget> rows = [];
                                        Widget buildRow(IconData icon, String text) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 4.0),
                                            child: Row(
                                              children: [
                                                Icon(icon, size: 14, color: Colors.grey.shade500),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(text, 
                                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        if (customer.phones.isNotEmpty) rows.add(buildRow(Icons.phone_outlined, customer.phones.first));
                                        if (customer.emails.isNotEmpty) rows.add(buildRow(Icons.email_outlined, customer.emails.first));
                                        if (customer.zalos.isNotEmpty) rows.add(buildRow(Icons.chat_bubble_outline, 'Zalo: ${customer.zalos.first}'));
                                        if (customer.messengers.isNotEmpty) rows.add(buildRow(Icons.message_outlined, 'Mess: ${customer.messengers.first}'));
                                        
                                        if (rows.isEmpty) return const Text('Chưa cập nhật liên hệ', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 13));
                                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
