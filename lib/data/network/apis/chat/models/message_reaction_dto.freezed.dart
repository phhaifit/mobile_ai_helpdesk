// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_reaction_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageReactionDto _$MessageReactionDtoFromJson(Map<String, dynamic> json) {
  return _MessageReactionDto.fromJson(json);
}

/// @nodoc
mixin _$MessageReactionDto {
  @JsonKey(name: 'messageReactionID')
  String get messageReactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'messageID')
  String get messageId => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'customerID')
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customerSupportID')
  String? get customerSupportId => throw _privateConstructorUsedError;
  CustomerInfoDto? get customerInfo => throw _privateConstructorUsedError;
  CustomerSupportInfoDto? get customerSupportInfo =>
      throw _privateConstructorUsedError;

  /// Serializes this MessageReactionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageReactionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageReactionDtoCopyWith<MessageReactionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReactionDtoCopyWith<$Res> {
  factory $MessageReactionDtoCopyWith(
    MessageReactionDto value,
    $Res Function(MessageReactionDto) then,
  ) = _$MessageReactionDtoCopyWithImpl<$Res, MessageReactionDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'messageReactionID') String messageReactionId,
    @JsonKey(name: 'messageID') String messageId,
    String emoji,
    int amount,
    @JsonKey(name: 'customerID') String? customerId,
    @JsonKey(name: 'customerSupportID') String? customerSupportId,
    CustomerInfoDto? customerInfo,
    CustomerSupportInfoDto? customerSupportInfo,
  });

  $CustomerInfoDtoCopyWith<$Res>? get customerInfo;
  $CustomerSupportInfoDtoCopyWith<$Res>? get customerSupportInfo;
}

