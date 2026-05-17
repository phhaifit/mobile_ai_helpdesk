// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TicketInfoDto _$TicketInfoDtoFromJson(Map<String, dynamic> json) {
  return _TicketInfoDto.fromJson(json);
}

/// @nodoc
mixin _$TicketInfoDto {
  @JsonKey(name: 'ticketID')
  String get ticketId => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'priority')
  String get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this TicketInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketInfoDtoCopyWith<TicketInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketInfoDtoCopyWith<$Res> {
  factory $TicketInfoDtoCopyWith(
    TicketInfoDto value,
    $Res Function(TicketInfoDto) then,
  ) = _$TicketInfoDtoCopyWithImpl<$Res, TicketInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'ticketID') String ticketId,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'priority') String priority,
    @JsonKey(name: 'title') String title,
    @JsonKey(name: 'description') String? description,
  });
}

/// @nodoc
class _$TicketInfoDtoCopyWithImpl<$Res, $Val extends TicketInfoDto>
    implements $TicketInfoDtoCopyWith<$Res> {
  _$TicketInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? status = null,
    Object? priority = null,
    Object? title = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            ticketId:
                null == ticketId
                    ? _value.ticketId
                    : ticketId // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            priority:
                null == priority
                    ? _value.priority
                    : priority // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TicketInfoDtoImplCopyWith<$Res>
    implements $TicketInfoDtoCopyWith<$Res> {
  factory _$$TicketInfoDtoImplCopyWith(
    _$TicketInfoDtoImpl value,
    $Res Function(_$TicketInfoDtoImpl) then,
  ) = __$$TicketInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ticketID') String ticketId,
    @JsonKey(name: 'status') String status,
    @JsonKey(name: 'priority') String priority,
    @JsonKey(name: 'title') String title,
    @JsonKey(name: 'description') String? description,
  });
}

/// @nodoc
class __$$TicketInfoDtoImplCopyWithImpl<$Res>
    extends _$TicketInfoDtoCopyWithImpl<$Res, _$TicketInfoDtoImpl>
    implements _$$TicketInfoDtoImplCopyWith<$Res> {
  __$$TicketInfoDtoImplCopyWithImpl(
    _$TicketInfoDtoImpl _value,
    $Res Function(_$TicketInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TicketInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? status = null,
    Object? priority = null,
    Object? title = null,
    Object? description = freezed,
  }) {
    return _then(
      _$TicketInfoDtoImpl(
        ticketId:
            null == ticketId
                ? _value.ticketId
                : ticketId // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        priority:
            null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketInfoDtoImpl implements _TicketInfoDto {
  const _$TicketInfoDtoImpl({
    @JsonKey(name: 'ticketID') required this.ticketId,
    @JsonKey(name: 'status') required this.status,
    @JsonKey(name: 'priority') required this.priority,
    @JsonKey(name: 'title') required this.title,
    @JsonKey(name: 'description') this.description = '',
  });

  factory _$TicketInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'ticketID')
  final String ticketId;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'priority')
  final String priority;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'description')
  final String? description;

  @override
  String toString() {
    return 'TicketInfoDto(ticketId: $ticketId, status: $status, priority: $priority, title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketInfoDtoImpl &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, ticketId, status, priority, title, description);

  /// Create a copy of TicketInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketInfoDtoImplCopyWith<_$TicketInfoDtoImpl> get copyWith =>
      __$$TicketInfoDtoImplCopyWithImpl<_$TicketInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketInfoDtoImplToJson(this);
  }
}

abstract class _TicketInfoDto implements TicketInfoDto {
  const factory _TicketInfoDto({
    @JsonKey(name: 'ticketID') required final String ticketId,
    @JsonKey(name: 'status') required final String status,
    @JsonKey(name: 'priority') required final String priority,
    @JsonKey(name: 'title') required final String title,
    @JsonKey(name: 'description') final String? description,
  }) = _$TicketInfoDtoImpl;

  factory _TicketInfoDto.fromJson(Map<String, dynamic> json) =
      _$TicketInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'ticketID')
  String get ticketId;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'priority')
  String get priority;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Create a copy of TicketInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketInfoDtoImplCopyWith<_$TicketInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
