import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_info_dto.freezed.dart';
part 'group_info_dto.g.dart';

@freezed
class GroupInfoDto with _$GroupInfoDto {
  const factory GroupInfoDto({
    @JsonKey(name: 'groupID') @Default('') String groupId,
    @JsonKey(name: 'displayName') @Default('') String displayName,
    @JsonKey(name: 'avatar') @Default('') String avatar,
    @Default([]) List<MemberInfoDto> members,
  }) = _GroupInfoDto;

  factory GroupInfoDto.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoDtoFromJson(json);
}
@freezed
class MemberInfoDto with _$MemberInfoDto {
  const factory MemberInfoDto({
    @JsonKey(name: 'groupID') @Default('') String groupId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @JsonKey(name: 'customer') @Default([]) List<GroupCustomerInfoDto> groupCustomerInfo,
  }) = _MemberInfoDto;

  factory MemberInfoDto.fromJson(Map<String, dynamic> json) => 
      _$MemberInfoDtoFromJson(json);
}

@freezed
class GroupCustomerInfoDto with _$GroupCustomerInfoDto {
  const factory GroupCustomerInfoDto({
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'name') @Default('') String name,
  }) = _GroupCustomerInfoDto;

  factory GroupCustomerInfoDto.fromJson(Map<String, dynamic> json) => 
      _$GroupCustomerInfoDtoFromJson(json);
}