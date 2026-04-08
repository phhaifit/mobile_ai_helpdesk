import 'menu_models.dart';

final List<MenuCategoryModel> defaultMenu = [
  MenuCategoryModel(
    title: 'Hỗ trợ khách hàng',
    iconName: 'help',
    items: [
      MenuItemModel('Hộp thư hỗ trợ'),
      MenuItemModel('Phiếu chưa xử lý'),
      MenuItemModel('AI Chat Bot'),
    ],
  ),
  MenuCategoryModel(
    title: 'Khách hàng & Đơn hàng',
    iconName: 'people',
    items: [
      MenuItemModel('Khách hàng'),
      MenuItemModel('Đơn hàng'),
      MenuItemModel('Sản phẩm'),
      MenuItemModel('Khuyến mãi & Vòng quay'),
    ],
  ),
  MenuCategoryModel(
    title: 'Marketing',
    iconName: 'campaign',
    items: [
      MenuItemModel('Chiến dịch'),
      MenuItemModel('Template'),
    ],
  ),
  MenuCategoryModel(
    title: 'Báo cáo & Thống kê',
    iconName: 'bar_chart',
    items: [
      MenuItemModel('Báo cáo chi tiết'),
    ],
  ),
  // AI & Playground category shared for playground screen
  MenuCategoryModel(
    title: 'AI & Playground',
    iconName: 'smart_toy',
    items: [
      MenuItemModel('AI Agents'),
      MenuItemModel('Playground'),
    ],
  ),
];
