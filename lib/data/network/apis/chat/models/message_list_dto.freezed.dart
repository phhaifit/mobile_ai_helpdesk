// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_list_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageListDto _$MessageListDtoFromJson(Map<String, dynamic> json) {
  return _MessageListDto.fromJson(json);
}

/// @nodoc
mixin _$MessageListDto {
  List<MessageDto> get messages => throw _privateConstructorUsedError;
  MessageEntitiesDto get entities => throw _privateConstructorUsedError;

  /// Serializes this MessageListDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageListDtoCopyWith<MessageListDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageListDtoCopyWith<$Res> {
  factory $MessageListDtoCopyWith(
    MessageListDto value,
    $Res Function(MessageListDto) then,
  ) = _$MessageListDtoCopyWithImpl<$Res, MessageListDto>;
  @useResult
  $Res call({List<MessageDto> messages, MessageEntitiesDto entities});

  $MessageEntitiesDtoCopyWith<$Res> get entities;
}

/// @nodoc
class _$MessageListDtoCopyWithImpl<$Res, $Val extends MessageListDto>
    implements $MessageListDtoCopyWith<$Res> {
  _$MessageListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messages = null, Object? entities = null}) {
    return _then(
      _value.copyWith(
            messages:
                null == messages
                    ? _value.messages
                    : messages // ignore: cast_nullable_to_non_nullable
                        as List<MessageDto>,
            entities:
                null == entities
                    ? _value.entities
                    : entities // ignore: cast_nullable_to_non_nullable
                        as MessageEntitiesDto,
          )
          as $Val,
    );
  }

  /// Create a copy of MessageListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageEntitiesDtoCopyWith<$Res> get entities {
    return $MessageEntitiesDtoCopyWith<$Res>(_value.entities, (value) {
      return _then(_value.copyWith(entities: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageListDtoImplCopyWith<$Res>
    implements $MessageListDtoCopyWith<$Res> {
  factory _$$MessageListDtoImplCopyWith(
    _$MessageListDtoImpl value,
    $Res Function(_$MessageListDtoImpl) then,
  ) = __$$MessageListDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MessageDto> messages, MessageEntitiesDto entities});

  @override
  $MessageEntitiesDtoCopyWith<$Res> get entities;
}

/// @nodoc
class __$$MessageListDtoImplCopyWithImpl<$Res>
    extends _$MessageListDtoCopyWithImpl<$Res, _$MessageListDtoImpl>
    implements _$$MessageListDtoImplCopyWith<$Res> {
  __$$MessageListDtoImplCopyWithImpl(
    _$MessageListDtoImpl _value,
    $Res Function(_$MessageListDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messages = null, Object? entities = null}) {
    return _then(
      _$MessageListDtoImpl(
        messages:
            null == messages
                ? _value._messages
                : messages // ignore: cast_nullable_to_non_nullable
                    as List<MessageDto>,
        entities:
            null == entities
                ? _value.entities
                : entities // ignore: cast_nullable_to_non_nullable
                    as MessageEntitiesDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageListDtoImpl implements _MessageListDto {
  const _$MessageListDtoImpl({
    final List<MessageDto> messages = const [],
    required this.entities,
  }) : _messages = messages;

  factory _$MessageListDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageListDtoImplFromJson(json);

  final List<MessageDto> _messages;
  @override
  @JsonKey()
  List<MessageDto> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final MessageEntitiesDto entities;

  @override
  String toString() {
    return 'MessageListDto(messages: $messages, entities: $entities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageListDtoImpl &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.entities, entities) ||
                other.entities == entities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_messages),
    entities,
  );

  /// Create a copy of MessageListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageListDtoImplCopyWith<_$MessageListDtoImpl> get copyWith =>
      __$$MessageListDtoImplCopyWithImpl<_$MessageListDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageListDtoImplToJson(this);
  }
}

abstract class _MessageListDto implements MessageListDto {
  const factory _MessageListDto({
    final List<MessageDto> messages,
    required final MessageEntitiesDto entities,
  }) = _$MessageListDtoImpl;

  factory _MessageListDto.fromJson(Map<String, dynamic> json) =
      _$MessageListDtoImpl.fromJson;

  @override
  List<MessageDto> get messages;
  @override
  MessageEntitiesDto get entities;

  /// Create a copy of MessageListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageListDtoImplCopyWith<_$MessageListDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
