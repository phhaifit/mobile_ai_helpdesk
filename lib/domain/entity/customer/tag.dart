class Tag {
  final String id;
  final String name;
  final String? tenantId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Tag({
    required this.id,
    required this.name,
    this.tenantId,
    this.createdAt,
    this.updatedAt,
  });

  Tag copyWith({
    String? id,
    String? name,
    String? tenantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      tenantId: tenantId ?? this.tenantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
