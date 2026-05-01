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
  switch (json['runtimeType']) {
    case 'messenger':
      return MessengerContactInfoDto.fromJson(json);
    case 'zalo':
      return ZaloContactInfoDto.fromJson(json);
    case 'phone':
      return PhoneContactInfoDto.fromJson(json);
    case 'unknown':
      return UnknownContactInfoDto.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'ContactInfoDto',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$ContactInfoDto {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )
    zalo,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )
    phone,
    required TResult Function() unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult? Function()? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContactInfoDto value) messenger,
    required TResult Function(ZaloContactInfoDto value) zalo,
    required TResult Function(PhoneContactInfoDto value) phone,
    required TResult Function(UnknownContactInfoDto value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContactInfoDto value)? messenger,
    TResult? Function(ZaloContactInfoDto value)? zalo,
    TResult? Function(PhoneContactInfoDto value)? phone,
    TResult? Function(UnknownContactInfoDto value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContactInfoDto value)? messenger,
    TResult Function(ZaloContactInfoDto value)? zalo,
    TResult Function(PhoneContactInfoDto value)? phone,
    TResult Function(UnknownContactInfoDto value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this ContactInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoDtoCopyWith<$Res> {
  factory $ContactInfoDtoCopyWith(
    ContactInfoDto value,
    $Res Function(ContactInfoDto) then,
  ) = _$ContactInfoDtoCopyWithImpl<$Res, ContactInfoDto>;
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
}

/// @nodoc
abstract class _$$MessengerContactInfoDtoImplCopyWith<$Res> {
  factory _$$MessengerContactInfoDtoImplCopyWith(
    _$MessengerContactInfoDtoImpl value,
    $Res Function(_$MessengerContactInfoDtoImpl) then,
  ) = __$$MessengerContactInfoDtoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'customerID') String customerId,
    @JsonKey(name: 'messengerAccountID') String messengerAccountId,
    @JsonKey(name: 'messengerAccountName') String messengerAccountName,
    @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
    @JsonKey(name: 'messengerPageID') String messengerPageId,
  });
}

