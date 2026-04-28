// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_counter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatRoomCounterDto _$ChatRoomCounterDtoFromJson(Map<String, dynamic> json) {
  return _ChatRoomCounterDto.fromJson(json);
}

/// @nodoc
mixin _$ChatRoomCounterDto {
  int get open => throw _privateConstructorUsedError;
  int get pending => throw _privateConstructorUsedError;
  int get solved => throw _privateConstructorUsedError;
  int get closed => throw _privateConstructorUsedError;

  /// Serializes this ChatRoomCounterDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatRoomCounterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatRoomCounterDtoCopyWith<ChatRoomCounterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomCounterDtoCopyWith<$Res> {
  factory $ChatRoomCounterDtoCopyWith(
    ChatRoomCounterDto value,
    $Res Function(ChatRoomCounterDto) then,
  ) = _$ChatRoomCounterDtoCopyWithImpl<$Res, ChatRoomCounterDto>;
  @useResult
  $Res call({int open, int pending, int solved, int closed});
}

/// @nodoc
class _$ChatRoomCounterDtoCopyWithImpl<$Res, $Val extends ChatRoomCounterDto>
    implements $ChatRoomCounterDtoCopyWith<$Res> {
  _$ChatRoomCounterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatRoomCounterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? open = null,
    Object? pending = null,
    Object? solved = null,
    Object? closed = null,
  }) {
    return _then(
      _value.copyWith(
            open:
                null == open
                    ? _value.open
                    : open // ignore: cast_nullable_to_non_nullable
                        as int,
            pending:
                null == pending
                    ? _value.pending
                    : pending // ignore: cast_nullable_to_non_nullable
                        as int,
            solved:
                null == solved
                    ? _value.solved
                    : solved // ignore: cast_nullable_to_non_nullable
                        as int,
            closed:
                null == closed
                    ? _value.closed
                    : closed // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatRoomCounterDtoImplCopyWith<$Res>
    implements $ChatRoomCounterDtoCopyWith<$Res> {
  factory _$$ChatRoomCounterDtoImplCopyWith(
    _$ChatRoomCounterDtoImpl value,
    $Res Function(_$ChatRoomCounterDtoImpl) then,
  ) = __$$ChatRoomCounterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int open, int pending, int solved, int closed});
}

/// @nodoc
class __$$ChatRoomCounterDtoImplCopyWithImpl<$Res>
    extends _$ChatRoomCounterDtoCopyWithImpl<$Res, _$ChatRoomCounterDtoImpl>
    implements _$$ChatRoomCounterDtoImplCopyWith<$Res> {
  __$$ChatRoomCounterDtoImplCopyWithImpl(
    _$ChatRoomCounterDtoImpl _value,
    $Res Function(_$ChatRoomCounterDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatRoomCounterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? open = null,
    Object? pending = null,
    Object? solved = null,
    Object? closed = null,
  }) {
    return _then(
      _$ChatRoomCounterDtoImpl(
        open:
            null == open
                ? _value.open
                : open // ignore: cast_nullable_to_non_nullable
                    as int,
        pending:
            null == pending
                ? _value.pending
                : pending // ignore: cast_nullable_to_non_nullable
                    as int,
        solved:
            null == solved
                ? _value.solved
                : solved // ignore: cast_nullable_to_non_nullable
                    as int,
        closed:
            null == closed
                ? _value.closed
                : closed // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomCounterDtoImpl implements _ChatRoomCounterDto {
  const _$ChatRoomCounterDtoImpl({
    this.open = 0,
    this.pending = 0,
    this.solved = 0,
    this.closed = 0,
  });

  factory _$ChatRoomCounterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomCounterDtoImplFromJson(json);

  @override
  @JsonKey()
  final int open;
  @override
  @JsonKey()
  final int pending;
  @override
  @JsonKey()
  final int solved;
  @override
  @JsonKey()
  final int closed;

  @override
  String toString() {
    return 'ChatRoomCounterDto(open: $open, pending: $pending, solved: $solved, closed: $closed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomCounterDtoImpl &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.pending, pending) || other.pending == pending) &&
            (identical(other.solved, solved) || other.solved == solved) &&
            (identical(other.closed, closed) || other.closed == closed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, open, pending, solved, closed);

  /// Create a copy of ChatRoomCounterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomCounterDtoImplCopyWith<_$ChatRoomCounterDtoImpl> get copyWith =>
      __$$ChatRoomCounterDtoImplCopyWithImpl<_$ChatRoomCounterDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomCounterDtoImplToJson(this);
  }
}

abstract class _ChatRoomCounterDto implements ChatRoomCounterDto {
  const factory _ChatRoomCounterDto({
    final int open,
    final int pending,
    final int solved,
    final int closed,
  }) = _$ChatRoomCounterDtoImpl;

  factory _ChatRoomCounterDto.fromJson(Map<String, dynamic> json) =
      _$ChatRoomCounterDtoImpl.fromJson;

  @override
  int get open;
  @override
  int get pending;
  @override
  int get solved;
  @override
  int get closed;

  /// Create a copy of ChatRoomCounterDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatRoomCounterDtoImplCopyWith<_$ChatRoomCounterDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