/// @nodoc
class _$MessageReactionDtoCopyWithImpl<$Res, $Val extends MessageReactionDto>
    implements $MessageReactionDtoCopyWith<$Res> {
  _$MessageReactionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageReactionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageReactionId = null,
    Object? messageId = null,
    Object? emoji = null,
    Object? amount = null,
    Object? customerId = freezed,
    Object? customerSupportId = freezed,
    Object? customerInfo = freezed,
    Object? customerSupportInfo = freezed,
  }) {
    return _then(
      _value.copyWith(
            messageReactionId:
                null == messageReactionId
                    ? _value.messageReactionId
                    : messageReactionId // ignore: cast_nullable_to_non_nullable
                        as String,
            messageId:
                null == messageId
                    ? _value.messageId
                    : messageId // ignore: cast_nullable_to_non_nullable
                        as String,
            emoji:
                null == emoji
                    ? _value.emoji
                    : emoji // ignore: cast_nullable_to_non_nullable
                        as String,
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as int,
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerSupportId:
                freezed == customerSupportId
                    ? _value.customerSupportId
                    : customerSupportId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerInfo:
                freezed == customerInfo
                    ? _value.customerInfo
                    : customerInfo // ignore: cast_nullable_to_non_nullable
                        as CustomerInfoDto?,
            customerSupportInfo:
                freezed == customerSupportInfo
                    ? _value.customerSupportInfo
                    : customerSupportInfo // ignore: cast_nullable_to_non_nullable
                        as CustomerSupportInfoDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of MessageReactionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerInfoDtoCopyWith<$Res>? get customerInfo {
    if (_value.customerInfo == null) {
      return null;
    }

    return $CustomerInfoDtoCopyWith<$Res>(_value.customerInfo!, (value) {
      return _then(_value.copyWith(customerInfo: value) as $Val);
    });
  }

  /// Create a copy of MessageReactionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerSupportInfoDtoCopyWith<$Res>? get customerSupportInfo {
    if (_value.customerSupportInfo == null) {
      return null;
    }

    return $CustomerSupportInfoDtoCopyWith<$Res>(_value.customerSupportInfo!, (
      value,
    ) {
      return _then(_value.copyWith(customerSupportInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageReactionDtoImplCopyWith<$Res>
    implements $MessageReactionDtoCopyWith<$Res> {
  factory _$$MessageReactionDtoImplCopyWith(
    _$MessageReactionDtoImpl value,
    $Res Function(_$MessageReactionDtoImpl) then,
  ) = __$$MessageReactionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'messageReactionID') String messageReactionId,
    @JsonKey(name: 'messageID') String messageId,
    String emoji,
    int amount,
    @JsonKey(name: 'customerID') String? customerId,
    @JsonKey(name: 'customerSupportID') String? customerSupportId,
    CustomerInfoDto? customerInfo,
    CustomerSupportInfoDto? customerSupportInfo,
  });

  @override
  $CustomerInfoDtoCopyWith<$Res>? get customerInfo;
  @override
  $CustomerSupportInfoDtoCopyWith<$Res>? get customerSupportInfo;
}

/// @nodoc
class __$$MessageReactionDtoImplCopyWithImpl<$Res>
    extends _$MessageReactionDtoCopyWithImpl<$Res, _$MessageReactionDtoImpl>
    implements _$$MessageReactionDtoImplCopyWith<$Res> {
  __$$MessageReactionDtoImplCopyWithImpl(
    _$MessageReactionDtoImpl _value,
    $Res Function(_$MessageReactionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageReactionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageReactionId = null,
    Object? messageId = null,
    Object? emoji = null,
    Object? amount = null,
    Object? customerId = freezed,
    Object? customerSupportId = freezed,
    Object? customerInfo = freezed,
    Object? customerSupportInfo = freezed,
  }) {
    return _then(
      _$MessageReactionDtoImpl(
        messageReactionId:
            null == messageReactionId
                ? _value.messageReactionId
                : messageReactionId // ignore: cast_nullable_to_non_nullable
                    as String,
        messageId:
            null == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                    as String,
        emoji:
            null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                    as String,
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as int,
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerSupportId:
            freezed == customerSupportId
                ? _value.customerSupportId
                : customerSupportId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerInfo:
            freezed == customerInfo
                ? _value.customerInfo
                : customerInfo // ignore: cast_nullable_to_non_nullable
                    as CustomerInfoDto?,
        customerSupportInfo:
            freezed == customerSupportInfo
                ? _value.customerSupportInfo
                : customerSupportInfo // ignore: cast_nullable_to_non_nullable
                    as CustomerSupportInfoDto?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageReactionDtoImpl implements _MessageReactionDto {
  const _$MessageReactionDtoImpl({
    @JsonKey(name: 'messageReactionID') this.messageReactionId = '',
    @JsonKey(name: 'messageID') this.messageId = '',
    this.emoji = '',
    this.amount = 0,
    @JsonKey(name: 'customerID') this.customerId,
    @JsonKey(name: 'customerSupportID') this.customerSupportId,
    this.customerInfo,
    this.customerSupportInfo,
  });

  factory _$MessageReactionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageReactionDtoImplFromJson(json);

  @override
  @JsonKey(name: 'messageReactionID')
  final String messageReactionId;
  @override
  @JsonKey(name: 'messageID')
  final String messageId;
  @override
  @JsonKey()
  final String emoji;
  @override
  @JsonKey()
  final int amount;
  @override
  @JsonKey(name: 'customerID')
  final String? customerId;
  @override
  @JsonKey(name: 'customerSupportID')
  final String? customerSupportId;
  @override
  final CustomerInfoDto? customerInfo;
  @override
  final CustomerSupportInfoDto? customerSupportInfo;

  @override
  String toString() {
    return 'MessageReactionDto(messageReactionId: $messageReactionId, messageId: $messageId, emoji: $emoji, amount: $amount, customerId: $customerId, customerSupportId: $customerSupportId, customerInfo: $customerInfo, customerSupportInfo: $customerSupportInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReactionDtoImpl &&
            (identical(other.messageReactionId, messageReactionId) ||
                other.messageReactionId == messageReactionId) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerSupportId, customerSupportId) ||
                other.customerSupportId == customerSupportId) &&
            (identical(other.customerInfo, customerInfo) ||
                other.customerInfo == customerInfo) &&
            (identical(other.customerSupportInfo, customerSupportInfo) ||
                other.customerSupportInfo == customerSupportInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    messageReactionId,
    messageId,
    emoji,
    amount,
    customerId,
    customerSupportId,
    customerInfo,
    customerSupportInfo,
  );

  /// Create a copy of MessageReactionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageReactionDtoImplCopyWith<_$MessageReactionDtoImpl> get copyWith =>
      __$$MessageReactionDtoImplCopyWithImpl<_$MessageReactionDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageReactionDtoImplToJson(this);
  }
}

abstract class _MessageReactionDto implements MessageReactionDto {
  const factory _MessageReactionDto({
    @JsonKey(name: 'messageReactionID') final String messageReactionId,
    @JsonKey(name: 'messageID') final String messageId,
    final String emoji,
    final int amount,
    @JsonKey(name: 'customerID') final String? customerId,
    @JsonKey(name: 'customerSupportID') final String? customerSupportId,
    final CustomerInfoDto? customerInfo,
    final CustomerSupportInfoDto? customerSupportInfo,
  }) = _$MessageReactionDtoImpl;

  factory _MessageReactionDto.fromJson(Map<String, dynamic> json) =
      _$MessageReactionDtoImpl.fromJson;

  @override
  @JsonKey(name: 'messageReactionID')
  String get messageReactionId;
  @override
  @JsonKey(name: 'messageID')
  String get messageId;
  @override
  String get emoji;
  @override
  int get amount;
  @override
  @JsonKey(name: 'customerID')
  String? get customerId;
  @override
  @JsonKey(name: 'customerSupportID')
  String? get customerSupportId;
  @override
  CustomerInfoDto? get customerInfo;
  @override
  CustomerSupportInfoDto? get customerSupportInfo;

  /// Create a copy of MessageReactionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageReactionDtoImplCopyWith<_$MessageReactionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
