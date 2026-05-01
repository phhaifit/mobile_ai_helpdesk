// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChannelInfoDto _$ChannelInfoDtoFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'zalo':
      return ZaloChannelInfoDto.fromJson(json);
    case 'messenger':
      return MessengerChannelInfoDto.fromJson(json);
    case 'unknown':
      return UnknownChannelInfoDto.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'ChannelInfoDto',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$ChannelInfoDto {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zaloId, String? displayName) zalo,
    required TResult Function(String messengerId, String? username) messenger,
    required TResult Function() unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zaloId, String? displayName)? zalo,
    TResult? Function(String messengerId, String? username)? messenger,
    TResult? Function()? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zaloId, String? displayName)? zalo,
    TResult Function(String messengerId, String? username)? messenger,
    TResult Function()? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ZaloChannelInfoDto value) zalo,
    required TResult Function(MessengerChannelInfoDto value) messenger,
    required TResult Function(UnknownChannelInfoDto value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ZaloChannelInfoDto value)? zalo,
    TResult? Function(MessengerChannelInfoDto value)? messenger,
    TResult? Function(UnknownChannelInfoDto value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ZaloChannelInfoDto value)? zalo,
    TResult Function(MessengerChannelInfoDto value)? messenger,
    TResult Function(UnknownChannelInfoDto value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this ChannelInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelInfoDtoCopyWith<$Res> {
  factory $ChannelInfoDtoCopyWith(
    ChannelInfoDto value,
    $Res Function(ChannelInfoDto) then,
  ) = _$ChannelInfoDtoCopyWithImpl<$Res, ChannelInfoDto>;
}

/// @nodoc
class _$ChannelInfoDtoCopyWithImpl<$Res, $Val extends ChannelInfoDto>
    implements $ChannelInfoDtoCopyWith<$Res> {
  _$ChannelInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ZaloChannelInfoDtoImplCopyWith<$Res> {
  factory _$$ZaloChannelInfoDtoImplCopyWith(
    _$ZaloChannelInfoDtoImpl value,
    $Res Function(_$ZaloChannelInfoDtoImpl) then,
  ) = __$$ZaloChannelInfoDtoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String zaloId, String? displayName});
}

/// @nodoc
class __$$ZaloChannelInfoDtoImplCopyWithImpl<$Res>
    extends _$ChannelInfoDtoCopyWithImpl<$Res, _$ZaloChannelInfoDtoImpl>
    implements _$$ZaloChannelInfoDtoImplCopyWith<$Res> {
  __$$ZaloChannelInfoDtoImplCopyWithImpl(
    _$ZaloChannelInfoDtoImpl _value,
    $Res Function(_$ZaloChannelInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? zaloId = null, Object? displayName = freezed}) {
    return _then(
      _$ZaloChannelInfoDtoImpl(
        zaloId:
            null == zaloId
                ? _value.zaloId
                : zaloId // ignore: cast_nullable_to_non_nullable
                    as String,
        displayName:
            freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZaloChannelInfoDtoImpl implements ZaloChannelInfoDto {
  const _$ZaloChannelInfoDtoImpl({
    required this.zaloId,
    this.displayName,
    final String? $type,
  }) : $type = $type ?? 'zalo';

  factory _$ZaloChannelInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZaloChannelInfoDtoImplFromJson(json);

  @override
  final String zaloId;
  @override
  final String? displayName;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ChannelInfoDto.zalo(zaloId: $zaloId, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZaloChannelInfoDtoImpl &&
            (identical(other.zaloId, zaloId) || other.zaloId == zaloId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, zaloId, displayName);

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZaloChannelInfoDtoImplCopyWith<_$ZaloChannelInfoDtoImpl> get copyWith =>
      __$$ZaloChannelInfoDtoImplCopyWithImpl<_$ZaloChannelInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zaloId, String? displayName) zalo,
    required TResult Function(String messengerId, String? username) messenger,
    required TResult Function() unknown,
  }) {
    return zalo(zaloId, displayName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zaloId, String? displayName)? zalo,
    TResult? Function(String messengerId, String? username)? messenger,
    TResult? Function()? unknown,
  }) {
    return zalo?.call(zaloId, displayName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zaloId, String? displayName)? zalo,
    TResult Function(String messengerId, String? username)? messenger,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (zalo != null) {
      return zalo(zaloId, displayName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ZaloChannelInfoDto value) zalo,
    required TResult Function(MessengerChannelInfoDto value) messenger,
    required TResult Function(UnknownChannelInfoDto value) unknown,
  }) {
    return zalo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ZaloChannelInfoDto value)? zalo,
    TResult? Function(MessengerChannelInfoDto value)? messenger,
    TResult? Function(UnknownChannelInfoDto value)? unknown,
  }) {
    return zalo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ZaloChannelInfoDto value)? zalo,
    TResult Function(MessengerChannelInfoDto value)? messenger,
    TResult Function(UnknownChannelInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (zalo != null) {
      return zalo(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ZaloChannelInfoDtoImplToJson(this);
  }
}

abstract class ZaloChannelInfoDto implements ChannelInfoDto {
  const factory ZaloChannelInfoDto({
    required final String zaloId,
    final String? displayName,
  }) = _$ZaloChannelInfoDtoImpl;

  factory ZaloChannelInfoDto.fromJson(Map<String, dynamic> json) =
      _$ZaloChannelInfoDtoImpl.fromJson;

  String get zaloId;
  String? get displayName;

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZaloChannelInfoDtoImplCopyWith<_$ZaloChannelInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MessengerChannelInfoDtoImplCopyWith<$Res> {
  factory _$$MessengerChannelInfoDtoImplCopyWith(
    _$MessengerChannelInfoDtoImpl value,
    $Res Function(_$MessengerChannelInfoDtoImpl) then,
  ) = __$$MessengerChannelInfoDtoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String messengerId, String? username});
}

