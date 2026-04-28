// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fetch_chat_rooms_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FetchChatRoomsParams _$FetchChatRoomsParamsFromJson(Map<String, dynamic> json) {
  return _FetchChatRoomsParams.fromJson(json);
}

/// @nodoc
mixin _$FetchChatRoomsParams {
  @JsonKey(includeIfNull: false)
  String? get customerName => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastMessageID', includeIfNull: false)
  String? get lastMessageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastChatRoomID', includeIfNull: false)
  String? get lastChatRoomId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get lastChatRoomUpdatedAt => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<String>? get statuses => throw _privateConstructorUsedError;
  @JsonKey(name: 'channel', includeIfNull: false)
  List<String>? get channels => throw _privateConstructorUsedError;
  @JsonKey(name: 'channelIDs', includeIfNull: false)
  List<String>? get channelIds => throw _privateConstructorUsedError;
  DateTime? get updatedAtFrom =>
      throw _privateConstructorUsedError; // Note: This was missing in your original toJson, but json_serializable will now handle it!
  DateTime? get updatedAtTo =>
      throw _privateConstructorUsedError; // Note: This was missing in your original toJson, but json_serializable will now handle it!
  bool get getCounter => throw _privateConstructorUsedError;
  bool get getAll => throw _privateConstructorUsedError;

  /// Serializes this FetchChatRoomsParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FetchChatRoomsParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FetchChatRoomsParamsCopyWith<FetchChatRoomsParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FetchChatRoomsParamsCopyWith<$Res> {
  factory $FetchChatRoomsParamsCopyWith(
    FetchChatRoomsParams value,
    $Res Function(FetchChatRoomsParams) then,
  ) = _$FetchChatRoomsParamsCopyWithImpl<$Res, FetchChatRoomsParams>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? customerName,
    int limit,
    @JsonKey(name: 'lastMessageID', includeIfNull: false) String? lastMessageId,
    @JsonKey(name: 'lastChatRoomID', includeIfNull: false)
    String? lastChatRoomId,
    @JsonKey(includeIfNull: false) String? lastChatRoomUpdatedAt,
    @JsonKey(includeIfNull: false) String? status,
    @JsonKey(includeIfNull: false) List<String>? statuses,
    @JsonKey(name: 'channel', includeIfNull: false) List<String>? channels,
    @JsonKey(name: 'channelIDs', includeIfNull: false) List<String>? channelIds,
    DateTime? updatedAtFrom,
    DateTime? updatedAtTo,
    bool getCounter,
    bool getAll,
  });
}

/// @nodoc
class _$FetchChatRoomsParamsCopyWithImpl<
  $Res,
  $Val extends FetchChatRoomsParams
