import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'chat/chat_room_list_screen.dart';
import 'widgets/sidebar_menu_panel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCategory = 'Hộp thư hỗ trợ';
  bool _showSidebarMobile = false;

  late List<MenuCategory> _categories;

  @override
  void initState() {
    super.initState();
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

  Widget _buildContent() {
    // Build content based on selected category
    if (_selectedCategory == 'Hộp thư hỗ trợ') {
      return ChatRoomListScreen(
        selectedCategory: _selectedCategory,
        onMenuTap: _toggleMobileSidebar,
      );
    }

    // For other categories, show placeholder
    return Center(
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
