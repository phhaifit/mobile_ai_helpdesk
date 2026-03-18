import 'package:flutter/material.dart';
import './lib/constants/colors.dart';
import './lib/domain/entity/customer/customer.dart';
import './lib/presentation/chat/support_inbox_screen.dart';
import './lib/presentation/chat/store/chat_room_store.dart';
import './lib/presentation/customer_management/customer_list_screen.dart';
import './lib/presentation/customer_management/customer_detail_screen.dart';
import './lib/presentation/customer_management/customer_add_edit_screen.dart';
import './lib/presentation/customer_management/customer_merge_screen.dart';
import './lib/presentation/customer_management/store/customer_store.dart';
import './lib/presentation/widgets/sidebar_menu_panel.dart';
import './lib/di/service_locator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCategory = 'Hộp thư hỗ trợ';
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
            title: 'Hộp thư hỗ trợ',
            onTap: () => _selectCategory('Hộp thư hỗ trợ'),
          ),
          MenuItem(
            title: 'Phiếu chưa xử lý',
            onTap: () => _selectCategory('Phiếu chưa xử lý'),
          ),
          MenuItem(
            title: 'AI Chat Bot',
            onTap: () => _selectCategory('AI Chat Bot'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Khách hàng & Đơn hàng',
        icon: Icons.people_outline_rounded,
        items: [
          MenuItem(
            title: 'Khách hàng',
            onTap: () => _selectCategory('Khách hàng'),
          ),
          MenuItem(title: 'Đơn hàng', onTap: () => _selectCategory('Đơn hàng')),
          MenuItem(title: 'Sản phẩm', onTap: () => _selectCategory('Sản phẩm')),
          MenuItem(
            title: 'Khuyến mãi & Vòng quay',
            onTap: () => _selectCategory('Khuyến mãi & Vòng quay'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Marketing',
        icon: Icons.campaign_outlined,
        items: [
          MenuItem(
            title: 'Chiến dịch',
            onTap: () => _selectCategory('Chiến dịch'),
          ),
          MenuItem(title: 'Template', onTap: () => _selectCategory('Template')),
        ],
      ),
      MenuCategory(
        title: 'Báo cáo & Thống kê',
        icon: Icons.bar_chart_outlined,
        items: [
          MenuItem(
            title: 'Báo cáo chi tiết',
            onTap: () => _selectCategory('Báo cáo chi tiết'),
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
    if (isDesktop && _selectedCategory == 'Hộp thư hỗ trợ') {
      return _buildDesktopChatView();
    }

    // Build desktop layout for Khách hàng
    if (isDesktop && _selectedCategory == 'Khách hàng') {
      return _buildDesktopCustomerView();
    }

    // Build content based on category
    Widget contentWidget;

    if (_selectedCategory == 'Hộp thư hỗ trợ') {
      contentWidget = SupportInboxScreen(onMenuTap: _toggleMobileSidebar);
    } else if (_selectedCategory == 'Khách hàng') {
      contentWidget = CustomerListScreen(
        onMenuTap: _toggleMobileSidebar,
        onCustomerSelected: isDesktop ? _showCustomerDetail : null,
        onAddCustomer: isDesktop ? _showAddCustomerForm : null,
        onEditCustomer: isDesktop ? _showEditCustomerForm : null,
        onMergeCustomer: isDesktop ? _showMergeCustomerView : null,
      );
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
      // Mobile: Hide sidebar completely, show only content
      return Scaffold(
        body: _buildContent(),
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