>
    implements $FetchChatRoomsParamsCopyWith<$Res> {
  _$FetchChatRoomsParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FetchChatRoomsParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerName = freezed,
    Object? limit = null,
    Object? lastMessageId = freezed,
    Object? lastChatRoomId = freezed,
    Object? lastChatRoomUpdatedAt = freezed,
    Object? status = freezed,
    Object? statuses = freezed,
    Object? channels = freezed,
    Object? channelIds = freezed,
    Object? updatedAtFrom = freezed,
    Object? updatedAtTo = freezed,
    Object? getCounter = null,
    Object? getAll = null,
  }) {
    return _then(
      _value.copyWith(
            customerName:
                freezed == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            limit:
                null == limit
                    ? _value.limit
                    : limit // ignore: cast_nullable_to_non_nullable
                        as int,
            lastMessageId:
                freezed == lastMessageId
                    ? _value.lastMessageId
                    : lastMessageId // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastChatRoomId:
                freezed == lastChatRoomId
                    ? _value.lastChatRoomId
                    : lastChatRoomId // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastChatRoomUpdatedAt:
                freezed == lastChatRoomUpdatedAt
                    ? _value.lastChatRoomUpdatedAt
                    : lastChatRoomUpdatedAt // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
            statuses:
                freezed == statuses
                    ? _value.statuses
                    : statuses // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            channels:
                freezed == channels
                    ? _value.channels
                    : channels // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            channelIds:
                freezed == channelIds
                    ? _value.channelIds
                    : channelIds // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            updatedAtFrom:
                freezed == updatedAtFrom
                    ? _value.updatedAtFrom
                    : updatedAtFrom // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAtTo:
                freezed == updatedAtTo
                    ? _value.updatedAtTo
                    : updatedAtTo // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            getCounter:
                null == getCounter
                    ? _value.getCounter
                    : getCounter // ignore: cast_nullable_to_non_nullable
                        as bool,
            getAll:
                null == getAll
                    ? _value.getAll
                    : getAll // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FetchChatRoomsParamsImplCopyWith<$Res>
    implements $FetchChatRoomsParamsCopyWith<$Res> {
  factory _$$FetchChatRoomsParamsImplCopyWith(
    _$FetchChatRoomsParamsImpl value,
    $Res Function(_$FetchChatRoomsParamsImpl) then,
  ) = __$$FetchChatRoomsParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? customerName,
    int limit,
    @JsonKey(name: 'lastMessageID', includeIfNull: false) String? lastMessageId,
    @JsonKey(name: 'lastChatRoomID', includeIfNull: false)
    String? lastChatRoomId,
    @JsonKey(includeIfNull: false) String? lastChatRoomUpdatedAt,
    @JsonKey(includeIfNull: false) String? status,
    @JsonKey(includeIfNull: false) List<String>? statuses,
    @JsonKey(name: 'channel', includeIfNull: false) List<String>? channels,
    @JsonKey(name: 'channelIDs', includeIfNull: false) List<String>? channelIds,
    DateTime? updatedAtFrom,
    DateTime? updatedAtTo,
    bool getCounter,
    bool getAll,
  });
}

/// @nodoc
class __$$FetchChatRoomsParamsImplCopyWithImpl<$Res>
    extends _$FetchChatRoomsParamsCopyWithImpl<$Res, _$FetchChatRoomsParamsImpl>
    implements _$$FetchChatRoomsParamsImplCopyWith<$Res> {
  __$$FetchChatRoomsParamsImplCopyWithImpl(
    _$FetchChatRoomsParamsImpl _value,
    $Res Function(_$FetchChatRoomsParamsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FetchChatRoomsParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerName = freezed,
    Object? limit = null,
    Object? lastMessageId = freezed,
    Object? lastChatRoomId = freezed,
    Object? lastChatRoomUpdatedAt = freezed,
    Object? status = freezed,
    Object? statuses = freezed,
    Object? channels = freezed,
    Object? channelIds = freezed,
    Object? updatedAtFrom = freezed,
    Object? updatedAtTo = freezed,
    Object? getCounter = null,
    Object? getAll = null,
  }) {
    return _then(
      _$FetchChatRoomsParamsImpl(
        customerName:
            freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        limit:
            null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                    as int,
        lastMessageId:
            freezed == lastMessageId
                ? _value.lastMessageId
                : lastMessageId // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastChatRoomId:
            freezed == lastChatRoomId
                ? _value.lastChatRoomId
                : lastChatRoomId // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastChatRoomUpdatedAt:
            freezed == lastChatRoomUpdatedAt
                ? _value.lastChatRoomUpdatedAt
                : lastChatRoomUpdatedAt // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
        statuses:
            freezed == statuses
                ? _value._statuses
                : statuses // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        channels:
            freezed == channels
                ? _value._channels
                : channels // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        channelIds:
            freezed == channelIds
                ? _value._channelIds
                : channelIds // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        updatedAtFrom:
            freezed == updatedAtFrom
                ? _value.updatedAtFrom
                : updatedAtFrom // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAtTo:
            freezed == updatedAtTo
                ? _value.updatedAtTo
                : updatedAtTo // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        getCounter:
            null == getCounter
                ? _value.getCounter
                : getCounter // ignore: cast_nullable_to_non_nullable
                    as bool,
        getAll:
            null == getAll
                ? _value.getAll
                : getAll // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FetchChatRoomsParamsImpl implements _FetchChatRoomsParams {
  const _$FetchChatRoomsParamsImpl({
    @JsonKey(includeIfNull: false) this.customerName,
    this.limit = 20,
    @JsonKey(name: 'lastMessageID', includeIfNull: false) this.lastMessageId,
    @JsonKey(name: 'lastChatRoomID', includeIfNull: false) this.lastChatRoomId,
    @JsonKey(includeIfNull: false) this.lastChatRoomUpdatedAt,
    @JsonKey(includeIfNull: false) this.status,
    @JsonKey(includeIfNull: false) final List<String>? statuses,
    @JsonKey(name: 'channel', includeIfNull: false)
    final List<String>? channels,
    @JsonKey(name: 'channelIDs', includeIfNull: false)
    final List<String>? channelIds,
    this.updatedAtFrom,
    this.updatedAtTo,
    this.getCounter = false,
    this.getAll = false,
  }) : _statuses = statuses,
       _channels = channels,
       _channelIds = channelIds;

  factory _$FetchChatRoomsParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FetchChatRoomsParamsImplFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  final String? customerName;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey(name: 'lastMessageID', includeIfNull: false)
  final String? lastMessageId;
  @override
  @JsonKey(name: 'lastChatRoomID', includeIfNull: false)
  final String? lastChatRoomId;
  @override
  @JsonKey(includeIfNull: false)
  final String? lastChatRoomUpdatedAt;
  @override
  @JsonKey(includeIfNull: false)
  final String? status;
  final List<String>? _statuses;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _channels;
  @override
  @JsonKey(name: 'channel', includeIfNull: false)
  List<String>? get channels {
    final value = _channels;
    if (value == null) return null;
    if (_channels is EqualUnmodifiableListView) return _channels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _channelIds;
  @override
  @JsonKey(name: 'channelIDs', includeIfNull: false)
  List<String>? get channelIds {
    final value = _channelIds;
    if (value == null) return null;
    if (_channelIds is EqualUnmodifiableListView) return _channelIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? updatedAtFrom;
  // Note: This was missing in your original toJson, but json_serializable will now handle it!
  @override
  final DateTime? updatedAtTo;
  // Note: This was missing in your original toJson, but json_serializable will now handle it!
  @override
  @JsonKey()
  final bool getCounter;
  @override
  @JsonKey()
  final bool getAll;

  @override
  String toString() {
    return 'FetchChatRoomsParams(customerName: $customerName, limit: $limit, lastMessageId: $lastMessageId, lastChatRoomId: $lastChatRoomId, lastChatRoomUpdatedAt: $lastChatRoomUpdatedAt, status: $status, statuses: $statuses, channels: $channels, channelIds: $channelIds, updatedAtFrom: $updatedAtFrom, updatedAtTo: $updatedAtTo, getCounter: $getCounter, getAll: $getAll)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchChatRoomsParamsImpl &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.lastMessageId, lastMessageId) ||
                other.lastMessageId == lastMessageId) &&
            (identical(other.lastChatRoomId, lastChatRoomId) ||
                other.lastChatRoomId == lastChatRoomId) &&
            (identical(other.lastChatRoomUpdatedAt, lastChatRoomUpdatedAt) ||
                other.lastChatRoomUpdatedAt == lastChatRoomUpdatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            const DeepCollectionEquality().equals(other._channels, _channels) &&
            const DeepCollectionEquality().equals(
              other._channelIds,
              _channelIds,
            ) &&
            (identical(other.updatedAtFrom, updatedAtFrom) ||
                other.updatedAtFrom == updatedAtFrom) &&
            (identical(other.updatedAtTo, updatedAtTo) ||
                other.updatedAtTo == updatedAtTo) &&
            (identical(other.getCounter, getCounter) ||
                other.getCounter == getCounter) &&
            (identical(other.getAll, getAll) || other.getAll == getAll));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    customerName,
    limit,
    lastMessageId,
    lastChatRoomId,
    lastChatRoomUpdatedAt,
    status,
    const DeepCollectionEquality().hash(_statuses),
    const DeepCollectionEquality().hash(_channels),
    const DeepCollectionEquality().hash(_channelIds),
    updatedAtFrom,
    updatedAtTo,
    getCounter,
    getAll,
  );

  /// Create a copy of FetchChatRoomsParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchChatRoomsParamsImplCopyWith<_$FetchChatRoomsParamsImpl>
  get copyWith =>
      __$$FetchChatRoomsParamsImplCopyWithImpl<_$FetchChatRoomsParamsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FetchChatRoomsParamsImplToJson(this);
  }
}

abstract class _FetchChatRoomsParams implements FetchChatRoomsParams {
  const factory _FetchChatRoomsParams({
    @JsonKey(includeIfNull: false) final String? customerName,
    final int limit,
    @JsonKey(name: 'lastMessageID', includeIfNull: false)
    final String? lastMessageId,
    @JsonKey(name: 'lastChatRoomID', includeIfNull: false)
    final String? lastChatRoomId,
    @JsonKey(includeIfNull: false) final String? lastChatRoomUpdatedAt,
    @JsonKey(includeIfNull: false) final String? status,
    @JsonKey(includeIfNull: false) final List<String>? statuses,
    @JsonKey(name: 'channel', includeIfNull: false)
    final List<String>? channels,
    @JsonKey(name: 'channelIDs', includeIfNull: false)
    final List<String>? channelIds,
    final DateTime? updatedAtFrom,
    final DateTime? updatedAtTo,
    final bool getCounter,
    final bool getAll,
  }) = _$FetchChatRoomsParamsImpl;

  factory _FetchChatRoomsParams.fromJson(Map<String, dynamic> json) =
      _$FetchChatRoomsParamsImpl.fromJson;

  @override
  @JsonKey(includeIfNull: false)
  String? get customerName;
  @override
  int get limit;
  @override
  @JsonKey(name: 'lastMessageID', includeIfNull: false)
  String? get lastMessageId;
  @override
  @JsonKey(name: 'lastChatRoomID', includeIfNull: false)
  String? get lastChatRoomId;
  @override
  @JsonKey(includeIfNull: false)
  String? get lastChatRoomUpdatedAt;
  @override
  @JsonKey(includeIfNull: false)
  String? get status;
  @override
  @JsonKey(includeIfNull: false)
  List<String>? get statuses;
  @override
  @JsonKey(name: 'channel', includeIfNull: false)
  List<String>? get channels;
  @override
  @JsonKey(name: 'channelIDs', includeIfNull: false)
  List<String>? get channelIds;
  @override
  DateTime? get updatedAtFrom; // Note: This was missing in your original toJson, but json_serializable will now handle it!
  @override
  DateTime? get updatedAtTo; // Note: This was missing in your original toJson, but json_serializable will now handle it!
  @override
  bool get getCounter;
  @override
  bool get getAll;

  /// Create a copy of FetchChatRoomsParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchChatRoomsParamsImplCopyWith<_$FetchChatRoomsParamsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
