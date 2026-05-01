// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_support_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerSupportInfoDto _$CustomerSupportInfoDtoFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerSupportInfoDto.fromJson(json);
}

/// @nodoc
mixin _$CustomerSupportInfoDto {
  @JsonKey(name: 'customerSupportID')
  String get customerSupportId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullname')
  String get fullname => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar')
  String get avatar => throw _privateConstructorUsedError;

  /// Serializes this CustomerSupportInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerSupportInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerSupportInfoDtoCopyWith<CustomerSupportInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerSupportInfoDtoCopyWith<$Res> {
  factory $CustomerSupportInfoDtoCopyWith(
    CustomerSupportInfoDto value,
    $Res Function(CustomerSupportInfoDto) then,
  ) = _$CustomerSupportInfoDtoCopyWithImpl<$Res, CustomerSupportInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'customerSupportID') String customerSupportId,
    @JsonKey(name: 'fullname') String fullname,
    @JsonKey(name: 'avatar') String avatar,
  });
}

/// @nodoc
class _$CustomerSupportInfoDtoCopyWithImpl<
  $Res,
  $Val extends CustomerSupportInfoDto
>
    implements $CustomerSupportInfoDtoCopyWith<$Res> {
  _$CustomerSupportInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerSupportInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerSupportId = null,
    Object? fullname = null,
    Object? avatar = null,
  }) {
    return _then(
      _value.copyWith(
            customerSupportId:
                null == customerSupportId
                    ? _value.customerSupportId
                    : customerSupportId // ignore: cast_nullable_to_non_nullable
                        as String,
            fullname:
                null == fullname
                    ? _value.fullname
                    : fullname // ignore: cast_nullable_to_non_nullable
                        as String,
            avatar:
                null == avatar
                    ? _value.avatar
                    : avatar // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerSupportInfoDtoImplCopyWith<$Res>
    implements $CustomerSupportInfoDtoCopyWith<$Res> {
  factory _$$CustomerSupportInfoDtoImplCopyWith(
    _$CustomerSupportInfoDtoImpl value,
    $Res Function(_$CustomerSupportInfoDtoImpl) then,
  ) = __$$CustomerSupportInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'customerSupportID') String customerSupportId,
    @JsonKey(name: 'fullname') String fullname,
    @JsonKey(name: 'avatar') String avatar,
  });
}

/// @nodoc
class __$$CustomerSupportInfoDtoImplCopyWithImpl<$Res>
    extends
        _$CustomerSupportInfoDtoCopyWithImpl<$Res, _$CustomerSupportInfoDtoImpl>
    implements _$$CustomerSupportInfoDtoImplCopyWith<$Res> {
  __$$CustomerSupportInfoDtoImplCopyWithImpl(
    _$CustomerSupportInfoDtoImpl _value,
    $Res Function(_$CustomerSupportInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerSupportInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerSupportId = null,
    Object? fullname = null,
    Object? avatar = null,
  }) {
    return _then(
      _$CustomerSupportInfoDtoImpl(
        customerSupportId:
            null == customerSupportId
                ? _value.customerSupportId
                : customerSupportId // ignore: cast_nullable_to_non_nullable
                    as String,
        fullname:
            null == fullname
                ? _value.fullname
                : fullname // ignore: cast_nullable_to_non_nullable
                    as String,
        avatar:
            null == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerSupportInfoDtoImpl implements _CustomerSupportInfoDto {
  const _$CustomerSupportInfoDtoImpl({
    @JsonKey(name: 'customerSupportID') this.customerSupportId = '',
    @JsonKey(name: 'fullname') this.fullname = '',
    @JsonKey(name: 'avatar') this.avatar = '',
  });

  factory _$CustomerSupportInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerSupportInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'customerSupportID')
  final String customerSupportId;
  @override
  @JsonKey(name: 'fullname')
  final String fullname;
  @override
  @JsonKey(name: 'avatar')
  final String avatar;

  @override
  String toString() {
    return 'CustomerSupportInfoDto(customerSupportId: $customerSupportId, fullname: $fullname, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerSupportInfoDtoImpl &&
            (identical(other.customerSupportId, customerSupportId) ||
                other.customerSupportId == customerSupportId) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, customerSupportId, fullname, avatar);

  /// Create a copy of CustomerSupportInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerSupportInfoDtoImplCopyWith<_$CustomerSupportInfoDtoImpl>
  get copyWith =>
      __$$CustomerSupportInfoDtoImplCopyWithImpl<_$CustomerSupportInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerSupportInfoDtoImplToJson(this);
  }
}

abstract class _CustomerSupportInfoDto implements CustomerSupportInfoDto {
  const factory _CustomerSupportInfoDto({
    @JsonKey(name: 'customerSupportID') final String customerSupportId,
    @JsonKey(name: 'fullname') final String fullname,
    @JsonKey(name: 'avatar') final String avatar,
  }) = _$CustomerSupportInfoDtoImpl;

  factory _CustomerSupportInfoDto.fromJson(Map<String, dynamic> json) =
      _$CustomerSupportInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'customerSupportID')
  String get customerSupportId;
  @override
  @JsonKey(name: 'fullname')
  String get fullname;
  @override
  @JsonKey(name: 'avatar')
  String get avatar;

  /// Create a copy of CustomerSupportInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerSupportInfoDtoImplCopyWith<_$CustomerSupportInfoDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
