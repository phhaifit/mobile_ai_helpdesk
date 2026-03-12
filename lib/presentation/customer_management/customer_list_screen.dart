import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/customer/customer.dart';
import 'store/customer_store.dart';
import 'customer_detail_screen.dart';
import 'customer_add_edit_screen.dart';
import 'customer_merge_screen.dart';
import 'widgets/customer_card.dart';
import 'widgets/customer_filter_sheet.dart';

class CustomerListScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const CustomerListScreen({super.key, this.onMenuTap});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen>
    with SingleTickerProviderStateMixin {
  final CustomerStore _store = getIt<CustomerStore>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _store.fetchCustomers();
    _searchController.addListener(() {
      _store.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCustomerTab(),
                  _buildBlockedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.onMenuTap != null) ...[
                GestureDetector(
                  onTap: widget.onMenuTap,
                  child: const Icon(Icons.menu,
                      color: AppColors.textPrimary, size: 22),
                ),
                const SizedBox(width: 10),
              ],
              const Expanded(
                child: Text(
                  'Danh s\u00e1ch kh\u00e1ch h\u00e0ng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _buildAddButton(),
            ],
          ),
          const SizedBox(height: 4),
          Observer(
            builder: (_) => Text(
              'T\u1ed5ng s\u1ed1 kh\u00e1ch h\u00e0ng: ${_store.totalCount} ng\u01b0\u1eddi',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 12),
          // Action row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.upload_outlined,
                  label: 'Xu\u1ea5t excel',
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.tune_rounded,
                  label: 'H\u00e0nh \u0111\u1ed9ng',
                  hasDropdown: true,
                  onTap: _showActionsMenu,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.label_outline,
                  label: 'Danh s\u00e1ch nh\u00e3n',
                  onTap: _showLabelsSheet,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Search + filter row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'T\u00ecm kh\u00e1ch h\u00e0ng',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: Icon(Icons.search,
                        color: Colors.grey.shade400, size: 18),
                    filled: true,
                    fillColor: AppColors.backgroundGrey,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
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
                      borderSide:
                          const BorderSide(color: AppColors.primaryBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Observer(
                builder: (_) {
                  final hasFilter = _store.selectedTagFilters.isNotEmpty;
                  return InkWell(
                    onTap: _showFilterSheet,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hasFilter
                              ? AppColors.primaryBlue
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: hasFilter
                            ? AppColors.primaryBlue.withOpacity(0.05)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list,
                              size: 18,
                              color: hasFilter
                                  ? AppColors.primaryBlue
                                  : Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 13,
                              color: hasFilter
                                  ? AppColors.primaryBlue
                                  : Colors.grey.shade600,
                            ),
                          ),
                          if (hasFilter) ...[
                            const SizedBox(width: 4),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${_store.selectedTagFilters.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _navigateToAdd,
      icon: const Icon(Icons.add, size: 15),
      label: const Text('Th\u00eam', style: TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool hasDropdown = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            if (hasDropdown) ...[
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down,
                  size: 14, color: Colors.grey.shade600),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        indicatorColor: AppColors.primaryBlue,
        indicatorWeight: 2,
        tabs: const [
          Tab(text: 'Th\u00f4ng tin kh\u00e1ch h\u00e0ng'),
          Tab(text: 'Qu\u1ea3n l\u00fd ch\u1eb7n'),
        ],
      ),
    );
  }

  Widget _buildCustomerTab() {
    return Column(
      children: [
        Expanded(
          child: Observer(
            builder: (_) {
              if (_store.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final customers = _store.filteredCustomers;
              if (customers.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: customers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => CustomerCard(
                  customer: customers[i],
                  onTap: () => _navigateToDetail(customers[i]),
                ),
              );
            },
          ),
        ),
        _buildPagination(),
      ],
    );
  }

  Widget _buildBlockedTab() {
    return Observer(
      builder: (_) {
        if (_store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final blocked = _store.blockedCustomers;
        if (blocked.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  'Kh\u00f4ng c\u00f3 kh\u00e1ch h\u00e0ng b\u1ecb ch\u1eb7n',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: blocked.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => CustomerCard(
            customer: blocked[i],
            onTap: () => _navigateToDetail(blocked[i]),
            showUnblockButton: true,
            onUnblock: () => _store.unblockCustomer(blocked[i].id),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Kh\u00f4ng t\u00ecm th\u1ea5y kh\u00e1ch h\u00e0ng',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _searchController.clear();
              _store.clearTagFilters();
            },
            child: const Text('X\u00f3a b\u1ed9 l\u1ecdc'),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Observer(
        builder: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'S\u1ed1 d\u00f2ng m\u1ed7i trang:',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Text('10',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade700)),
                  Icon(Icons.keyboard_arrow_down,
                      size: 14, color: Colors.grey.shade600),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '1',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CustomerDetailScreen(customer: customer, store: _store),
      ),
    );
  }

  void _navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CustomerAddEditScreen(store: _store)),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CustomerFilterSheet(store: _store),
    );
  }

  void _showActionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(bottom: 8),
              ),
              ListTile(
                leading: const Icon(Icons.merge_type,
                    color: AppColors.primaryBlue),
                title: const Text('H\u1ee3p nh\u1ea5t kh\u00e1ch h\u00e0ng'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            CustomerMergeScreen(store: _store)),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.delete_outline, color: Colors.red.shade400),
                title: Text(
                  'X\u00f3a nhi\u1ec1u',
                  style: TextStyle(color: Colors.red.shade400),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLabelsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'Danh s\u00e1ch nh\u00e3n',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Observer(
                  builder: (_) {
                    final tags = _store.allAvailableTags;
                    if (tags.isEmpty) {
                      return Center(
                        child: Text(
                          'Ch\u01b0a c\u00f3 nh\u00e3n n\u00e0o',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      controller: scrollCtrl,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag,
                                    style: const TextStyle(fontSize: 12)),
                                backgroundColor:
                                    AppColors.primaryBlue.withOpacity(0.1),
                                labelStyle: const TextStyle(
                                    color: AppColors.primaryBlue),
                                side: const BorderSide(
                                    color: Colors.transparent),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
