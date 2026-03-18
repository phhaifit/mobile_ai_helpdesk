// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => TeamMember(
  id: json['id'] as String,
  tenantId: json['tenantId'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$TeamRoleEnumMap, json['role']),
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => Permission.fromJson(e as Map<String, dynamic>))
      .toList(),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$TeamMemberToJson(TeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'email': instance.email,
      'displayName': instance.displayName,
      'role': _$TeamRoleEnumMap[instance.role]!,
      'permissions': instance.permissions,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TeamRoleEnumMap = {
  TeamRole.owner: 'owner',
  TeamRole.admin: 'admin',
  TeamRole.member: 'member',
  TeamRole.viewer: 'viewer',
};
