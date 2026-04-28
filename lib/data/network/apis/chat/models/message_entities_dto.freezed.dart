// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_entities_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageEntitiesDto _$MessageEntitiesDtoFromJson(Map<String, dynamic> json) {
  return _MessageEntitiesDto.fromJson(json);
}

/// @nodoc
mixin _$MessageEntitiesDto {
  Map<String, dynamic> get channels => throw _privateConstructorUsedError;
  Map<String, dynamic> get senders => throw _privateConstructorUsedError;
  Map<String, dynamic> get tickets => throw _privateConstructorUsedError;

  /// Serializes this MessageEntitiesDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageEntitiesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageEntitiesDtoCopyWith<MessageEntitiesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageEntitiesDtoCopyWith<$Res> {
  factory $MessageEntitiesDtoCopyWith(
    MessageEntitiesDto value,
    $Res Function(MessageEntitiesDto) then,
  ) = _$MessageEntitiesDtoCopyWithImpl<$Res, MessageEntitiesDto>;
  @useResult
  $Res call({
    Map<String, dynamic> channels,
    Map<String, dynamic> senders,
    Map<String, dynamic> tickets,
  });
}

/// @nodoc
class _$MessageEntitiesDtoCopyWithImpl<$Res, $Val extends MessageEntitiesDto>
    implements $MessageEntitiesDtoCopyWith<$Res> {
  _$MessageEntitiesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageEntitiesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? senders = null,
    Object? tickets = null,
  }) {
    return _then(
      _value.copyWith(
            channels:
                null == channels
                    ? _value.channels
                    : channels // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            senders:
                null == senders
                    ? _value.senders
                    : senders // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            tickets:
                null == tickets
                    ? _value.tickets
                    : tickets // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageEntitiesDtoImplCopyWith<$Res>
    implements $MessageEntitiesDtoCopyWith<$Res> {
  factory _$$MessageEntitiesDtoImplCopyWith(
    _$MessageEntitiesDtoImpl value,
    $Res Function(_$MessageEntitiesDtoImpl) then,
  ) = __$$MessageEntitiesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, dynamic> channels,
    Map<String, dynamic> senders,
    Map<String, dynamic> tickets,
  });
}

/// @nodoc
class __$$MessageEntitiesDtoImplCopyWithImpl<$Res>
    extends _$MessageEntitiesDtoCopyWithImpl<$Res, _$MessageEntitiesDtoImpl>
    implements _$$MessageEntitiesDtoImplCopyWith<$Res> {
  __$$MessageEntitiesDtoImplCopyWithImpl(
    _$MessageEntitiesDtoImpl _value,
    $Res Function(_$MessageEntitiesDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageEntitiesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? senders = null,
    Object? tickets = null,
  }) {
    return _then(
      _$MessageEntitiesDtoImpl(
        channels:
            null == channels
                ? _value._channels
                : channels // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        senders:
            null == senders
                ? _value._senders
                : senders // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        tickets:
            null == tickets
                ? _value._tickets
                : tickets // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageEntitiesDtoImpl implements _MessageEntitiesDto {
  const _$MessageEntitiesDtoImpl({
    final Map<String, dynamic> channels = const {},
    final Map<String, dynamic> senders = const {},
    final Map<String, dynamic> tickets = const {},
  }) : _channels = channels,
       _senders = senders,
       _tickets = tickets;

  factory _$MessageEntitiesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageEntitiesDtoImplFromJson(json);

  final Map<String, dynamic> _channels;
  @override
  @JsonKey()
  Map<String, dynamic> get channels {
    if (_channels is EqualUnmodifiableMapView) return _channels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_channels);
  }

  final Map<String, dynamic> _senders;
  @override
  @JsonKey()
  Map<String, dynamic> get senders {
    if (_senders is EqualUnmodifiableMapView) return _senders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_senders);
  }

  final Map<String, dynamic> _tickets;
  @override
  @JsonKey()
  Map<String, dynamic> get tickets {
    if (_tickets is EqualUnmodifiableMapView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tickets);
  }

  @override
  String toString() {
    return 'MessageEntitiesDto(channels: $channels, senders: $senders, tickets: $tickets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageEntitiesDtoImpl &&
            const DeepCollectionEquality().equals(other._channels, _channels) &&
            const DeepCollectionEquality().equals(other._senders, _senders) &&
            const DeepCollectionEquality().equals(other._tickets, _tickets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_channels),
    const DeepCollectionEquality().hash(_senders),
    const DeepCollectionEquality().hash(_tickets),
  );

  /// Create a copy of MessageEntitiesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageEntitiesDtoImplCopyWith<_$MessageEntitiesDtoImpl> get copyWith =>
      __$$MessageEntitiesDtoImplCopyWithImpl<_$MessageEntitiesDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageEntitiesDtoImplToJson(this);
  }
}

abstract class _MessageEntitiesDto implements MessageEntitiesDto {
  const factory _MessageEntitiesDto({
    final Map<String, dynamic> channels,
    final Map<String, dynamic> senders,
    final Map<String, dynamic> tickets,
  }) = _$MessageEntitiesDtoImpl;

  factory _MessageEntitiesDto.fromJson(Map<String, dynamic> json) =
      _$MessageEntitiesDtoImpl.fromJson;

  @override
  Map<String, dynamic> get channels;
  @override
  Map<String, dynamic> get senders;
  @override
  Map<String, dynamic> get tickets;

  /// Create a copy of MessageEntitiesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageEntitiesDtoImplCopyWith<_$MessageEntitiesDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
