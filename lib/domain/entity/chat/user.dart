class User {
  final String id;
  final String name;
  final String? avatar;
  final String? externalAccountId;

  const User({
    required this.id, 
    required this.name, 
    this.avatar, 
    this.externalAccountId,
  });

  // Manual Equality: Defines when two users are "the same"
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
      other.id == id &&
      other.name == name &&
      other.avatar == avatar &&
      other.externalAccountId == externalAccountId;
  }

  // HashCode: Necessary whenever override ==
  @override
  int get hashCode => 
      id.hashCode ^ 
      name.hashCode ^ 
      avatar.hashCode ^ 
      externalAccountId.hashCode;

  // copyWith: Essential for updating immutable data
  User copyWith({
    String? id,
    String? name,
    String? avatar,
    String? externalAccountId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      externalAccountId: externalAccountId ?? this.externalAccountId,
    );
  }

  // toString: Makes debugging significantly easier in the console
  @override
  String toString() {
    return 'User(id: $id, name: $name)';
  }
}