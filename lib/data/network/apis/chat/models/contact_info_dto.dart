import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info_dto.freezed.dart';
part 'contact_info_dto.g.dart';

@Freezed(unionKey: 'name')
class ContactInfoDto with _$ContactInfoDto {
  @FreezedUnionValue('MESSENGER')
  const factory ContactInfoDto.messenger({
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'messengerAccountID') @Default('') String messengerAccountId,
    @JsonKey(name: 'messengerAccountName') @Default('') String messengerAccountName,
    @JsonKey(name: 'messengerAccountAvatar') @Default('') String messengerAccountAvatar,
    @JsonKey(name: 'messengerPageID') @Default('') String messengerPageId,
  }) = MessengerContactInfoDto;

  @FreezedUnionValue('ZALO_PERSONAL')
  const factory ContactInfoDto.zalo({
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'zaloAccountID') @Default('') String zaloAccountId,
    @JsonKey(name: 'zalophone') @Default('') String zaloPhone,
    @JsonKey(name: 'zaloAccountName') @Default('') String zaloAccountName,
    @JsonKey(name: 'zaloAccountAvatar') @Default('') String zaloAccountAvatar,
    @JsonKey(name: 'zaloAppID') @Default('') String zaloAppId,
    @JsonKey(name: 'channelID') @Default('') String channelId,
  }) = ZaloContactInfoDto;

  @FreezedUnionValue('PHONE')
  const factory ContactInfoDto.phone({
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'phone') @Default('') String phone,
    @JsonKey(name: 'isSpam') @Default(false) bool isSpam,
  }) = PhoneContactInfoDto;

  @FreezedUnionValue('UNKNOWN')
  const factory ContactInfoDto.unknown() = UnknownContactInfoDto;

  factory ContactInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoDtoFromJson(json);
}