/// @nodoc
class __$$MessengerContactInfoDtoImplCopyWithImpl<$Res>
    extends _$ContactInfoDtoCopyWithImpl<$Res, _$MessengerContactInfoDtoImpl>
    implements _$$MessengerContactInfoDtoImplCopyWith<$Res> {
  __$$MessengerContactInfoDtoImplCopyWithImpl(
    _$MessengerContactInfoDtoImpl _value,
    $Res Function(_$MessengerContactInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
    Object? customerId = null,
    Object? messengerAccountId = null,
    Object? messengerAccountName = null,
    Object? messengerAccountAvatar = null,
    Object? messengerPageId = null,
  }) {
    return _then(
      _$MessengerContactInfoDtoImpl(
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
        messengerAccountId:
            null == messengerAccountId
                ? _value.messengerAccountId
                : messengerAccountId // ignore: cast_nullable_to_non_nullable
                    as String,
        messengerAccountName:
            null == messengerAccountName
                ? _value.messengerAccountName
                : messengerAccountName // ignore: cast_nullable_to_non_nullable
                    as String,
        messengerAccountAvatar:
            null == messengerAccountAvatar
                ? _value.messengerAccountAvatar
                : messengerAccountAvatar // ignore: cast_nullable_to_non_nullable
                    as String,
        messengerPageId:
            null == messengerPageId
                ? _value.messengerPageId
                : messengerPageId // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessengerContactInfoDtoImpl implements MessengerContactInfoDto {
  const _$MessengerContactInfoDtoImpl({
    @JsonKey(name: 'contactID') this.contactId = '',
    @JsonKey(name: 'customerID') this.customerId = '',
    @JsonKey(name: 'messengerAccountID') this.messengerAccountId = '',
    @JsonKey(name: 'messengerAccountName') this.messengerAccountName = '',
    @JsonKey(name: 'messengerAccountAvatar') this.messengerAccountAvatar = '',
    @JsonKey(name: 'messengerPageID') this.messengerPageId = '',
    final String? $type,
  }) : $type = $type ?? 'messenger';

  factory _$MessengerContactInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessengerContactInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'contactID')
  final String contactId;
  @override
  @JsonKey(name: 'customerID')
  final String customerId;
  @override
  @JsonKey(name: 'messengerAccountID')
  final String messengerAccountId;
  @override
  @JsonKey(name: 'messengerAccountName')
  final String messengerAccountName;
  @override
  @JsonKey(name: 'messengerAccountAvatar')
  final String messengerAccountAvatar;
  @override
  @JsonKey(name: 'messengerPageID')
  final String messengerPageId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContactInfoDto.messenger(contactId: $contactId, customerId: $customerId, messengerAccountId: $messengerAccountId, messengerAccountName: $messengerAccountName, messengerAccountAvatar: $messengerAccountAvatar, messengerPageId: $messengerPageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessengerContactInfoDtoImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.messengerAccountId, messengerAccountId) ||
                other.messengerAccountId == messengerAccountId) &&
            (identical(other.messengerAccountName, messengerAccountName) ||
                other.messengerAccountName == messengerAccountName) &&
            (identical(other.messengerAccountAvatar, messengerAccountAvatar) ||
                other.messengerAccountAvatar == messengerAccountAvatar) &&
            (identical(other.messengerPageId, messengerPageId) ||
                other.messengerPageId == messengerPageId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    contactId,
    customerId,
    messengerAccountId,
    messengerAccountName,
    messengerAccountAvatar,
    messengerPageId,
  );

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessengerContactInfoDtoImplCopyWith<_$MessengerContactInfoDtoImpl>
  get copyWith => __$$MessengerContactInfoDtoImplCopyWithImpl<
    _$MessengerContactInfoDtoImpl
  >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )
    zalo,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )
    phone,
    required TResult Function() unknown,
  }) {
    return messenger(
      contactId,
      customerId,
      messengerAccountId,
      messengerAccountName,
      messengerAccountAvatar,
      messengerPageId,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult? Function()? unknown,
  }) {
    return messenger?.call(
      contactId,
      customerId,
      messengerAccountId,
      messengerAccountName,
      messengerAccountAvatar,
      messengerPageId,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (messenger != null) {
      return messenger(
        contactId,
        customerId,
        messengerAccountId,
        messengerAccountName,
        messengerAccountAvatar,
        messengerPageId,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContactInfoDto value) messenger,
    required TResult Function(ZaloContactInfoDto value) zalo,
    required TResult Function(PhoneContactInfoDto value) phone,
    required TResult Function(UnknownContactInfoDto value) unknown,
  }) {
    return messenger(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContactInfoDto value)? messenger,
    TResult? Function(ZaloContactInfoDto value)? zalo,
    TResult? Function(PhoneContactInfoDto value)? phone,
    TResult? Function(UnknownContactInfoDto value)? unknown,
  }) {
    return messenger?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContactInfoDto value)? messenger,
    TResult Function(ZaloContactInfoDto value)? zalo,
    TResult Function(PhoneContactInfoDto value)? phone,
    TResult Function(UnknownContactInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (messenger != null) {
      return messenger(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessengerContactInfoDtoImplToJson(this);
  }
}

abstract class MessengerContactInfoDto implements ContactInfoDto {
  const factory MessengerContactInfoDto({
    @JsonKey(name: 'contactID') final String contactId,
    @JsonKey(name: 'customerID') final String customerId,
    @JsonKey(name: 'messengerAccountID') final String messengerAccountId,
    @JsonKey(name: 'messengerAccountName') final String messengerAccountName,
    @JsonKey(name: 'messengerAccountAvatar')
    final String messengerAccountAvatar,
    @JsonKey(name: 'messengerPageID') final String messengerPageId,
  }) = _$MessengerContactInfoDtoImpl;

  factory MessengerContactInfoDto.fromJson(Map<String, dynamic> json) =
      _$MessengerContactInfoDtoImpl.fromJson;

  @JsonKey(name: 'contactID')
  String get contactId;
  @JsonKey(name: 'customerID')
  String get customerId;
  @JsonKey(name: 'messengerAccountID')
  String get messengerAccountId;
  @JsonKey(name: 'messengerAccountName')
  String get messengerAccountName;
  @JsonKey(name: 'messengerAccountAvatar')
  String get messengerAccountAvatar;
  @JsonKey(name: 'messengerPageID')
  String get messengerPageId;

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessengerContactInfoDtoImplCopyWith<_$MessengerContactInfoDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ZaloContactInfoDtoImplCopyWith<$Res> {
  factory _$$ZaloContactInfoDtoImplCopyWith(
    _$ZaloContactInfoDtoImpl value,
    $Res Function(_$ZaloContactInfoDtoImpl) then,
  ) = __$$ZaloContactInfoDtoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'customerID') String customerId,
    @JsonKey(name: 'zaloAccountID') String zaloAccountId,
    @JsonKey(name: 'zalophone') String zaloPhone,
    @JsonKey(name: 'zaloAccountName') String zaloAccountName,
    @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
    @JsonKey(name: 'zaloAppID') String zaloAppId,
    @JsonKey(name: 'channelID') String channelId,
  });
}

