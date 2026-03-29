import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'tenant_switcher.dart';

class MenuCategory {
  final String title;
  final List<MenuItem> items;
  final IconData icon;
  bool isExpanded;

  MenuCategory({
    required this.title,
    required this.items,
    required this.icon,
    this.isExpanded = true,
  });
}

class MenuItem {
  final String id;
  final String title;
  final VoidCallback onTap;

  MenuItem({required this.id, required this.title, required this.onTap});
}

// Sidebar menu content widget (for reuse in desktop and mobile)
class SidebarMenuContent extends StatefulWidget {
  final List<MenuCategory> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const SidebarMenuContent({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  @override
  State<SidebarMenuContent> createState() => _SidebarMenuContentState();
}

class _SidebarMenuContentState extends State<SidebarMenuContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Logo
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jarvis',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'HELPDESK',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const TenantSwitcher(),
        // Menu categories
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.categories.map(
                  (category) => _buildMenuCategory(category),
                ),
              ],
            ),
          ),
        ),
        // Bottom Profile Section
        _buildProfileSection(),
      ],
    );
  }

  Widget _buildMenuCategory(MenuCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        GestureDetector(
          onTap: () {
            setState(() {
              category.isExpanded = !category.isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(category.icon, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  category.isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        // Category Items
        if (category.isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: category.items
                .map((item) => _buildMenuItem(item))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final bool isSelected = widget.selectedCategory == item.id;

    return GestureDetector(
      onTap: () {
        item.onTap();
      },
      child: Container(
        color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : null,
        padding: const EdgeInsets.fromLTRB(36, 10, 12, 10),
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(right: 8),
              ),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'T',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tân Nguyễn Huy',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Quản lý',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(
            Icons.notifications_active_outlined,
            size: 18,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}

// Legacy SidebarMenuPanel for mobile animations (optional, can keep for later use)
class SidebarMenuPanel extends StatefulWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onClose;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const SidebarMenuPanel({
    required this.slideAnimation,
    required this.onClose,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  @override
  State<SidebarMenuPanel> createState() => _SidebarMenuPanelState();
}

class _SidebarMenuPanelState extends State<SidebarMenuPanel> {
  late List<MenuCategory> categories;

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  void _initializeCategories() {
    categories = [
      MenuCategory(
        title: 'Hỗ trợ khách hàng',
        icon: Icons.help_outline_rounded,
        items: [
          MenuItem(
            id: 'support_inbox',
            title: 'Hộp thư hỗ trợ',
            onTap: () => widget.onCategorySelected('Hộp thư hỗ trợ'),
          ),
          MenuItem(
            id: 'pending_tickets',
            title: 'Phiếu chưa xử lý',
            onTap: () => widget.onCategorySelected('Phiếu chưa xử lý'),
          ),
          MenuItem(
            id: 'ai_chat_bot',
            title: 'AI Chat Bot',
            onTap: () => widget.onCategorySelected('AI Chat Bot'),
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
            onTap: () => widget.onCategorySelected('Khách hàng'),
          ),
          MenuItem(
            id: 'orders',
            title: 'Đơn hàng',
            onTap: () => widget.onCategorySelected('Đơn hàng'),
          ),
          MenuItem(
            id: 'products',
            title: 'Sản phẩm',
            onTap: () => widget.onCategorySelected('Sản phẩm'),
          ),
          MenuItem(
            id: 'promotions',
            title: 'Khuyến mãi & Vòng quay',
            onTap: () => widget.onCategorySelected('Khuyến mãi & Vòng quay'),
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
            onTap: () => widget.onCategorySelected('Chiến dịch'),
          ),
          MenuItem(
            id: 'template',
            title: 'Template',
            onTap: () => widget.onCategorySelected('Template'),
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
            onTap: () => widget.onCategorySelected('Báo cáo chi tiết'),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with Logo & Close Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            'J',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Jarvis HELPDESK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            const TenantSwitcher(),
            // Menu categories
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...categories.map(
                      (category) => _buildMenuCategory(category),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Profile Section
            _buildProfileSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCategory(MenuCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        GestureDetector(
          onTap: () {
            setState(() {
              category.isExpanded = !category.isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(category.icon, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  category.isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        // Category Items
        if (category.isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: category.items
                .map((item) => _buildMenuItem(item, category.title))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item, String categoryTitle) {
    final bool isSelected =
        widget.selectedCategory == item.title ||
        widget.selectedCategory == categoryTitle;

    return GestureDetector(
      onTap: () {
        item.onTap();
        widget.onClose(); // Close sidebar after selection
      },
      child: Container(
        color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : null,
        padding: const EdgeInsets.fromLTRB(36, 10, 12, 10),
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(right: 8),
              ),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'T',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tân Nguyễn Huy',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Quản lý',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(
            Icons.notifications_active_outlined,
            size: 18,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}
