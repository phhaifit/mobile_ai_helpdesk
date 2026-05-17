// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatRoomDto _$ChatRoomDtoFromJson(Map<String, dynamic> json) {
  return _ChatRoomDto.fromJson(json);
}

/// @nodoc
mixin _$ChatRoomDto {
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customerID')
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'groupID')
  String? get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastMessageID')
  String get lastMessageId => throw _privateConstructorUsedError;
  int get totalMessage => throw _privateConstructorUsedError;
  int get followupCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticketID')
  String get ticketId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  MessageDto? get lastMessage => throw _privateConstructorUsedError;
  CustomerInfoDto? get customerInfo => throw _privateConstructorUsedError;
  GroupInfoDto? get groupInfo => throw _privateConstructorUsedError;
  Map<String, dynamic>? get myCurrentTicket =>
      throw _privateConstructorUsedError;
  List<TicketInfoDto>? get tickets => throw _privateConstructorUsedError;
  SeenInfoDto? get seenInfo => throw _privateConstructorUsedError;
  int get seenMessageOrder => throw _privateConstructorUsedError;
  Map<String, dynamic>? get defaultChannel =>
      throw _privateConstructorUsedError;

  /// Serializes this ChatRoomDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatRoomDtoCopyWith<ChatRoomDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomDtoCopyWith<$Res> {
  factory $ChatRoomDtoCopyWith(
    ChatRoomDto value,
    $Res Function(ChatRoomDto) then,
  ) = _$ChatRoomDtoCopyWithImpl<$Res, ChatRoomDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'customerID') String? customerId,
    @JsonKey(name: 'groupID') String? groupId,
    @JsonKey(name: 'lastMessageID') String lastMessageId,
    int totalMessage,
    int followupCount,
    @JsonKey(name: 'ticketID') String ticketId,
    DateTime createdAt,
    DateTime? updatedAt,
    MessageDto? lastMessage,
    CustomerInfoDto? customerInfo,
    GroupInfoDto? groupInfo,
    Map<String, dynamic>? myCurrentTicket,
    List<TicketInfoDto>? tickets,
    SeenInfoDto? seenInfo,
    int seenMessageOrder,
    Map<String, dynamic>? defaultChannel,
  });

  $MessageDtoCopyWith<$Res>? get lastMessage;
  $CustomerInfoDtoCopyWith<$Res>? get customerInfo;
  $GroupInfoDtoCopyWith<$Res>? get groupInfo;
  $SeenInfoDtoCopyWith<$Res>? get seenInfo;
}

