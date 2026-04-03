class MenuItemModel {
  final String title;
  MenuItemModel(this.title);
}

class MenuCategoryModel {
  final String title;
  final String iconName; // simple string marker, UI will map to IconData
  final List<MenuItemModel> items;

  MenuCategoryModel({required this.title, required this.iconName, required this.items});
}
