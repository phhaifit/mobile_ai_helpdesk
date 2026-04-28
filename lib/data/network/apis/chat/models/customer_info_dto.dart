import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_info_dto.freezed.dart';
part 'customer_info_dto.g.dart';

@freezed
class CustomerInfoDto with _$CustomerInfoDto {
  const factory CustomerInfoDto({
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @Default('') String name,
  }) = _CustomerInfoDto;

  factory CustomerInfoDto.fromJson(Map<String, dynamic> json) => 
      _$CustomerInfoDtoFromJson(json);
}