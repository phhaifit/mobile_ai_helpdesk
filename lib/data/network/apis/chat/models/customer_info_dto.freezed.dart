// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerInfoDto _$CustomerInfoDtoFromJson(Map<String, dynamic> json) {
  return _CustomerInfoDto.fromJson(json);
}

/// @nodoc
mixin _$CustomerInfoDto {
  @JsonKey(name: 'customerID')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'contactID')
  String get contactId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'contactInfo')
  List<ContactInfoDto> get contactInfo => throw _privateConstructorUsedError;

  /// Serializes this CustomerInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerInfoDtoCopyWith<CustomerInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerInfoDtoCopyWith<$Res> {
  factory $CustomerInfoDtoCopyWith(
    CustomerInfoDto value,
    $Res Function(CustomerInfoDto) then,
  ) = _$CustomerInfoDtoCopyWithImpl<$Res, CustomerInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'customerID') String customerId,
    @JsonKey(name: 'contactID') String contactId,
    String name,
    @JsonKey(name: 'contactInfo') List<ContactInfoDto> contactInfo,
  });
}

/// @nodoc
class _$CustomerInfoDtoCopyWithImpl<$Res, $Val extends CustomerInfoDto>
    implements $CustomerInfoDtoCopyWith<$Res> {
  _$CustomerInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? contactId = null,
    Object? name = null,
    Object? contactInfo = null,
  }) {
    return _then(
      _value.copyWith(
            customerId:
                null == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String,
            contactId:
                null == contactId
                    ? _value.contactId
                    : contactId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            contactInfo:
                null == contactInfo
                    ? _value.contactInfo
                    : contactInfo // ignore: cast_nullable_to_non_nullable
                        as List<ContactInfoDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerInfoDtoImplCopyWith<$Res>
    implements $CustomerInfoDtoCopyWith<$Res> {
  factory _$$CustomerInfoDtoImplCopyWith(
    _$CustomerInfoDtoImpl value,
    $Res Function(_$CustomerInfoDtoImpl) then,
  ) = __$$CustomerInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'customerID') String customerId,
    @JsonKey(name: 'contactID') String contactId,
    String name,
    @JsonKey(name: 'contactInfo') List<ContactInfoDto> contactInfo,
  });
}

/// @nodoc
class __$$CustomerInfoDtoImplCopyWithImpl<$Res>
    extends _$CustomerInfoDtoCopyWithImpl<$Res, _$CustomerInfoDtoImpl>
    implements _$$CustomerInfoDtoImplCopyWith<$Res> {
  __$$CustomerInfoDtoImplCopyWithImpl(
    _$CustomerInfoDtoImpl _value,
    $Res Function(_$CustomerInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? contactId = null,
    Object? name = null,
    Object? contactInfo = null,
  }) {
    return _then(
      _$CustomerInfoDtoImpl(
        customerId:
            null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String,
        contactId:
            null == contactId
                ? _value.contactId
                : contactId // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        contactInfo:
            null == contactInfo
                ? _value._contactInfo
                : contactInfo // ignore: cast_nullable_to_non_nullable
                    as List<ContactInfoDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInfoDtoImpl implements _CustomerInfoDto {
  const _$CustomerInfoDtoImpl({
    @JsonKey(name: 'customerID') this.customerId = '',
    @JsonKey(name: 'contactID') this.contactId = '',
    this.name = '',
    @JsonKey(name: 'contactInfo')
    final List<ContactInfoDto> contactInfo = const [],
  }) : _contactInfo = contactInfo;

  factory _$CustomerInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'customerID')
  final String customerId;
  @override
  @JsonKey(name: 'contactID')
  final String contactId;
  @override
  @JsonKey()
  final String name;
  final List<ContactInfoDto> _contactInfo;
  @override
  @JsonKey(name: 'contactInfo')
  List<ContactInfoDto> get contactInfo {
    if (_contactInfo is EqualUnmodifiableListView) return _contactInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contactInfo);
  }

  @override
  String toString() {
    return 'CustomerInfoDto(customerId: $customerId, contactId: $contactId, name: $name, contactInfo: $contactInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInfoDtoImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._contactInfo,
              _contactInfo,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    customerId,
    contactId,
    name,
    const DeepCollectionEquality().hash(_contactInfo),
  );

  /// Create a copy of CustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerInfoDtoImplCopyWith<_$CustomerInfoDtoImpl> get copyWith =>
      __$$CustomerInfoDtoImplCopyWithImpl<_$CustomerInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerInfoDtoImplToJson(this);
  }
}

abstract class _CustomerInfoDto implements CustomerInfoDto {
  const factory _CustomerInfoDto({
    @JsonKey(name: 'customerID') final String customerId,
    @JsonKey(name: 'contactID') final String contactId,
    final String name,
    @JsonKey(name: 'contactInfo') final List<ContactInfoDto> contactInfo,
  }) = _$CustomerInfoDtoImpl;

  factory _CustomerInfoDto.fromJson(Map<String, dynamic> json) =
      _$CustomerInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'customerID')
  String get customerId;
  @override
  @JsonKey(name: 'contactID')
  String get contactId;
  @override
  String get name;
  @override
  @JsonKey(name: 'contactInfo')
  List<ContactInfoDto> get contactInfo;

  /// Create a copy of CustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerInfoDtoImplCopyWith<_$CustomerInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
