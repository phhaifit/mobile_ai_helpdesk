import 'package:flutter/material.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import '../constants/colors.dart';
import 'ticket/screens/ticket_list_screen.dart';
import 'widgets/sidebar_menu_panel.dart';

class MainScreen extends StatefulWidget {
  final String initialCategory;

  const MainScreen({
    super.key,
    this.initialCategory = 'Hỗ trợ khách hàng',
  });

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
        title: 'Hỗ trợ khách hàng',
        icon: Icons.confirmation_number_outlined,
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
        title: 'Báo cáo & Thống kê',
        icon: Icons.bar_chart_outlined,
        items: [
          MenuItem(
            title: 'Báo cáo chi tiết',
            onTap: () => _selectCategory('Báo cáo chi tiết'),
          ),
          MenuItem(
            title: 'Thống kê theo trạng thái',
            onTap: () => _selectCategory('Thống kê theo trạng thái'),
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

  void _selectCategory(String category) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (category == 'Phiếu chưa xử lý' && currentRoute != Routes.ticketList) {
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

    // Build content based on category
    Widget contentWidget;

    if (_selectedCategory == 'Phiếu chưa xử lý') {
      contentWidget = const TicketListScreen();
    } else {
      // Placeholder for other categories
      contentWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 80,
              color: AppColors.primaryBlue.withOpacity(0.3),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      // Mobile: Full-screen content, sidebar hidden
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
