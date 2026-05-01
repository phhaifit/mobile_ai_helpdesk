// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupInfoDtoImpl _$$GroupInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$GroupInfoDtoImpl(
      groupId: json['groupID'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => MemberInfoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupInfoDtoImplToJson(_$GroupInfoDtoImpl instance) =>
    <String, dynamic>{
      'groupID': instance.groupId,
      'displayName': instance.displayName,
      'avatar': instance.avatar,
      'members': instance.members,
    };

_$MemberInfoDtoImpl _$$MemberInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$MemberInfoDtoImpl(
      groupId: json['groupID'] as String? ?? '',
      customerId: json['customerID'] as String? ?? '',
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      deletedAt:
          json['deletedAt'] == null
              ? null
              : DateTime.parse(json['deletedAt'] as String),
      groupCustomerInfo:
          (json['customer'] as List<dynamic>?)
              ?.map(
                (e) => GroupCustomerInfoDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MemberInfoDtoImplToJson(_$MemberInfoDtoImpl instance) =>
    <String, dynamic>{
      'groupID': instance.groupId,
      'customerID': instance.customerId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'customer': instance.groupCustomerInfo,
    };

_$GroupCustomerInfoDtoImpl _$$GroupCustomerInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$GroupCustomerInfoDtoImpl(
  customerId: json['customerID'] as String? ?? '',
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$$GroupCustomerInfoDtoImplToJson(
  _$GroupCustomerInfoDtoImpl instance,
) => <String, dynamic>{
  'customerID': instance.customerId,
  'name': instance.name,
};
