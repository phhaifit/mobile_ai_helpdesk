import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User entity - represents a logged-in user
@JsonSerializable()
class User {
  final String id;
  final String email;
  final String username;
  final String? avatar;
  final String? phone;
  final String? fullName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    this.avatar,
    this.phone,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
