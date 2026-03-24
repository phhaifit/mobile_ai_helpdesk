class Agent {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String department;
  final bool isActive;
  final DateTime createdAt;

  const Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.department,
    required this.isActive,
    required this.createdAt,
  });

  Agent copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? department,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Agent(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      department: department ?? this.department,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'Agent(id: $id, name: $name, email: $email, department: $department)';
}
