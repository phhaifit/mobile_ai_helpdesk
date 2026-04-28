// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContactInfoDto _$ContactInfoDtoFromJson(Map<String, dynamic> json) {
  return _ContactInfoDto.fromJson(json);
}

/// @nodoc
mixin _$ContactInfoDto {
  @JsonKey(name: 'contactID')
  String get contactId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customerID')
  String get customerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isSpam => throw _privateConstructorUsedError;
  @JsonKey(name: 'zaloAccountID')
  String? get zaloAccountId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'messengerAccountID')
  String? get messengerAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'zohoAccountID')
  String? get zohoAccountId => throw _privateConstructorUsedError;

  /// Serializes this ContactInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactInfoDtoCopyWith<ContactInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoDtoCopyWith<$Res> {
  factory $ContactInfoDtoCopyWith(
    ContactInfoDto value,
    $Res Function(ContactInfoDto) then,
  ) = _$ContactInfoDtoCopyWithImpl<$Res, ContactInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'customerID') String customerId,
    String name,
    bool isSpam,
    @JsonKey(name: 'zaloAccountID') String? zaloAccountId,
    String? email,
    String? phone,
    @JsonKey(name: 'messengerAccountID') String? messengerAccountId,
    @JsonKey(name: 'zohoAccountID') String? zohoAccountId,
  });
}

/// @nodoc
class _$ContactInfoDtoCopyWithImpl<$Res, $Val extends ContactInfoDto>
    implements $ContactInfoDtoCopyWith<$Res> {
  _$ContactInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
    Object? customerId = null,
    Object? name = null,
    Object? isSpam = null,
    Object? zaloAccountId = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? messengerAccountId = freezed,
    Object? zohoAccountId = freezed,
  }) {
    return _then(
      _value.copyWith(
            contactId:
                null == contactId
                    ? _value.contactId
                    : contactId // ignore: cast_nullable_to_non_nullable
                        as String,
            customerId:
                null == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            isSpam:
                null == isSpam
                    ? _value.isSpam
                    : isSpam // ignore: cast_nullable_to_non_nullable
                        as bool,
            zaloAccountId:
                freezed == zaloAccountId
                    ? _value.zaloAccountId
                    : zaloAccountId // ignore: cast_nullable_to_non_nullable
                        as String?,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            messengerAccountId:
                freezed == messengerAccountId
                    ? _value.messengerAccountId
                    : messengerAccountId // ignore: cast_nullable_to_non_nullable
                        as String?,
            zohoAccountId:
                freezed == zohoAccountId
                    ? _value.zohoAccountId
                    : zohoAccountId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContactInfoDtoImplCopyWith<$Res>
    implements $ContactInfoDtoCopyWith<$Res> {
  factory _$$ContactInfoDtoImplCopyWith(
    _$ContactInfoDtoImpl value,
    $Res Function(_$ContactInfoDtoImpl) then,
  ) = __$$ContactInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'customerID') String customerId,
    String name,
    bool isSpam,
    @JsonKey(name: 'zaloAccountID') String? zaloAccountId,
    String? email,
    String? phone,
    @JsonKey(name: 'messengerAccountID') String? messengerAccountId,
    @JsonKey(name: 'zohoAccountID') String? zohoAccountId,
  });
}

