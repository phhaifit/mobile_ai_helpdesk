import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../di/service_locator.dart';
import '../domain/entity/customer/customer.dart';
import 'chat/support_inbox_screen.dart';
import 'customer_management/customer_add_edit_screen.dart';
import 'customer_management/customer_detail_screen.dart';
import 'customer_management/customer_list_screen.dart';
import 'customer_management/customer_merge_screen.dart';
import 'customer_management/store/customer_store.dart';
import 'tenant/tenant_info_screen.dart';
import 'widgets/sidebar_menu_panel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCategory = 'support_inbox';
  bool _showSidebarMobile = false;

  // Desktop view state
  String _desktopView = 'list'; // 'list', 'detail', 'add', 'edit', 'merge'
  Customer? _selectedCustomer;
  Customer? _editingCustomer;
  late final CustomerStore _customerStore;

  late List<MenuCategory> _categories;

  @override
  void initState() {
    super.initState();
    _customerStore = getIt<CustomerStore>();
    _initializeCategories();
  }

  void _initializeCategories() {
    _categories = [
      MenuCategory(
        title: 'Hỗ trợ khách hàng',
        icon: Icons.help_outline_rounded,
        items: [
          MenuItem(
            id: 'support_inbox',
            title: 'Hộp thư hỗ trợ',
            onTap: () => _selectCategory('support_inbox'),
          ),
          MenuItem(
            id: 'pending_tickets',
            title: 'Phiếu chưa xử lý',
            onTap: () => _selectCategory('pending_tickets'),
          ),
          MenuItem(
            id: 'ai_chat_bot',
            title: 'AI Chat Bot',
            onTap: () => _selectCategory('ai_chat_bot'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Khách hàng & Đơn hàng',
        icon: Icons.people_outline_rounded,
        items: [
          MenuItem(
            id: 'customers',
            title: 'Khách hàng',
            onTap: () => _selectCategory('customers'),
          ),
          MenuItem(
            id: 'orders',
            title: 'Đơn hàng',
            onTap: () => _selectCategory('orders'),
          ),
          MenuItem(
            id: 'products',
            title: 'Sản phẩm',
            onTap: () => _selectCategory('products'),
          ),
          MenuItem(
            id: 'promotions',
            title: 'Khuyến mãi & Vòng quay',
            onTap: () => _selectCategory('promotions'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Marketing',
        icon: Icons.campaign_outlined,
        items: [
          MenuItem(
            id: 'campaigns',
            title: 'Chiến dịch',
            onTap: () => _selectCategory('campaigns'),
          ),
          MenuItem(
            id: 'template',
            title: 'Template',
            onTap: () => _selectCategory('template'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Cài đặt',
        icon: Icons.settings_outlined,
        items: [
          MenuItem(
            id: 'tenant_info',
            title: 'Thông tin doanh nghiệp',
            onTap: () => _selectCategory('tenant_info'),
          ),
          MenuItem(
            id: 'employee_list',
            title: 'Nhân viên',
            onTap: () => _selectCategory('employee_list'),
          ),
          MenuItem(
            id: 'omnichannel_hub',
            title: 'Tích hợp ứng dụng',
            onTap: () => _selectCategory('omnichannel_hub'),
          ),
          MenuItem(
            id: 'channel_permission',
            title: 'Phân quyền kênh',
            onTap: () => _selectCategory('channel_permission'),
          ),
          MenuItem(
            id: 'payment',
            title: 'Thanh toán',
            onTap: () => _selectCategory('payment'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Báo cáo & Thống kê',
        icon: Icons.bar_chart_outlined,
        items: [
          MenuItem(
            id: 'detailed_reports',
            title: 'Báo cáo chi tiết',
            onTap: () => _selectCategory('detailed_reports'),
          ),
        ],
      ),
    ];
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      // Close sidebar on mobile after selection
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < 600) {
        _showSidebarMobile = false;
      }
    });
  }

  void _toggleMobileSidebar() {
    setState(() {
      _showSidebarMobile = !_showSidebarMobile;
    });
  }

  // Desktop: Show customer detail panel
  void _showCustomerDetail(Customer customer) {
    setState(() {
      _desktopView = 'detail';
      _selectedCustomer = customer;
    });
  }

  // Desktop: Show add customer form
  void _showAddCustomerForm() {
    setState(() {
      _desktopView = 'add';
      _editingCustomer = null;
    });
  }

  // Desktop: Show edit customer form
  void _showEditCustomerForm(Customer customer) {
    setState(() {
      _desktopView = 'edit';
      _editingCustomer = customer;
    });
  }

  // Desktop: Back to list
  void _backToCustomerList() {
    setState(() {
      _desktopView = 'list';
      _selectedCustomer = null;
      _editingCustomer = null;
    });
  }

  // Desktop: Show merge view
  void _showMergeCustomerView() {
    setState(() {
      _desktopView = 'merge';
    });
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    // Build desktop layout for chat
    if (isDesktop && _selectedCategory == 'support_inbox') {
      return _buildDesktopChatView();
    }

    // Build desktop layout for Khách hàng
    if (isDesktop && _selectedCategory == 'customers') {
      return _buildDesktopCustomerView();
    }

    // Build content based on category
    Widget contentWidget;

    if (_selectedCategory == 'support_inbox') {
      contentWidget = SupportInboxScreen(onMenuTap: _toggleMobileSidebar);
    } else if (_selectedCategory == 'customers') {
      contentWidget = CustomerListScreen(
        onMenuTap: _toggleMobileSidebar,
        onCustomerSelected: isDesktop ? _showCustomerDetail : null,
        onAddCustomer: isDesktop ? _showAddCustomerForm : null,
        onEditCustomer: isDesktop ? _showEditCustomerForm : null,
        onMergeCustomer: isDesktop ? _showMergeCustomerView : null,
      );
    } else if (_selectedCategory == 'tenant_info') {
      contentWidget = TenantInfoScreen(onMenuTap: _toggleMobileSidebar);
    } else {
      // Placeholder for other categories
      contentWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 80,
              color: AppColors.messengerBlue.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedCategory,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tính năng sắp ra mắt',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // On desktop: wrap content to prevent full-screen takeover
    if (isDesktop) {
      return Container(color: AppColors.backgroundGrey, child: contentWidget);
    }

    return contentWidget;
  }

  // Desktop chat view with 3-column layout
  Widget _buildDesktopChatView() {
    return SupportInboxScreen(onMenuTap: _toggleMobileSidebar);
  }

  // Desktop customer view with responsive panels
  Widget _buildDesktopCustomerView() {
    if (_desktopView == 'detail' && _selectedCustomer != null) {
      return CustomerDetailScreen(
        customer: _selectedCustomer!,
        store: _customerStore,
        showAppBar: false,
        onBack: _backToCustomerList,
        onEdit: () => _showEditCustomerForm(_selectedCustomer!),
      );
    }

    if (_desktopView == 'add') {
      return CustomerAddEditScreen(
        store: _customerStore,
        customer: null,
        showAppBar: false,
        onBack: _backToCustomerList,
      );
    }

    if (_desktopView == 'edit' && _editingCustomer != null) {
      return CustomerAddEditScreen(
        store: _customerStore,
        customer: _editingCustomer,
        showAppBar: false,
        onBack: _backToCustomerList,
      );
    }

    if (_desktopView == 'merge') {
      return CustomerMergeScreen(
        store: _customerStore,
        showAppBar: false,
        onBack: _backToCustomerList,
      );
    }

    // Default: show list
    return CustomerListScreen(
      onMenuTap: _toggleMobileSidebar,
      onCustomerSelected: _showCustomerDetail,
      onAddCustomer: _showAddCustomerForm,
      onEditCustomer: _showEditCustomerForm,
      onMergeCustomer: _showMergeCustomerView,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      // Mobile: Stacked sidebar with bottom sheet or overlay
      return Scaffold(
        body: Stack(
          children: [
            _buildContent(),
            if (_showSidebarMobile)
              GestureDetector(
                onTap: () => setState(() => _showSidebarMobile = false),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            if (_showSidebarMobile)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 280,
                  color: Colors.white,
                  child: SidebarMenuContent(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _selectCategory,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      // Desktop/Tablet: Side-by-side layout
      return Scaffold(
        body: Row(
          children: [
            // Sidebar (fixed width)
            Container(
              width: 280,
              color: Colors.white,
              child: SidebarMenuContent(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _selectCategory,
              ),
            ),
            // Divider
            Container(width: 1, color: AppColors.dividerColor),
            // Content area
            Expanded(child: _buildContent()),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