/// @nodoc
class __$$ZaloContactInfoDtoImplCopyWithImpl<$Res>
    extends _$ContactInfoDtoCopyWithImpl<$Res, _$ZaloContactInfoDtoImpl>
    implements _$$ZaloContactInfoDtoImplCopyWith<$Res> {
  __$$ZaloContactInfoDtoImplCopyWithImpl(
    _$ZaloContactInfoDtoImpl _value,
    $Res Function(_$ZaloContactInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
    Object? customerId = null,
    Object? zaloAccountId = null,
    Object? zaloPhone = null,
    Object? zaloAccountName = null,
    Object? zaloAccountAvatar = null,
    Object? zaloAppId = null,
    Object? channelId = null,
  }) {
    return _then(
      _$ZaloContactInfoDtoImpl(
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
        zaloAccountId:
            null == zaloAccountId
                ? _value.zaloAccountId
                : zaloAccountId // ignore: cast_nullable_to_non_nullable
                    as String,
        zaloPhone:
            null == zaloPhone
                ? _value.zaloPhone
                : zaloPhone // ignore: cast_nullable_to_non_nullable
                    as String,
        zaloAccountName:
            null == zaloAccountName
                ? _value.zaloAccountName
                : zaloAccountName // ignore: cast_nullable_to_non_nullable
                    as String,
        zaloAccountAvatar:
            null == zaloAccountAvatar
                ? _value.zaloAccountAvatar
                : zaloAccountAvatar // ignore: cast_nullable_to_non_nullable
                    as String,
        zaloAppId:
            null == zaloAppId
                ? _value.zaloAppId
                : zaloAppId // ignore: cast_nullable_to_non_nullable
                    as String,
        channelId:
            null == channelId
                ? _value.channelId
                : channelId // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZaloContactInfoDtoImpl implements ZaloContactInfoDto {
  const _$ZaloContactInfoDtoImpl({
    @JsonKey(name: 'contactID') this.contactId = '',
    @JsonKey(name: 'customerID') this.customerId = '',
    @JsonKey(name: 'zaloAccountID') this.zaloAccountId = '',
    @JsonKey(name: 'zalophone') this.zaloPhone = '',
    @JsonKey(name: 'zaloAccountName') this.zaloAccountName = '',
    @JsonKey(name: 'zaloAccountAvatar') this.zaloAccountAvatar = '',
    @JsonKey(name: 'zaloAppID') this.zaloAppId = '',
    @JsonKey(name: 'channelID') this.channelId = '',
    final String? $type,
  }) : $type = $type ?? 'zalo';

  factory _$ZaloContactInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZaloContactInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'contactID')
  final String contactId;
  @override
  @JsonKey(name: 'customerID')
  final String customerId;
  @override
  @JsonKey(name: 'zaloAccountID')
  final String zaloAccountId;
  @override
  @JsonKey(name: 'zalophone')
  final String zaloPhone;
  @override
  @JsonKey(name: 'zaloAccountName')
  final String zaloAccountName;
  @override
  @JsonKey(name: 'zaloAccountAvatar')
  final String zaloAccountAvatar;
  @override
  @JsonKey(name: 'zaloAppID')
  final String zaloAppId;
  @override
  @JsonKey(name: 'channelID')
  final String channelId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContactInfoDto.zalo(contactId: $contactId, customerId: $customerId, zaloAccountId: $zaloAccountId, zaloPhone: $zaloPhone, zaloAccountName: $zaloAccountName, zaloAccountAvatar: $zaloAccountAvatar, zaloAppId: $zaloAppId, channelId: $channelId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZaloContactInfoDtoImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.zaloAccountId, zaloAccountId) ||
                other.zaloAccountId == zaloAccountId) &&
            (identical(other.zaloPhone, zaloPhone) ||
                other.zaloPhone == zaloPhone) &&
            (identical(other.zaloAccountName, zaloAccountName) ||
                other.zaloAccountName == zaloAccountName) &&
            (identical(other.zaloAccountAvatar, zaloAccountAvatar) ||
                other.zaloAccountAvatar == zaloAccountAvatar) &&
            (identical(other.zaloAppId, zaloAppId) ||
                other.zaloAppId == zaloAppId) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    contactId,
    customerId,
    zaloAccountId,
    zaloPhone,
    zaloAccountName,
    zaloAccountAvatar,
    zaloAppId,
    channelId,
  );

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZaloContactInfoDtoImplCopyWith<_$ZaloContactInfoDtoImpl> get copyWith =>
      __$$ZaloContactInfoDtoImplCopyWithImpl<_$ZaloContactInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )
    zalo,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )
    phone,
    required TResult Function() unknown,
  }) {
    return zalo(
      contactId,
      customerId,
      zaloAccountId,
      zaloPhone,
      zaloAccountName,
      zaloAccountAvatar,
      zaloAppId,
      channelId,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult? Function()? unknown,
  }) {
    return zalo?.call(
      contactId,
      customerId,
      zaloAccountId,
      zaloPhone,
      zaloAccountName,
      zaloAccountAvatar,
      zaloAppId,
      channelId,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (zalo != null) {
      return zalo(
        contactId,
        customerId,
        zaloAccountId,
        zaloPhone,
        zaloAccountName,
        zaloAccountAvatar,
        zaloAppId,
        channelId,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContactInfoDto value) messenger,
    required TResult Function(ZaloContactInfoDto value) zalo,
    required TResult Function(PhoneContactInfoDto value) phone,
    required TResult Function(UnknownContactInfoDto value) unknown,
  }) {
    return zalo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContactInfoDto value)? messenger,
    TResult? Function(ZaloContactInfoDto value)? zalo,
    TResult? Function(PhoneContactInfoDto value)? phone,
    TResult? Function(UnknownContactInfoDto value)? unknown,
  }) {
    return zalo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContactInfoDto value)? messenger,
    TResult Function(ZaloContactInfoDto value)? zalo,
    TResult Function(PhoneContactInfoDto value)? phone,
    TResult Function(UnknownContactInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (zalo != null) {
      return zalo(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ZaloContactInfoDtoImplToJson(this);
  }
}

abstract class ZaloContactInfoDto implements ContactInfoDto {
  const factory ZaloContactInfoDto({
    @JsonKey(name: 'contactID') final String contactId,
    @JsonKey(name: 'customerID') final String customerId,
    @JsonKey(name: 'zaloAccountID') final String zaloAccountId,
    @JsonKey(name: 'zalophone') final String zaloPhone,
    @JsonKey(name: 'zaloAccountName') final String zaloAccountName,
    @JsonKey(name: 'zaloAccountAvatar') final String zaloAccountAvatar,
    @JsonKey(name: 'zaloAppID') final String zaloAppId,
    @JsonKey(name: 'channelID') final String channelId,
  }) = _$ZaloContactInfoDtoImpl;

  factory ZaloContactInfoDto.fromJson(Map<String, dynamic> json) =
      _$ZaloContactInfoDtoImpl.fromJson;

  @JsonKey(name: 'contactID')
  String get contactId;
  @JsonKey(name: 'customerID')
  String get customerId;
  @JsonKey(name: 'zaloAccountID')
  String get zaloAccountId;
  @JsonKey(name: 'zalophone')
  String get zaloPhone;
  @JsonKey(name: 'zaloAccountName')
  String get zaloAccountName;
  @JsonKey(name: 'zaloAccountAvatar')
  String get zaloAccountAvatar;
  @JsonKey(name: 'zaloAppID')
  String get zaloAppId;
  @JsonKey(name: 'channelID')
  String get channelId;

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZaloContactInfoDtoImplCopyWith<_$ZaloContactInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PhoneContactInfoDtoImplCopyWith<$Res> {
  factory _$$PhoneContactInfoDtoImplCopyWith(
    _$PhoneContactInfoDtoImpl value,
    $Res Function(_$PhoneContactInfoDtoImpl) then,
  ) = __$$PhoneContactInfoDtoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'customerID') String customerId,
    @JsonKey(name: 'phone') String phone,
    @JsonKey(name: 'isSpam') bool isSpam,
  });
}

