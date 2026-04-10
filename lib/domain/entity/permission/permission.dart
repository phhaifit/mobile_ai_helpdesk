import 'package:json_annotation/json_annotation.dart';

part 'permission.g.dart';

/// A permission granted within a tenant (e.g. `tenant:settings:write`).
@JsonSerializable()
class Permission {
  final String code;
  final String? description;

  const Permission({required this.code, this.description});

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
