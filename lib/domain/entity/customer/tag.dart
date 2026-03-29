class Tag {
  final String id;
  final String name;
  final String colorHex;

  const Tag({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  Tag copyWith({
    String? id,
    String? name,
    String? colorHex,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}
