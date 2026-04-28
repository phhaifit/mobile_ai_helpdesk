import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_info_dto.freezed.dart';
part 'group_info_dto.g.dart';

@freezed
class GroupInfoDto with _$GroupInfoDto {
  const factory GroupInfoDto({
    @JsonKey(name: 'groupID') @Default('') String groupId,
    @Default(0) int memberCount,
    @Default([]) List<MemberInfoDto> members,
  }) = _GroupInfoDto;

  factory GroupInfoDto.fromJson(Map<String, dynamic> json) => 
      _$GroupInfoDtoFromJson(json);
}

@freezed
class MemberInfoDto with _$MemberInfoDto {
  const factory MemberInfoDto({
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @Default('') String name,
  }) = _MemberInfoDto;

  factory MemberInfoDto.fromJson(Map<String, dynamic> json) => 
      _$MemberInfoDtoFromJson(json);
}