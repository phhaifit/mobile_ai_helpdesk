class User {
  final String id;
  final String name;
  final String avatar;
  final String? externalAccountId;

  const User({required this.id, required this.name, required this.avatar, this.externalAccountId});
}