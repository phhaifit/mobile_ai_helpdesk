// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TenantSettings _$TenantSettingsFromJson(Map<String, dynamic> json) =>
    TenantSettings(
      allowInvitations: json['allowInvitations'] as bool,
      defaultRole: $enumDecode(_$TeamRoleEnumMap, json['defaultRole']),
      enableAuditLog: json['enableAuditLog'] as bool,
    );

Map<String, dynamic> _$TenantSettingsToJson(TenantSettings instance) =>
    <String, dynamic>{
      'allowInvitations': instance.allowInvitations,
      'defaultRole': _$TeamRoleEnumMap[instance.defaultRole]!,
      'enableAuditLog': instance.enableAuditLog,
    };

const _$TeamRoleEnumMap = {
  TeamRole.owner: 'owner',
  TeamRole.admin: 'admin',
  TeamRole.member: 'member',
};
