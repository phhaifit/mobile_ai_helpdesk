import 'package:mobile_ai_helpdesk/domain/entity/permission/permission.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team_member.g.dart';

enum TeamRole { owner, admin, member, viewer }

@JsonSerializable()
class TeamMember {
  final String id;
  final String tenantId;
  final String email;
  final String? displayName;
  final TeamRole role;
  final List<Permission> permissions;
  final bool isActive;
  final DateTime createdAt;

  const TeamMember({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    this.displayName,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMemberToJson(this);
}
