import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User entity - represents a logged-in user.
///
/// Maps to GET /api/v1/auth/me response:
/// ```json
/// { "id": "...", "email": "...", "username": "...", "roles": [...], "geo": {} }
/// ```
@JsonSerializable()
class User {
  final String id;
  final String email;
  final String username;
  final List<String>? roles;
  final String? avatar;
  final String? phone;
  final String? fullName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.roles,
    this.avatar,
    this.phone,
    this.fullName,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
