import 'package:flutter/material.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/presentation/tenant/invitation_response_screen.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';

import '../constants/colors.dart';
import 'chat/support_inbox_screen.dart';
import 'ticket/screens/ticket_list_screen.dart';
import 'tenant/employee_screen.dart';
import 'tenant/tenant_info_screen.dart';
import 'customer/screens/customer_main_screen.dart';
import 'monetization/monetization_screen.dart';
import 'omnichannel/omnichannel_hub_screen.dart';
import 'prompt/prompt_library_screen.dart';
import 'ticket/screens/ticket_list_screen.dart';
import 'widgets/sidebar_menu_panel.dart';

class MainScreen extends StatefulWidget {
  final String initialCategory;

  const MainScreen({super.key, this.initialCategory = 'support_inbox'});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _selectedCategory;
  bool _showSidebarMobile = false;

  late List<MenuCategory> _categories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _initializeCategories();
  }

  void _initializeCategories() {
    _categories = [
      MenuCategory(
        title: 'Tổng quan',
        icon: Icons.dashboard_outlined,
        items: [
          MenuItem(
            title: 'Dashboard',
            onTap: () => _selectCategory('Dashboard'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Hỗ trợ khách hàng',
        icon: Icons.confirmation_number_outlined,
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
        title: 'Công cụ AI',
        icon: Icons.library_books_outlined,
        items: [
          MenuItem(
            title: 'Prompt Library',
            onTap: () => _selectCategory('Prompt Library'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Kênh tích hợp',
        icon: Icons.hub_outlined,
        items: [
          MenuItem(
            id: 'Omnichannel',
            title: 'Omnichannel',
            onTap: () => _selectCategory('Omnichannel'),
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
          MenuItem(
            id: 'mock_invitation_response',
            title: 'Mock invitation response',
            onTap: _openMockInvitationResponse,
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
          MenuItem(
            id: 'status_reports',
            title: 'Thống kê theo trạng thái',
            onTap: () => _selectCategory('status_reports'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Gói dịch vụ',
        icon: Icons.monetization_on_outlined,
        items: [
          MenuItem(
            id: 'Monetization',
            title: 'Monetization',
            onTap: () => _selectCategory('Monetization'),
          ),
        ],
      ),
    ];
  }

  void _toggleMobileSidebar() {
    setState(() {
      _showSidebarMobile = !_showSidebarMobile;
    });
  }

  /// Opens the invitation response flow using a pending invite from the team store
  /// (same screen as an email accept link), or mock seed `inv-001` if none pending.
  /// TODO: remove this after testing
  void _openMockInvitationResponse() {
    final teamStore = getIt<TeamStore>();
    String invitationId = 'inv-001';
    for (final inv in teamStore.invitations) {
      if (inv.status == InvitationStatus.pending) {
        invitationId = inv.id;
        break;
      }
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => InvitationResponseScreen(invitationId: invitationId),
      ),
    );
  }

  void _selectCategory(String category) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (category == 'pending_tickets' && currentRoute != Routes.ticketList) {
      Navigator.pushReplacementNamed(context, Routes.ticketList);
      return;
    }

    setState(() {
      _selectedCategory = category;
      // Close sidebar on mobile after selection
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < 600) {
        _showSidebarMobile = false;
      }
    });
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    // Build desktop layout for chat
    if (isDesktop && _selectedCategory == 'support_inbox') {
      return _buildDesktopChatView();
    }

    // Build content based on category
    Widget contentWidget;

    final isMobile = !isDesktop;

    switch (_selectedCategory) {
      case 'Dashboard':
        contentWidget = _wrapWithMenuBar(
          title: 'Dashboard',
          child: _buildDashboardContent(),
          showMenuButton: isMobile,
        );
      case 'pending_tickets':
        contentWidget = const TicketListScreen();
      case 'support_inbox':
        contentWidget = SupportInboxScreen(onMenuTap: _toggleMobileSidebar);
      case 'customers':
        contentWidget = CustomerMainScreen(onMenuTap: _toggleMobileSidebar);
      case 'tenant_info':
        contentWidget = TenantInfoScreen(onMenuTap: _toggleMobileSidebar);
      case 'employee_list':
        contentWidget = EmployeeScreen(onMenuTap: _toggleMobileSidebar);
      case 'Prompt Library':
        contentWidget = _wrapWithMenuBar(
          title: 'Prompt Library',
          child: const PromptLibraryScreen(embedInParent: true),
          showMenuButton: isMobile,
        );
      case 'Omnichannel':
        contentWidget = _wrapWithMenuBar(
          title: 'Kênh tích hợp',
          child: const OmnichannelHubScreen(showAppBar: false),
          showMenuButton: isMobile,
        );
      case 'Monetization':
        contentWidget = _wrapWithMenuBar(
          title: 'Gói dịch vụ',
          child: const MonetizationScreen(embedded: true),
          showMenuButton: isMobile,
        );
      default:
        contentWidget = _wrapWithMenuBar(
          title: _selectedCategory,
          child: _buildPlaceholder(_selectedCategory),
          showMenuButton: isMobile,
        );
    }

    // On desktop: wrap content to prevent full-screen takeover
    if (isDesktop) {
      return ColoredBox(color: AppColors.backgroundGrey, child: contentWidget);
    }

    return contentWidget;
  }

  // Desktop chat view with 3-column layout
  Widget _buildDesktopChatView() {
    return SupportInboxScreen(onMenuTap: _toggleMobileSidebar);
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan hệ thống',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard('Tổng phiếu', '12', Icons.confirmation_number, Colors.blue),
              _buildStatCard('Đang mở', '5', Icons.fiber_new, Colors.orange),
              _buildStatCard('Đang xử lý', '4', Icons.autorenew, Colors.amber),
              _buildStatCard('Đã giải quyết', '3', Icons.check_circle, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Wraps a child widget with an AppBar that includes a menu button (mobile only).
  Widget _wrapWithMenuBar({
    required String title,
    required Widget child,
    required bool showMenuButton,
  }) {
    if (!showMenuButton) return child;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _toggleMobileSidebar,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 80,
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      // Mobile: Stacked sidebar with overlay
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
