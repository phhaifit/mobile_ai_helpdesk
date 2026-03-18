// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invitation _$InvitationFromJson(Map<String, dynamic> json) => Invitation(
  id: json['id'] as String,
  tenantId: json['tenantId'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$TeamRoleEnumMap, json['role']),
  status: $enumDecode(_$InvitationStatusEnumMap, json['status']),
  invitedByMemberId: json['invitedByMemberId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
);

Map<String, dynamic> _$InvitationToJson(Invitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'email': instance.email,
      'role': _$TeamRoleEnumMap[instance.role]!,
      'status': _$InvitationStatusEnumMap[instance.status]!,
      'invitedByMemberId': instance.invitedByMemberId,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
    };

const _$TeamRoleEnumMap = {
  TeamRole.owner: 'owner',
  TeamRole.admin: 'admin',
  TeamRole.member: 'member',
  TeamRole.viewer: 'viewer',
};

const _$InvitationStatusEnumMap = {
  InvitationStatus.pending: 'pending',
  InvitationStatus.accepted: 'accepted',
  InvitationStatus.revoked: 'revoked',
  InvitationStatus.expired: 'expired',
};
