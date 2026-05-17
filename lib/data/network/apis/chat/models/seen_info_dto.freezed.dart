// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seen_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SeenInfoDto _$SeenInfoDtoFromJson(Map<String, dynamic> json) {
  return _SeenInfoDto.fromJson(json);
}

/// @nodoc
mixin _$SeenInfoDto {
  @JsonKey(name: 'chatRoomSeenID')
  String get chatRoomSeenId => throw _privateConstructorUsedError;
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customerSupportID')
  String get customerSupportId => throw _privateConstructorUsedError;
  @JsonKey(name: 'messageID')
  String get messageId => throw _privateConstructorUsedError;
  int get messageOrder => throw _privateConstructorUsedError;
  int get numberMessageSeen => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SeenInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeenInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeenInfoDtoCopyWith<SeenInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeenInfoDtoCopyWith<$Res> {
  factory $SeenInfoDtoCopyWith(
    SeenInfoDto value,
    $Res Function(SeenInfoDto) then,
  ) = _$SeenInfoDtoCopyWithImpl<$Res, SeenInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'chatRoomSeenID') String chatRoomSeenId,
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'customerSupportID') String customerSupportId,
    @JsonKey(name: 'messageID') String messageId,
    int messageOrder,
    int numberMessageSeen,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$SeenInfoDtoCopyWithImpl<$Res, $Val extends SeenInfoDto>
    implements $SeenInfoDtoCopyWith<$Res> {
  _$SeenInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeenInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatRoomSeenId = null,
    Object? chatRoomId = null,
    Object? customerSupportId = null,
    Object? messageId = null,
    Object? messageOrder = null,
    Object? numberMessageSeen = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            chatRoomSeenId:
                null == chatRoomSeenId
                    ? _value.chatRoomSeenId
                    : chatRoomSeenId // ignore: cast_nullable_to_non_nullable
                        as String,
            chatRoomId:
                null == chatRoomId
                    ? _value.chatRoomId
                    : chatRoomId // ignore: cast_nullable_to_non_nullable
                        as String,
            customerSupportId:
                null == customerSupportId
                    ? _value.customerSupportId
                    : customerSupportId // ignore: cast_nullable_to_non_nullable
                        as String,
            messageId:
                null == messageId
                    ? _value.messageId
                    : messageId // ignore: cast_nullable_to_non_nullable
                        as String,
            messageOrder:
                null == messageOrder
                    ? _value.messageOrder
                    : messageOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            numberMessageSeen:
                null == numberMessageSeen
                    ? _value.numberMessageSeen
                    : numberMessageSeen // ignore: cast_nullable_to_non_nullable
                        as int,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeenInfoDtoImplCopyWith<$Res>
    implements $SeenInfoDtoCopyWith<$Res> {
  factory _$$SeenInfoDtoImplCopyWith(
    _$SeenInfoDtoImpl value,
    $Res Function(_$SeenInfoDtoImpl) then,
  ) = __$$SeenInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'chatRoomSeenID') String chatRoomSeenId,
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'customerSupportID') String customerSupportId,
    @JsonKey(name: 'messageID') String messageId,
    int messageOrder,
    int numberMessageSeen,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$SeenInfoDtoImplCopyWithImpl<$Res>
    extends _$SeenInfoDtoCopyWithImpl<$Res, _$SeenInfoDtoImpl>
    implements _$$SeenInfoDtoImplCopyWith<$Res> {
  __$$SeenInfoDtoImplCopyWithImpl(
    _$SeenInfoDtoImpl _value,
    $Res Function(_$SeenInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SeenInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatRoomSeenId = null,
    Object? chatRoomId = null,
    Object? customerSupportId = null,
    Object? messageId = null,
    Object? messageOrder = null,
    Object? numberMessageSeen = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SeenInfoDtoImpl(
        chatRoomSeenId:
            null == chatRoomSeenId
                ? _value.chatRoomSeenId
                : chatRoomSeenId // ignore: cast_nullable_to_non_nullable
                    as String,
        chatRoomId:
            null == chatRoomId
                ? _value.chatRoomId
                : chatRoomId // ignore: cast_nullable_to_non_nullable
                    as String,
        customerSupportId:
            null == customerSupportId
                ? _value.customerSupportId
                : customerSupportId // ignore: cast_nullable_to_non_nullable
                    as String,
        messageId:
            null == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                    as String,
        messageOrder:
            null == messageOrder
                ? _value.messageOrder
                : messageOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        numberMessageSeen:
            null == numberMessageSeen
                ? _value.numberMessageSeen
                : numberMessageSeen // ignore: cast_nullable_to_non_nullable
                    as int,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeenInfoDtoImpl implements _SeenInfoDto {
  const _$SeenInfoDtoImpl({
    @JsonKey(name: 'chatRoomSeenID') this.chatRoomSeenId = '',
    @JsonKey(name: 'chatRoomID') this.chatRoomId = '',
    @JsonKey(name: 'customerSupportID') this.customerSupportId = '',
    @JsonKey(name: 'messageID') this.messageId = '',
    this.messageOrder = 0,
    this.numberMessageSeen = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$SeenInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeenInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'chatRoomSeenID')
  final String chatRoomSeenId;
  @override
  @JsonKey(name: 'chatRoomID')
  final String chatRoomId;
  @override
  @JsonKey(name: 'customerSupportID')
  final String customerSupportId;
  @override
  @JsonKey(name: 'messageID')
  final String messageId;
  @override
  @JsonKey()
  final int messageOrder;
  @override
  @JsonKey()
  final int numberMessageSeen;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SeenInfoDto(chatRoomSeenId: $chatRoomSeenId, chatRoomId: $chatRoomId, customerSupportId: $customerSupportId, messageId: $messageId, messageOrder: $messageOrder, numberMessageSeen: $numberMessageSeen, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeenInfoDtoImpl &&
            (identical(other.chatRoomSeenId, chatRoomSeenId) ||
                other.chatRoomSeenId == chatRoomSeenId) &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.customerSupportId, customerSupportId) ||
                other.customerSupportId == customerSupportId) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.messageOrder, messageOrder) ||
                other.messageOrder == messageOrder) &&
            (identical(other.numberMessageSeen, numberMessageSeen) ||
                other.numberMessageSeen == numberMessageSeen) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chatRoomSeenId,
    chatRoomId,
    customerSupportId,
    messageId,
    messageOrder,
    numberMessageSeen,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SeenInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeenInfoDtoImplCopyWith<_$SeenInfoDtoImpl> get copyWith =>
      __$$SeenInfoDtoImplCopyWithImpl<_$SeenInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeenInfoDtoImplToJson(this);
  }
}

abstract class _SeenInfoDto implements SeenInfoDto {
  const factory _SeenInfoDto({
    @JsonKey(name: 'chatRoomSeenID') final String chatRoomSeenId,
    @JsonKey(name: 'chatRoomID') final String chatRoomId,
    @JsonKey(name: 'customerSupportID') final String customerSupportId,
    @JsonKey(name: 'messageID') final String messageId,
    final int messageOrder,
    final int numberMessageSeen,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$SeenInfoDtoImpl;

  factory _SeenInfoDto.fromJson(Map<String, dynamic> json) =
      _$SeenInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'chatRoomSeenID')
  String get chatRoomSeenId;
  @override
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId;
  @override
  @JsonKey(name: 'customerSupportID')
  String get customerSupportId;
  @override
  @JsonKey(name: 'messageID')
  String get messageId;
  @override
  int get messageOrder;
  @override
  int get numberMessageSeen;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of SeenInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeenInfoDtoImplCopyWith<_$SeenInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