/// @nodoc
class __$$PhoneContactInfoDtoImplCopyWithImpl<$Res>
    extends _$ContactInfoDtoCopyWithImpl<$Res, _$PhoneContactInfoDtoImpl>
    implements _$$PhoneContactInfoDtoImplCopyWith<$Res> {
  __$$PhoneContactInfoDtoImplCopyWithImpl(
    _$PhoneContactInfoDtoImpl _value,
    $Res Function(_$PhoneContactInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactId = null,
    Object? customerId = null,
    Object? phone = null,
    Object? isSpam = null,
  }) {
    return _then(
      _$PhoneContactInfoDtoImpl(
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
        phone:
            null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String,
        isSpam:
            null == isSpam
                ? _value.isSpam
                : isSpam // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhoneContactInfoDtoImpl implements PhoneContactInfoDto {
  const _$PhoneContactInfoDtoImpl({
    @JsonKey(name: 'contactID') this.contactId = '',
    @JsonKey(name: 'customerID') this.customerId = '',
    @JsonKey(name: 'phone') this.phone = '',
    @JsonKey(name: 'isSpam') this.isSpam = false,
    final String? $type,
  }) : $type = $type ?? 'phone';

  factory _$PhoneContactInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneContactInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'contactID')
  final String contactId;
  @override
  @JsonKey(name: 'customerID')
  final String customerId;
  @override
  @JsonKey(name: 'phone')
  final String phone;
  @override
  @JsonKey(name: 'isSpam')
  final bool isSpam;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContactInfoDto.phone(contactId: $contactId, customerId: $customerId, phone: $phone, isSpam: $isSpam)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneContactInfoDtoImpl &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isSpam, isSpam) || other.isSpam == isSpam));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, contactId, customerId, phone, isSpam);

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneContactInfoDtoImplCopyWith<_$PhoneContactInfoDtoImpl> get copyWith =>
      __$$PhoneContactInfoDtoImplCopyWithImpl<_$PhoneContactInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )
    zalo,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )
    phone,
    required TResult Function() unknown,
  }) {
    return phone(contactId, customerId, this.phone, isSpam);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult? Function()? unknown,
  }) {
    return phone?.call(contactId, customerId, this.phone, isSpam);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (phone != null) {
      return phone(contactId, customerId, this.phone, isSpam);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContactInfoDto value) messenger,
    required TResult Function(ZaloContactInfoDto value) zalo,
    required TResult Function(PhoneContactInfoDto value) phone,
    required TResult Function(UnknownContactInfoDto value) unknown,
  }) {
    return phone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContactInfoDto value)? messenger,
    TResult? Function(ZaloContactInfoDto value)? zalo,
    TResult? Function(PhoneContactInfoDto value)? phone,
    TResult? Function(UnknownContactInfoDto value)? unknown,
  }) {
    return phone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContactInfoDto value)? messenger,
    TResult Function(ZaloContactInfoDto value)? zalo,
    TResult Function(PhoneContactInfoDto value)? phone,
    TResult Function(UnknownContactInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (phone != null) {
      return phone(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneContactInfoDtoImplToJson(this);
  }
}

abstract class PhoneContactInfoDto implements ContactInfoDto {
  const factory PhoneContactInfoDto({
    @JsonKey(name: 'contactID') final String contactId,
    @JsonKey(name: 'customerID') final String customerId,
    @JsonKey(name: 'phone') final String phone,
    @JsonKey(name: 'isSpam') final bool isSpam,
  }) = _$PhoneContactInfoDtoImpl;

  factory PhoneContactInfoDto.fromJson(Map<String, dynamic> json) =
      _$PhoneContactInfoDtoImpl.fromJson;

  @JsonKey(name: 'contactID')
  String get contactId;
  @JsonKey(name: 'customerID')
  String get customerId;
  @JsonKey(name: 'phone')
  String get phone;
  @JsonKey(name: 'isSpam')
  bool get isSpam;

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneContactInfoDtoImplCopyWith<_$PhoneContactInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownContactInfoDtoImplCopyWith<$Res> {
  factory _$$UnknownContactInfoDtoImplCopyWith(
    _$UnknownContactInfoDtoImpl value,
    $Res Function(_$UnknownContactInfoDtoImpl) then,
  ) = __$$UnknownContactInfoDtoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnknownContactInfoDtoImplCopyWithImpl<$Res>
    extends _$ContactInfoDtoCopyWithImpl<$Res, _$UnknownContactInfoDtoImpl>
    implements _$$UnknownContactInfoDtoImplCopyWith<$Res> {
  __$$UnknownContactInfoDtoImplCopyWithImpl(
    _$UnknownContactInfoDtoImpl _value,
    $Res Function(_$UnknownContactInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactInfoDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$UnknownContactInfoDtoImpl implements UnknownContactInfoDto {
  const _$UnknownContactInfoDtoImpl({final String? $type})
    : $type = $type ?? 'unknown';

  factory _$UnknownContactInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnknownContactInfoDtoImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContactInfoDto.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownContactInfoDtoImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )
    zalo,
    required TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )
    phone,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult? Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'messengerAccountID') String messengerAccountId,
      @JsonKey(name: 'messengerAccountName') String messengerAccountName,
      @JsonKey(name: 'messengerAccountAvatar') String messengerAccountAvatar,
      @JsonKey(name: 'messengerPageID') String messengerPageId,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'zaloAccountID') String zaloAccountId,
      @JsonKey(name: 'zalophone') String zaloPhone,
      @JsonKey(name: 'zaloAccountName') String zaloAccountName,
      @JsonKey(name: 'zaloAccountAvatar') String zaloAccountAvatar,
      @JsonKey(name: 'zaloAppID') String zaloAppId,
      @JsonKey(name: 'channelID') String channelId,
    )?
    zalo,
    TResult Function(
      @JsonKey(name: 'contactID') String contactId,
      @JsonKey(name: 'customerID') String customerId,
      @JsonKey(name: 'phone') String phone,
      @JsonKey(name: 'isSpam') bool isSpam,
    )?
    phone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContactInfoDto value) messenger,
    required TResult Function(ZaloContactInfoDto value) zalo,
    required TResult Function(PhoneContactInfoDto value) phone,
    required TResult Function(UnknownContactInfoDto value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContactInfoDto value)? messenger,
    TResult? Function(ZaloContactInfoDto value)? zalo,
    TResult? Function(PhoneContactInfoDto value)? phone,
    TResult? Function(UnknownContactInfoDto value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContactInfoDto value)? messenger,
    TResult Function(ZaloContactInfoDto value)? zalo,
    TResult Function(PhoneContactInfoDto value)? phone,
    TResult Function(UnknownContactInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UnknownContactInfoDtoImplToJson(this);
  }
}

abstract class UnknownContactInfoDto implements ContactInfoDto {
  const factory UnknownContactInfoDto() = _$UnknownContactInfoDtoImpl;

  factory UnknownContactInfoDto.fromJson(Map<String, dynamic> json) =
      _$UnknownContactInfoDtoImpl.fromJson;
}
