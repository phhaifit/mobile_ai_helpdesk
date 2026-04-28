// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_group_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageGroupDto _$MessageGroupDtoFromJson(Map<String, dynamic> json) {
  return _MessageGroupDto.fromJson(json);
}

/// @nodoc
mixin _$MessageGroupDto {
  DateTime get date => throw _privateConstructorUsedError;
  List<MessageDto> get messages => throw _privateConstructorUsedError;

  /// Serializes this MessageGroupDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageGroupDtoCopyWith<MessageGroupDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageGroupDtoCopyWith<$Res> {
  factory $MessageGroupDtoCopyWith(
    MessageGroupDto value,
    $Res Function(MessageGroupDto) then,
  ) = _$MessageGroupDtoCopyWithImpl<$Res, MessageGroupDto>;
  @useResult
  $Res call({DateTime date, List<MessageDto> messages});
}

/// @nodoc
class _$MessageGroupDtoCopyWithImpl<$Res, $Val extends MessageGroupDto>
    implements $MessageGroupDtoCopyWith<$Res> {
  _$MessageGroupDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? messages = null}) {
    return _then(
      _value.copyWith(
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            messages:
                null == messages
                    ? _value.messages
                    : messages // ignore: cast_nullable_to_non_nullable
                        as List<MessageDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageGroupDtoImplCopyWith<$Res>
    implements $MessageGroupDtoCopyWith<$Res> {
  factory _$$MessageGroupDtoImplCopyWith(
    _$MessageGroupDtoImpl value,
    $Res Function(_$MessageGroupDtoImpl) then,
  ) = __$$MessageGroupDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, List<MessageDto> messages});
}

/// @nodoc
class __$$MessageGroupDtoImplCopyWithImpl<$Res>
    extends _$MessageGroupDtoCopyWithImpl<$Res, _$MessageGroupDtoImpl>
    implements _$$MessageGroupDtoImplCopyWith<$Res> {
  __$$MessageGroupDtoImplCopyWithImpl(
    _$MessageGroupDtoImpl _value,
    $Res Function(_$MessageGroupDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? messages = null}) {
    return _then(
      _$MessageGroupDtoImpl(
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        messages:
            null == messages
                ? _value._messages
                : messages // ignore: cast_nullable_to_non_nullable
                    as List<MessageDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageGroupDtoImpl implements _MessageGroupDto {
  const _$MessageGroupDtoImpl({
    required this.date,
    final List<MessageDto> messages = const [],
  }) : _messages = messages;

  factory _$MessageGroupDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageGroupDtoImplFromJson(json);

  @override
  final DateTime date;
  final List<MessageDto> _messages;
  @override
  @JsonKey()
  List<MessageDto> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'MessageGroupDto(date: $date, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageGroupDtoImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    const DeepCollectionEquality().hash(_messages),
  );

  /// Create a copy of MessageGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageGroupDtoImplCopyWith<_$MessageGroupDtoImpl> get copyWith =>
      __$$MessageGroupDtoImplCopyWithImpl<_$MessageGroupDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageGroupDtoImplToJson(this);
  }
}

abstract class _MessageGroupDto implements MessageGroupDto {
  const factory _MessageGroupDto({
    required final DateTime date,
    final List<MessageDto> messages,
  }) = _$MessageGroupDtoImpl;

  factory _MessageGroupDto.fromJson(Map<String, dynamic> json) =
      _$MessageGroupDtoImpl.fromJson;

  @override
  DateTime get date;
  @override
  List<MessageDto> get messages;

  /// Create a copy of MessageGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageGroupDtoImplCopyWith<_$MessageGroupDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
