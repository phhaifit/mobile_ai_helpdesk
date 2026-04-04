class PromptCategory {
  final String id;
  final String nameKey;

  const PromptCategory({required this.id, required this.nameKey});
}

class Prompt {
  final String id;
  final String title;
  final String body;
  final String categoryId;
  final bool isFavorite;
  final int usageCount;
  final bool isPrivate;

  const Prompt({
    required this.id,
    required this.title,
    required this.body,
    required this.categoryId,
    required this.isFavorite,
    required this.usageCount,
    required this.isPrivate,
  });

  Prompt copyWith({
    String? id,
    String? title,
    String? body,
    String? categoryId,
    bool? isFavorite,
    int? usageCount,
    bool? isPrivate,
  }) {
    return Prompt(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      usageCount: usageCount ?? this.usageCount,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