/// @nodoc
class _$ChatRoomDtoCopyWithImpl<$Res, $Val extends ChatRoomDto>
    implements $ChatRoomDtoCopyWith<$Res> {
  _$ChatRoomDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatRoomId = null,
    Object? customerId = freezed,
    Object? groupId = freezed,
    Object? lastMessageId = null,
    Object? totalMessage = null,
    Object? followupCount = null,
    Object? ticketId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? lastMessage = freezed,
    Object? customerInfo = freezed,
    Object? groupInfo = freezed,
    Object? myCurrentTicket = freezed,
    Object? tickets = freezed,
    Object? seenInfo = freezed,
    Object? seenMessageOrder = null,
    Object? defaultChannel = freezed,
  }) {
    return _then(
      _value.copyWith(
            chatRoomId:
                null == chatRoomId
                    ? _value.chatRoomId
                    : chatRoomId // ignore: cast_nullable_to_non_nullable
                        as String,
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String?,
            groupId:
                freezed == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastMessageId:
                null == lastMessageId
                    ? _value.lastMessageId
                    : lastMessageId // ignore: cast_nullable_to_non_nullable
                        as String,
            totalMessage:
                null == totalMessage
                    ? _value.totalMessage
                    : totalMessage // ignore: cast_nullable_to_non_nullable
                        as int,
            followupCount:
                null == followupCount
                    ? _value.followupCount
                    : followupCount // ignore: cast_nullable_to_non_nullable
                        as int,
            ticketId:
                null == ticketId
                    ? _value.ticketId
                    : ticketId // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastMessage:
                freezed == lastMessage
                    ? _value.lastMessage
                    : lastMessage // ignore: cast_nullable_to_non_nullable
                        as MessageDto?,
            customerInfo:
                freezed == customerInfo
                    ? _value.customerInfo
                    : customerInfo // ignore: cast_nullable_to_non_nullable
                        as CustomerInfoDto?,
            groupInfo:
                freezed == groupInfo
                    ? _value.groupInfo
                    : groupInfo // ignore: cast_nullable_to_non_nullable
                        as GroupInfoDto?,
            myCurrentTicket:
                freezed == myCurrentTicket
                    ? _value.myCurrentTicket
                    : myCurrentTicket // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            tickets:
                freezed == tickets
                    ? _value.tickets
                    : tickets // ignore: cast_nullable_to_non_nullable
                        as List<TicketInfoDto>?,
            seenInfo:
                freezed == seenInfo
                    ? _value.seenInfo
                    : seenInfo // ignore: cast_nullable_to_non_nullable
                        as SeenInfoDto?,
            seenMessageOrder:
                null == seenMessageOrder
                    ? _value.seenMessageOrder
                    : seenMessageOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            defaultChannel:
                freezed == defaultChannel
                    ? _value.defaultChannel
                    : defaultChannel // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageDtoCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $MessageDtoCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }

  /// Create a copy of ChatRoomDto
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

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupInfoDtoCopyWith<$Res>? get groupInfo {
    if (_value.groupInfo == null) {
      return null;
    }

    return $GroupInfoDtoCopyWith<$Res>(_value.groupInfo!, (value) {
      return _then(_value.copyWith(groupInfo: value) as $Val);
    });
  }

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SeenInfoDtoCopyWith<$Res>? get seenInfo {
    if (_value.seenInfo == null) {
      return null;
    }

    return $SeenInfoDtoCopyWith<$Res>(_value.seenInfo!, (value) {
      return _then(_value.copyWith(seenInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatRoomDtoImplCopyWith<$Res>
    implements $ChatRoomDtoCopyWith<$Res> {
  factory _$$ChatRoomDtoImplCopyWith(
    _$ChatRoomDtoImpl value,
    $Res Function(_$ChatRoomDtoImpl) then,
  ) = __$$ChatRoomDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'customerID') String? customerId,
    @JsonKey(name: 'groupID') String? groupId,
    @JsonKey(name: 'lastMessageID') String lastMessageId,
    int totalMessage,
    int followupCount,
    @JsonKey(name: 'ticketID') String ticketId,
    DateTime createdAt,
    DateTime? updatedAt,
    MessageDto? lastMessage,
    CustomerInfoDto? customerInfo,
    GroupInfoDto? groupInfo,
    Map<String, dynamic>? myCurrentTicket,
    List<TicketInfoDto>? tickets,
    SeenInfoDto? seenInfo,
    int seenMessageOrder,
    Map<String, dynamic>? defaultChannel,
  });

  @override
  $MessageDtoCopyWith<$Res>? get lastMessage;
  @override
  $CustomerInfoDtoCopyWith<$Res>? get customerInfo;
  @override
  $GroupInfoDtoCopyWith<$Res>? get groupInfo;
  @override
  $SeenInfoDtoCopyWith<$Res>? get seenInfo;
}

/// @nodoc
class __$$ChatRoomDtoImplCopyWithImpl<$Res>
    extends _$ChatRoomDtoCopyWithImpl<$Res, _$ChatRoomDtoImpl>
    implements _$$ChatRoomDtoImplCopyWith<$Res> {
  __$$ChatRoomDtoImplCopyWithImpl(
    _$ChatRoomDtoImpl _value,
    $Res Function(_$ChatRoomDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatRoomId = null,
    Object? customerId = freezed,
    Object? groupId = freezed,
    Object? lastMessageId = null,
    Object? totalMessage = null,
    Object? followupCount = null,
    Object? ticketId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? lastMessage = freezed,
    Object? customerInfo = freezed,
    Object? groupInfo = freezed,
    Object? myCurrentTicket = freezed,
    Object? tickets = freezed,
    Object? seenInfo = freezed,
    Object? seenMessageOrder = null,
    Object? defaultChannel = freezed,
  }) {
    return _then(
      _$ChatRoomDtoImpl(
        chatRoomId:
            null == chatRoomId
                ? _value.chatRoomId
                : chatRoomId // ignore: cast_nullable_to_non_nullable
                    as String,
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String?,
        groupId:
            freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastMessageId:
            null == lastMessageId
                ? _value.lastMessageId
                : lastMessageId // ignore: cast_nullable_to_non_nullable
                    as String,
        totalMessage:
            null == totalMessage
                ? _value.totalMessage
                : totalMessage // ignore: cast_nullable_to_non_nullable
                    as int,
        followupCount:
            null == followupCount
                ? _value.followupCount
                : followupCount // ignore: cast_nullable_to_non_nullable
                    as int,
        ticketId:
            null == ticketId
                ? _value.ticketId
                : ticketId // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastMessage:
            freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                    as MessageDto?,
        customerInfo:
            freezed == customerInfo
                ? _value.customerInfo
                : customerInfo // ignore: cast_nullable_to_non_nullable
                    as CustomerInfoDto?,
        groupInfo:
            freezed == groupInfo
                ? _value.groupInfo
                : groupInfo // ignore: cast_nullable_to_non_nullable
                    as GroupInfoDto?,
        myCurrentTicket:
            freezed == myCurrentTicket
                ? _value._myCurrentTicket
                : myCurrentTicket // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        tickets:
            freezed == tickets
                ? _value._tickets
                : tickets // ignore: cast_nullable_to_non_nullable
                    as List<TicketInfoDto>?,
        seenInfo:
            freezed == seenInfo
                ? _value.seenInfo
                : seenInfo // ignore: cast_nullable_to_non_nullable
                    as SeenInfoDto?,
        seenMessageOrder:
            null == seenMessageOrder
                ? _value.seenMessageOrder
                : seenMessageOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        defaultChannel:
            freezed == defaultChannel
                ? _value._defaultChannel
                : defaultChannel // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomDtoImpl implements _ChatRoomDto {
  const _$ChatRoomDtoImpl({
    @JsonKey(name: 'chatRoomID') required this.chatRoomId,
    @JsonKey(name: 'customerID') this.customerId,
    @JsonKey(name: 'groupID') this.groupId,
    @JsonKey(name: 'lastMessageID') required this.lastMessageId,
    this.totalMessage = 0,
    this.followupCount = 0,
    @JsonKey(name: 'ticketID') required this.ticketId,
    required this.createdAt,
    this.updatedAt,
    this.lastMessage,
    this.customerInfo,
    this.groupInfo,
    final Map<String, dynamic>? myCurrentTicket,
    final List<TicketInfoDto>? tickets,
    this.seenInfo,
    this.seenMessageOrder = 0,
    final Map<String, dynamic>? defaultChannel,
  }) : _myCurrentTicket = myCurrentTicket,
       _tickets = tickets,
       _defaultChannel = defaultChannel;

  factory _$ChatRoomDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomDtoImplFromJson(json);

  @override
  @JsonKey(name: 'chatRoomID')
  final String chatRoomId;
  @override
  @JsonKey(name: 'customerID')
  final String? customerId;
  @override
  @JsonKey(name: 'groupID')
  final String? groupId;
  @override
  @JsonKey(name: 'lastMessageID')
  final String lastMessageId;
  @override
  @JsonKey()
  final int totalMessage;
  @override
  @JsonKey()
  final int followupCount;
  @override
  @JsonKey(name: 'ticketID')
  final String ticketId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final MessageDto? lastMessage;
  @override
  final CustomerInfoDto? customerInfo;
  @override
  final GroupInfoDto? groupInfo;
  final Map<String, dynamic>? _myCurrentTicket;
  @override
  Map<String, dynamic>? get myCurrentTicket {
    final value = _myCurrentTicket;
    if (value == null) return null;
    if (_myCurrentTicket is EqualUnmodifiableMapView) return _myCurrentTicket;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<TicketInfoDto>? _tickets;
  @override
  List<TicketInfoDto>? get tickets {
    final value = _tickets;
    if (value == null) return null;
    if (_tickets is EqualUnmodifiableListView) return _tickets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final SeenInfoDto? seenInfo;
  @override
  @JsonKey()
  final int seenMessageOrder;
  final Map<String, dynamic>? _defaultChannel;
  @override
  Map<String, dynamic>? get defaultChannel {
    final value = _defaultChannel;
    if (value == null) return null;
    if (_defaultChannel is EqualUnmodifiableMapView) return _defaultChannel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ChatRoomDto(chatRoomId: $chatRoomId, customerId: $customerId, groupId: $groupId, lastMessageId: $lastMessageId, totalMessage: $totalMessage, followupCount: $followupCount, ticketId: $ticketId, createdAt: $createdAt, updatedAt: $updatedAt, lastMessage: $lastMessage, customerInfo: $customerInfo, groupInfo: $groupInfo, myCurrentTicket: $myCurrentTicket, tickets: $tickets, seenInfo: $seenInfo, seenMessageOrder: $seenMessageOrder, defaultChannel: $defaultChannel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomDtoImpl &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.lastMessageId, lastMessageId) ||
                other.lastMessageId == lastMessageId) &&
            (identical(other.totalMessage, totalMessage) ||
                other.totalMessage == totalMessage) &&
            (identical(other.followupCount, followupCount) ||
                other.followupCount == followupCount) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.customerInfo, customerInfo) ||
                other.customerInfo == customerInfo) &&
            (identical(other.groupInfo, groupInfo) ||
                other.groupInfo == groupInfo) &&
            const DeepCollectionEquality().equals(
              other._myCurrentTicket,
              _myCurrentTicket,
            ) &&
            const DeepCollectionEquality().equals(other._tickets, _tickets) &&
            (identical(other.seenInfo, seenInfo) ||
                other.seenInfo == seenInfo) &&
            (identical(other.seenMessageOrder, seenMessageOrder) ||
                other.seenMessageOrder == seenMessageOrder) &&
            const DeepCollectionEquality().equals(
              other._defaultChannel,
              _defaultChannel,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chatRoomId,
    customerId,
    groupId,
    lastMessageId,
    totalMessage,
    followupCount,
    ticketId,
    createdAt,
    updatedAt,
    lastMessage,
    customerInfo,
    groupInfo,
    const DeepCollectionEquality().hash(_myCurrentTicket),
    const DeepCollectionEquality().hash(_tickets),
    seenInfo,
    seenMessageOrder,
    const DeepCollectionEquality().hash(_defaultChannel),
  );

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomDtoImplCopyWith<_$ChatRoomDtoImpl> get copyWith =>
      __$$ChatRoomDtoImplCopyWithImpl<_$ChatRoomDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomDtoImplToJson(this);
  }
}

abstract class _ChatRoomDto implements ChatRoomDto {
  const factory _ChatRoomDto({
    @JsonKey(name: 'chatRoomID') required final String chatRoomId,
    @JsonKey(name: 'customerID') final String? customerId,
    @JsonKey(name: 'groupID') final String? groupId,
    @JsonKey(name: 'lastMessageID') required final String lastMessageId,
    final int totalMessage,
    final int followupCount,
    @JsonKey(name: 'ticketID') required final String ticketId,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final MessageDto? lastMessage,
    final CustomerInfoDto? customerInfo,
    final GroupInfoDto? groupInfo,
    final Map<String, dynamic>? myCurrentTicket,
    final List<TicketInfoDto>? tickets,
    final SeenInfoDto? seenInfo,
    final int seenMessageOrder,
    final Map<String, dynamic>? defaultChannel,
  }) = _$ChatRoomDtoImpl;

  factory _ChatRoomDto.fromJson(Map<String, dynamic> json) =
      _$ChatRoomDtoImpl.fromJson;

  @override
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId;
  @override
  @JsonKey(name: 'customerID')
  String? get customerId;
  @override
  @JsonKey(name: 'groupID')
  String? get groupId;
  @override
  @JsonKey(name: 'lastMessageID')
  String get lastMessageId;
  @override
  int get totalMessage;
  @override
  int get followupCount;
  @override
  @JsonKey(name: 'ticketID')
  String get ticketId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  MessageDto? get lastMessage;
  @override
  CustomerInfoDto? get customerInfo;
  @override
  GroupInfoDto? get groupInfo;
  @override
  Map<String, dynamic>? get myCurrentTicket;
  @override
  List<TicketInfoDto>? get tickets;
  @override
  SeenInfoDto? get seenInfo;
  @override
  int get seenMessageOrder;
  @override
  Map<String, dynamic>? get defaultChannel;

  /// Create a copy of ChatRoomDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatRoomDtoImplCopyWith<_$ChatRoomDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
