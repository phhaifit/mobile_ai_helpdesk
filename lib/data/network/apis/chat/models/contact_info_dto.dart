import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info_dto.freezed.dart';
part 'contact_info_dto.g.dart';

@freezed
class ContactInfoDto with _$ContactInfoDto {
  const factory ContactInfoDto.messenger({
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'messengerAccountID') @Default('') String messengerAccountId,
    @JsonKey(name: 'messengerAccountName') @Default('') String messengerAccountName,
    @JsonKey(name: 'messengerAccountAvatar') @Default('') String messengerAccountAvatar,
    @JsonKey(name: 'messengerPageID') @Default('') String messengerPageId,
  }) = MessengerContactInfoDto;

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

  const factory ContactInfoDto.phone({
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'phone') @Default('') String phone,
    @JsonKey(name: 'isSpam') @Default(false) bool isSpam,
  }) = PhoneContactInfoDto;

  const factory ContactInfoDto.unknown() = UnknownContactInfoDto;

  factory ContactInfoDto.fromJson(Map<String, dynamic> json) => 
      _$ContactInfoDtoFromJson(json);
}

extension ContactInfoDtoMapper on ContactInfoDto {
  static ContactInfoDto fromJson(Map<String, dynamic> json) {
    final type = json['name'];

    switch (type) {
      case 'MESSENGER':
        return ContactInfoDto.messenger(
          contactId: json['contactID'] as String,
          customerId: json['customerID'] as String,
          messengerAccountId: json['messengerAccountID'] as String,
          messengerAccountName: json['messengerAccountName'] as String,
          messengerAccountAvatar: json['messengerAccountAvatar'] as String,
          messengerPageId: json['messengerPageID'] as String,
        );

      case 'ZALO_PERSONAL':
        return ContactInfoDto.zalo(
          contactId: json['contactID'] as String,
          customerId: json['customerID'] as String,
          zaloAccountId: json['zaloAccountID'] as String,
          zaloAccountName: json['zaloAccountName'] as String,
          zaloAccountAvatar: json['zaloAccountAvatar'] as String,
          zaloPhone: json['zalophone'] as String,
          channelId: json['channelID'] as String,
        );

      case 'PHONE':
        return ContactInfoDto.phone(
          contactId: json['contactID'] as String,
          customerId: json['customerID'] as String,
          phone: json['phone'] as String,
          isSpam: json['isSpam'] as bool,
        );

      default:
        return const ContactInfoDto.unknown();
    }
  }
}