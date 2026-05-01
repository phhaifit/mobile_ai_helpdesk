import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_support_info_dto.freezed.dart';
part 'customer_support_info_dto.g.dart';

@freezed
class CustomerSupportInfoDto with _$CustomerSupportInfoDto {
  const factory CustomerSupportInfoDto({
    @JsonKey(name: 'customerSupportID') @Default('') String customerSupportId,
    @JsonKey(name: 'fullname') @Default('') String fullname,
    @JsonKey(name: 'avatar') @Default('') String avatar,
  }) = _CustomerSupportInfoDto;

  factory CustomerSupportInfoDto.fromJson(Map<String, dynamic> json) => 
      _$CustomerSupportInfoDtoFromJson(json);
}