/// @nodoc
class __$$ContactInfoDtoImplCopyWithImpl<$Res>
    extends _$ContactInfoDtoCopyWithImpl<$Res, _$ContactInfoDtoImpl>
    implements _$$ContactInfoDtoImplCopyWith<$Res> {
  __$$ContactInfoDtoImplCopyWithImpl(
    _$ContactInfoDtoImpl _value,
    $Res Function(_$ContactInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
    Object? customerId = null,
    Object? name = null,
    Object? isSpam = null,
    Object? zaloAccountId = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? messengerAccountId = freezed,
    Object? zohoAccountId = freezed,
  }) {
    return _then(
      _$ContactInfoDtoImpl(
        contactId:
            null == contactId
                ? _value.contactId
                : contactId // ignore: cast_nullable_to_non_nullable
                    as String,
        customerId:
            null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        isSpam:
            null == isSpam
                ? _value.isSpam
                : isSpam // ignore: cast_nullable_to_non_nullable
                    as bool,
        zaloAccountId:
            freezed == zaloAccountId
                ? _value.zaloAccountId
                : zaloAccountId // ignore: cast_nullable_to_non_nullable
                    as String?,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        messengerAccountId:
            freezed == messengerAccountId
                ? _value.messengerAccountId
                : messengerAccountId // ignore: cast_nullable_to_non_nullable
                    as String?,
        zohoAccountId:
            freezed == zohoAccountId
                ? _value.zohoAccountId
                : zohoAccountId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactInfoDtoImpl implements _ContactInfoDto {
  const _$ContactInfoDtoImpl({
    @JsonKey(name: 'contactID') this.contactId = '',
    @JsonKey(name: 'customerID') this.customerId = '',
    this.name = '',
    this.isSpam = false,
    @JsonKey(name: 'zaloAccountID') this.zaloAccountId,
    this.email,
    this.phone,
    @JsonKey(name: 'messengerAccountID') this.messengerAccountId,
    @JsonKey(name: 'zohoAccountID') this.zohoAccountId,
  });

  factory _$ContactInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'contactID')
  final String contactId;
  @override
  @JsonKey(name: 'customerID')
  final String customerId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final bool isSpam;
  @override
  @JsonKey(name: 'zaloAccountID')
  final String? zaloAccountId;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'messengerAccountID')
  final String? messengerAccountId;
  @override
  @JsonKey(name: 'zohoAccountID')
  final String? zohoAccountId;

  @override
  String toString() {
    return 'ContactInfoDto(contactId: $contactId, customerId: $customerId, name: $name, isSpam: $isSpam, zaloAccountId: $zaloAccountId, email: $email, phone: $phone, messengerAccountId: $messengerAccountId, zohoAccountId: $zohoAccountId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoDtoImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isSpam, isSpam) || other.isSpam == isSpam) &&
            (identical(other.zaloAccountId, zaloAccountId) ||
                other.zaloAccountId == zaloAccountId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.messengerAccountId, messengerAccountId) ||
                other.messengerAccountId == messengerAccountId) &&
            (identical(other.zohoAccountId, zohoAccountId) ||
                other.zohoAccountId == zohoAccountId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    contactId,
    customerId,
    name,
    isSpam,
    zaloAccountId,
    email,
    phone,
    messengerAccountId,
    zohoAccountId,
  );

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoDtoImplCopyWith<_$ContactInfoDtoImpl> get copyWith =>
      __$$ContactInfoDtoImplCopyWithImpl<_$ContactInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoDtoImplToJson(this);
  }
}

abstract class _ContactInfoDto implements ContactInfoDto {
  const factory _ContactInfoDto({
    @JsonKey(name: 'contactID') final String contactId,
    @JsonKey(name: 'customerID') final String customerId,
    final String name,
    final bool isSpam,
    @JsonKey(name: 'zaloAccountID') final String? zaloAccountId,
    final String? email,
    final String? phone,
    @JsonKey(name: 'messengerAccountID') final String? messengerAccountId,
    @JsonKey(name: 'zohoAccountID') final String? zohoAccountId,
  }) = _$ContactInfoDtoImpl;

  factory _ContactInfoDto.fromJson(Map<String, dynamic> json) =
      _$ContactInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'contactID')
  String get contactId;
  @override
  @JsonKey(name: 'customerID')
  String get customerId;
  @override
  String get name;
  @override
  bool get isSpam;
  @override
  @JsonKey(name: 'zaloAccountID')
  String? get zaloAccountId;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'messengerAccountID')
  String? get messengerAccountId;
  @override
  @JsonKey(name: 'zohoAccountID')
  String? get zohoAccountId;

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactInfoDtoImplCopyWith<_$ContactInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
