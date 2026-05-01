// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContentInfoDto _$ContentInfoDtoFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'messenger':
      return MessengerContentInfoDto.fromJson(json);
    case 'zalo':
      return ZaloContentInfoDto.fromJson(json);
    case 'unknown':
      return UnknownContentInfoDto.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'ContentInfoDto',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$ContentInfoDto {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    zalo,
    required TResult Function() unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
    TResult? Function()? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
    TResult Function()? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContentInfoDto value) messenger,
    required TResult Function(ZaloContentInfoDto value) zalo,
    required TResult Function(UnknownContentInfoDto value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContentInfoDto value)? messenger,
    TResult? Function(ZaloContentInfoDto value)? zalo,
    TResult? Function(UnknownContentInfoDto value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContentInfoDto value)? messenger,
    TResult Function(ZaloContentInfoDto value)? zalo,
    TResult Function(UnknownContentInfoDto value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this ContentInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentInfoDtoCopyWith<$Res> {
  factory $ContentInfoDtoCopyWith(
    ContentInfoDto value,
    $Res Function(ContentInfoDto) then,
  ) = _$ContentInfoDtoCopyWithImpl<$Res, ContentInfoDto>;
}

/// @nodoc
class _$ContentInfoDtoCopyWithImpl<$Res, $Val extends ContentInfoDto>
    implements $ContentInfoDtoCopyWith<$Res> {
  _$ContentInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MessengerContentInfoDtoImplCopyWith<$Res> {
  factory _$$MessengerContentInfoDtoImplCopyWith(
    _$MessengerContentInfoDtoImpl value,
    $Res Function(_$MessengerContentInfoDtoImpl) then,
  ) = __$$MessengerContentInfoDtoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    @JsonKey(name: 'messageID') String messageId,
    @JsonKey(name: 'messengerMessageID') String messengerMessageId,
    @JsonKey(name: 'content') String content,
    @JsonKey(name: 'recipientID') String recipientId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$MessengerContentInfoDtoImplCopyWithImpl<$Res>
    extends _$ContentInfoDtoCopyWithImpl<$Res, _$MessengerContentInfoDtoImpl>
    implements _$$MessengerContentInfoDtoImplCopyWith<$Res> {
  __$$MessengerContentInfoDtoImplCopyWithImpl(
    _$MessengerContentInfoDtoImpl _value,
    $Res Function(_$MessengerContentInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? messengerMessageId = null,
    Object? content = null,
    Object? recipientId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$MessengerContentInfoDtoImpl(
        messageId:
            null == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                    as String,
        messengerMessageId:
            null == messengerMessageId
                ? _value.messengerMessageId
                : messengerMessageId // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        recipientId:
            null == recipientId
                ? _value.recipientId
                : recipientId // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        deletedAt:
            freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessengerContentInfoDtoImpl implements MessengerContentInfoDto {
  const _$MessengerContentInfoDtoImpl({
    @JsonKey(name: 'messageID') this.messageId = '',
    @JsonKey(name: 'messengerMessageID') this.messengerMessageId = '',
    @JsonKey(name: 'content') this.content = '',
    @JsonKey(name: 'recipientID') this.recipientId = '',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    final String? $type,
  }) : $type = $type ?? 'messenger';

  factory _$MessengerContentInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessengerContentInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'messageID')
  final String messageId;
  @override
  @JsonKey(name: 'messengerMessageID')
  final String messengerMessageId;
  @override
  @JsonKey(name: 'content')
  final String content;
  @override
  @JsonKey(name: 'recipientID')
  final String recipientId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContentInfoDto.messenger(messageId: $messageId, messengerMessageId: $messengerMessageId, content: $content, recipientId: $recipientId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessengerContentInfoDtoImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.messengerMessageId, messengerMessageId) ||
                other.messengerMessageId == messengerMessageId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    messageId,
    messengerMessageId,
    content,
    recipientId,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessengerContentInfoDtoImplCopyWith<_$MessengerContentInfoDtoImpl>
  get copyWith => __$$MessengerContentInfoDtoImplCopyWithImpl<
    _$MessengerContentInfoDtoImpl
  >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    zalo,
    required TResult Function() unknown,
  }) {
    return messenger(
      messageId,
      messengerMessageId,
      content,
      recipientId,
      createdAt,
      updatedAt,
      deletedAt,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
    TResult? Function()? unknown,
  }) {
    return messenger?.call(
      messageId,
      messengerMessageId,
      content,
      recipientId,
      createdAt,
      updatedAt,
      deletedAt,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (messenger != null) {
      return messenger(
        messageId,
        messengerMessageId,
        content,
        recipientId,
        createdAt,
        updatedAt,
        deletedAt,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContentInfoDto value) messenger,
    required TResult Function(ZaloContentInfoDto value) zalo,
    required TResult Function(UnknownContentInfoDto value) unknown,
  }) {
    return messenger(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContentInfoDto value)? messenger,
    TResult? Function(ZaloContentInfoDto value)? zalo,
    TResult? Function(UnknownContentInfoDto value)? unknown,
  }) {
    return messenger?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContentInfoDto value)? messenger,
    TResult Function(ZaloContentInfoDto value)? zalo,
    TResult Function(UnknownContentInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (messenger != null) {
      return messenger(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessengerContentInfoDtoImplToJson(this);
  }
}

abstract class MessengerContentInfoDto implements ContentInfoDto {
  const factory MessengerContentInfoDto({
    @JsonKey(name: 'messageID') final String messageId,
    @JsonKey(name: 'messengerMessageID') final String messengerMessageId,
    @JsonKey(name: 'content') final String content,
    @JsonKey(name: 'recipientID') final String recipientId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
  }) = _$MessengerContentInfoDtoImpl;

  factory MessengerContentInfoDto.fromJson(Map<String, dynamic> json) =
      _$MessengerContentInfoDtoImpl.fromJson;

  @JsonKey(name: 'messageID')
  String get messageId;
  @JsonKey(name: 'messengerMessageID')
  String get messengerMessageId;
  @JsonKey(name: 'content')
  String get content;
  @JsonKey(name: 'recipientID')
  String get recipientId;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  DateTime? get deletedAt;

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessengerContentInfoDtoImplCopyWith<_$MessengerContentInfoDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ZaloContentInfoDtoImplCopyWith<$Res> {
  factory _$$ZaloContentInfoDtoImplCopyWith(
    _$ZaloContentInfoDtoImpl value,
    $Res Function(_$ZaloContentInfoDtoImpl) then,
  ) = __$$ZaloContentInfoDtoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    @JsonKey(name: 'messageID') String messageId,
    @JsonKey(name: 'zaloMessageID') String zaloMessageId,
    @JsonKey(name: 'content') String content,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$ZaloContentInfoDtoImplCopyWithImpl<$Res>
    extends _$ContentInfoDtoCopyWithImpl<$Res, _$ZaloContentInfoDtoImpl>
    implements _$$ZaloContentInfoDtoImplCopyWith<$Res> {
  __$$ZaloContentInfoDtoImplCopyWithImpl(
    _$ZaloContentInfoDtoImpl _value,
    $Res Function(_$ZaloContentInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? zaloMessageId = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$ZaloContentInfoDtoImpl(
        messageId:
            null == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                    as String,
        zaloMessageId:
            null == zaloMessageId
                ? _value.zaloMessageId
                : zaloMessageId // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        deletedAt:
            freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ZaloContentInfoDtoImpl implements ZaloContentInfoDto {
  const _$ZaloContentInfoDtoImpl({
    @JsonKey(name: 'messageID') this.messageId = '',
    @JsonKey(name: 'zaloMessageID') this.zaloMessageId = '',
    @JsonKey(name: 'content') this.content = '',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    final String? $type,
  }) : $type = $type ?? 'zalo';

  factory _$ZaloContentInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZaloContentInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'messageID')
  final String messageId;
  @override
  @JsonKey(name: 'zaloMessageID')
  final String zaloMessageId;
  @override
  @JsonKey(name: 'content')
  final String content;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContentInfoDto.zalo(messageId: $messageId, zaloMessageId: $zaloMessageId, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZaloContentInfoDtoImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.zaloMessageId, zaloMessageId) ||
                other.zaloMessageId == zaloMessageId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    messageId,
    zaloMessageId,
    content,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZaloContentInfoDtoImplCopyWith<_$ZaloContentInfoDtoImpl> get copyWith =>
      __$$ZaloContentInfoDtoImplCopyWithImpl<_$ZaloContentInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    zalo,
    required TResult Function() unknown,
  }) {
    return zalo(
      messageId,
      zaloMessageId,
      content,
      createdAt,
      updatedAt,
      deletedAt,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
    TResult? Function()? unknown,
  }) {
    return zalo?.call(
      messageId,
      zaloMessageId,
      content,
      createdAt,
      updatedAt,
      deletedAt,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (zalo != null) {
      return zalo(
        messageId,
        zaloMessageId,
        content,
        createdAt,
        updatedAt,
        deletedAt,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessengerContentInfoDto value) messenger,
    required TResult Function(ZaloContentInfoDto value) zalo,
    required TResult Function(UnknownContentInfoDto value) unknown,
  }) {
    return zalo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContentInfoDto value)? messenger,
    TResult? Function(ZaloContentInfoDto value)? zalo,
    TResult? Function(UnknownContentInfoDto value)? unknown,
  }) {
    return zalo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContentInfoDto value)? messenger,
    TResult Function(ZaloContentInfoDto value)? zalo,
    TResult Function(UnknownContentInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (zalo != null) {
      return zalo(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ZaloContentInfoDtoImplToJson(this);
  }
}

abstract class ZaloContentInfoDto implements ContentInfoDto {
  const factory ZaloContentInfoDto({
    @JsonKey(name: 'messageID') final String messageId,
    @JsonKey(name: 'zaloMessageID') final String zaloMessageId,
    @JsonKey(name: 'content') final String content,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
  }) = _$ZaloContentInfoDtoImpl;

  factory ZaloContentInfoDto.fromJson(Map<String, dynamic> json) =
      _$ZaloContentInfoDtoImpl.fromJson;

  @JsonKey(name: 'messageID')
  String get messageId;
  @JsonKey(name: 'zaloMessageID')
  String get zaloMessageId;
  @JsonKey(name: 'content')
  String get content;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  DateTime? get deletedAt;

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZaloContentInfoDtoImplCopyWith<_$ZaloContentInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownContentInfoDtoImplCopyWith<$Res> {
  factory _$$UnknownContentInfoDtoImplCopyWith(
    _$UnknownContentInfoDtoImpl value,
    $Res Function(_$UnknownContentInfoDtoImpl) then,
  ) = __$$UnknownContentInfoDtoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnknownContentInfoDtoImplCopyWithImpl<$Res>
    extends _$ContentInfoDtoCopyWithImpl<$Res, _$UnknownContentInfoDtoImpl>
    implements _$$UnknownContentInfoDtoImplCopyWith<$Res> {
  __$$UnknownContentInfoDtoImplCopyWithImpl(
    _$UnknownContentInfoDtoImpl _value,
    $Res Function(_$UnknownContentInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentInfoDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$UnknownContentInfoDtoImpl implements UnknownContentInfoDto {
  const _$UnknownContentInfoDtoImpl({final String? $type})
    : $type = $type ?? 'unknown';

  factory _$UnknownContentInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnknownContentInfoDtoImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ContentInfoDto.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownContentInfoDtoImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    messenger,
    required TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )
    zalo,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult? Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'messengerMessageID') String messengerMessageId,
      @JsonKey(name: 'content') String content,
      @JsonKey(name: 'recipientID') String recipientId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    messenger,
    TResult Function(
      @JsonKey(name: 'messageID') String messageId,
      @JsonKey(name: 'zaloMessageID') String zaloMessageId,
      @JsonKey(name: 'content') String content,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
    )?
    zalo,
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
    required TResult Function(MessengerContentInfoDto value) messenger,
    required TResult Function(ZaloContentInfoDto value) zalo,
    required TResult Function(UnknownContentInfoDto value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessengerContentInfoDto value)? messenger,
    TResult? Function(ZaloContentInfoDto value)? zalo,
    TResult? Function(UnknownContentInfoDto value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessengerContentInfoDto value)? messenger,
    TResult Function(ZaloContentInfoDto value)? zalo,
    TResult Function(UnknownContentInfoDto value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UnknownContentInfoDtoImplToJson(this);
  }
}

abstract class UnknownContentInfoDto implements ContentInfoDto {
  const factory UnknownContentInfoDto() = _$UnknownContentInfoDtoImpl;

  factory UnknownContentInfoDto.fromJson(Map<String, dynamic> json) =
      _$UnknownContentInfoDtoImpl.fromJson;
}
