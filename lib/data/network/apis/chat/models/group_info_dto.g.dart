// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupInfoDtoImpl _$$GroupInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$GroupInfoDtoImpl(
      groupId: json['groupID'] as String? ?? '',
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => MemberInfoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupInfoDtoImplToJson(_$GroupInfoDtoImpl instance) =>
    <String, dynamic>{
      'groupID': instance.groupId,
      'memberCount': instance.memberCount,
      'members': instance.members,
    };

_$MemberInfoDtoImpl _$$MemberInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$MemberInfoDtoImpl(
      customerId: json['customerID'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$MemberInfoDtoImplToJson(_$MemberInfoDtoImpl instance) =>
    <String, dynamic>{'customerID': instance.customerId, 'name': instance.name};
