import 'package:freezed_annotation/freezed_annotation.dart';
import 'contact_info_dto.dart';

part 'customer_info_dto.freezed.dart';
part 'customer_info_dto.g.dart';

@freezed
class CustomerInfoDto with _$CustomerInfoDto {
  const factory CustomerInfoDto({
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @Default('') String name,
    @JsonKey(name: 'contactInfo') @Default([]) List<ContactInfoDto> contactInfo,
  }) = _CustomerInfoDto;

  factory CustomerInfoDto.fromJson(Map<String, dynamic> json) => 
      _$CustomerInfoDtoFromJson(json);
}