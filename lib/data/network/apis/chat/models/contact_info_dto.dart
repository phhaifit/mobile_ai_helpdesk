import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info_dto.freezed.dart';
part 'contact_info_dto.g.dart';

@freezed
class ContactInfoDto with _$ContactInfoDto {
  const factory ContactInfoDto({
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @Default('') String name,
    @Default(false) bool isSpam,
    @JsonKey(name: 'zaloAccountID') String? zaloAccountId,
    String? email,
    String? phone,
    @JsonKey(name: 'messengerAccountID') String? messengerAccountId,
    @JsonKey(name: 'zohoAccountID') String? zohoAccountId,
  }) = _ContactInfoDto;

  factory ContactInfoDto.fromJson(Map<String, dynamic> json) => 
      _$ContactInfoDtoFromJson(json);
}