/// @nodoc
class __$$MessengerChannelInfoDtoImplCopyWithImpl<$Res>
    extends _$ChannelInfoDtoCopyWithImpl<$Res, _$MessengerChannelInfoDtoImpl>
    implements _$$MessengerChannelInfoDtoImplCopyWith<$Res> {
  __$$MessengerChannelInfoDtoImplCopyWithImpl(
    _$MessengerChannelInfoDtoImpl _value,
    $Res Function(_$MessengerChannelInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messengerId = null, Object? username = freezed}) {
    return _then(
      _$MessengerChannelInfoDtoImpl(
        messengerId:
            null == messengerId
                ? _value.messengerId
                : messengerId // ignore: cast_nullable_to_non_nullable
                    as String,
        username:
            freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessengerChannelInfoDtoImpl implements MessengerChannelInfoDto {
  const _$MessengerChannelInfoDtoImpl({
    required this.messengerId,
    this.username,
    final String? $type,
  }) : $type = $type ?? 'messenger';

  factory _$MessengerChannelInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessengerChannelInfoDtoImplFromJson(json);

  @override
  final String messengerId;
  @override
  final String? username;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ChannelInfoDto.messenger(messengerId: $messengerId, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessengerChannelInfoDtoImpl &&
            (identical(other.messengerId, messengerId) ||
                other.messengerId == messengerId) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, messengerId, username);

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessengerChannelInfoDtoImplCopyWith<_$MessengerChannelInfoDtoImpl>
  get copyWith => __$$MessengerChannelInfoDtoImplCopyWithImpl<
    _$MessengerChannelInfoDtoImpl
  >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zaloId, String? displayName) zalo,
    required TResult Function(String messengerId, String? username) messenger,
    required TResult Function() unknown,
  }) {
    return messenger(messengerId, username);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zaloId, String? displayName)? zalo,
    TResult? Function(String messengerId, String? username)? messenger,
    TResult? Function()? unknown,
  }) {
    return messenger?.call(messengerId, username);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zaloId, String? displayName)? zalo,
    TResult Function(String messengerId, String? username)? messenger,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (messenger != null) {
      return messenger(messengerId, username);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ZaloChannelInfoDto value) zalo,
    required TResult Function(MessengerChannelInfoDto value) messenger,
    required TResult Function(UnknownChannelInfoDto value) unknown,
  }) {
    return messenger(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ZaloChannelInfoDto value)? zalo,
    TResult? Function(MessengerChannelInfoDto value)? messenger,
    TResult? Function(UnknownChannelInfoDto value)? unknown,
  }) {
    return messenger?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ZaloChannelInfoDto value)? zalo,
    TResult Function(MessengerChannelInfoDto value)? messenger,
    TResult Function(UnknownChannelInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (messenger != null) {
      return messenger(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessengerChannelInfoDtoImplToJson(this);
  }
}

abstract class MessengerChannelInfoDto implements ChannelInfoDto {
  const factory MessengerChannelInfoDto({
    required final String messengerId,
    final String? username,
  }) = _$MessengerChannelInfoDtoImpl;

  factory MessengerChannelInfoDto.fromJson(Map<String, dynamic> json) =
      _$MessengerChannelInfoDtoImpl.fromJson;

  String get messengerId;
  String? get username;

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessengerChannelInfoDtoImplCopyWith<_$MessengerChannelInfoDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownChannelInfoDtoImplCopyWith<$Res> {
  factory _$$UnknownChannelInfoDtoImplCopyWith(
    _$UnknownChannelInfoDtoImpl value,
    $Res Function(_$UnknownChannelInfoDtoImpl) then,
  ) = __$$UnknownChannelInfoDtoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnknownChannelInfoDtoImplCopyWithImpl<$Res>
    extends _$ChannelInfoDtoCopyWithImpl<$Res, _$UnknownChannelInfoDtoImpl>
    implements _$$UnknownChannelInfoDtoImplCopyWith<$Res> {
  __$$UnknownChannelInfoDtoImplCopyWithImpl(
    _$UnknownChannelInfoDtoImpl _value,
    $Res Function(_$UnknownChannelInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$UnknownChannelInfoDtoImpl implements UnknownChannelInfoDto {
  const _$UnknownChannelInfoDtoImpl({final String? $type})
    : $type = $type ?? 'unknown';

  factory _$UnknownChannelInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnknownChannelInfoDtoImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ChannelInfoDto.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownChannelInfoDtoImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String zaloId, String? displayName) zalo,
    required TResult Function(String messengerId, String? username) messenger,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String zaloId, String? displayName)? zalo,
    TResult? Function(String messengerId, String? username)? messenger,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String zaloId, String? displayName)? zalo,
    TResult Function(String messengerId, String? username)? messenger,
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
    required TResult Function(ZaloChannelInfoDto value) zalo,
    required TResult Function(MessengerChannelInfoDto value) messenger,
    required TResult Function(UnknownChannelInfoDto value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ZaloChannelInfoDto value)? zalo,
    TResult? Function(MessengerChannelInfoDto value)? messenger,
    TResult? Function(UnknownChannelInfoDto value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ZaloChannelInfoDto value)? zalo,
    TResult Function(MessengerChannelInfoDto value)? messenger,
    TResult Function(UnknownChannelInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UnknownChannelInfoDtoImplToJson(this);
  }
}

abstract class UnknownChannelInfoDto implements ChannelInfoDto {
  const factory UnknownChannelInfoDto() = _$UnknownChannelInfoDtoImpl;

  factory UnknownChannelInfoDto.fromJson(Map<String, dynamic> json) =
      _$UnknownChannelInfoDtoImpl.fromJson;
}
