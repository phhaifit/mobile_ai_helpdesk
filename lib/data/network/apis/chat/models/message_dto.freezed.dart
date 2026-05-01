// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  return _MessageDto.fromJson(json);
}

/// @nodoc
mixin _$MessageDto {
  @JsonKey(name: 'messageID')
  String get messageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'contactID')
  String get contactId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticketID')
  String? get ticketId => throw _privateConstructorUsedError;
  String? get sender => throw _privateConstructorUsedError;
  @JsonKey(name: 'replyMessageID')
  String? get replyMessageId => throw _privateConstructorUsedError;
  int get messageOrder => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  @JsonKey(name: 'channelID')
  String? get channelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'zaloCliMsgID')
  String? get zaloCliMsgId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  ContactInfoDto get contactInfo => throw _privateConstructorUsedError;
  Map<String, dynamic> get contentInfo => throw _privateConstructorUsedError;
  Map<String, dynamic> get ticketInfo => throw _privateConstructorUsedError;
  List<FileAttachmentDto> get files => throw _privateConstructorUsedError;
  List<MessageReactionDto> get reaction => throw _privateConstructorUsedError;
  Map<String, dynamic> get replyMessage => throw _privateConstructorUsedError;
  Map<String, dynamic> get slackMessage => throw _privateConstructorUsedError;
  Map<String, dynamic> get zohoDeskMessage =>
      throw _privateConstructorUsedError;

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageDtoCopyWith<MessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDtoCopyWith<$Res> {
  factory $MessageDtoCopyWith(
    MessageDto value,
    $Res Function(MessageDto) then,
  ) = _$MessageDtoCopyWithImpl<$Res, MessageDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'messageID') String messageId,
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'ticketID') String? ticketId,
    String? sender,
    @JsonKey(name: 'replyMessageID') String? replyMessageId,
    int messageOrder,
    String messageType,
    @JsonKey(name: 'channelID') String? channelId,
    @JsonKey(name: 'zaloCliMsgID') String? zaloCliMsgId,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    ContactInfoDto contactInfo,
    Map<String, dynamic> contentInfo,
    Map<String, dynamic> ticketInfo,
    List<FileAttachmentDto> files,
    List<MessageReactionDto> reaction,
    Map<String, dynamic> replyMessage,
    Map<String, dynamic> slackMessage,
    Map<String, dynamic> zohoDeskMessage,
  });

  $ContactInfoDtoCopyWith<$Res> get contactInfo;
}

/// @nodoc
class _$MessageDtoCopyWithImpl<$Res, $Val extends MessageDto>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? chatRoomId = null,
    Object? contactId = null,
    Object? ticketId = freezed,
    Object? sender = freezed,
    Object? replyMessageId = freezed,
    Object? messageOrder = null,
    Object? messageType = null,
    Object? channelId = freezed,
    Object? zaloCliMsgId = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? contactInfo = null,
    Object? contentInfo = null,
    Object? ticketInfo = null,
    Object? files = null,
    Object? reaction = null,
    Object? replyMessage = null,
    Object? slackMessage = null,
    Object? zohoDeskMessage = null,
  }) {
    return _then(
      _value.copyWith(
            messageId:
                null == messageId
                    ? _value.messageId
                    : messageId // ignore: cast_nullable_to_non_nullable
                        as String,
            chatRoomId:
                null == chatRoomId
                    ? _value.chatRoomId
                    : chatRoomId // ignore: cast_nullable_to_non_nullable
                        as String,
            contactId:
                null == contactId
                    ? _value.contactId
                    : contactId // ignore: cast_nullable_to_non_nullable
                        as String,
            ticketId:
                freezed == ticketId
                    ? _value.ticketId
                    : ticketId // ignore: cast_nullable_to_non_nullable
                        as String?,
            sender:
                freezed == sender
                    ? _value.sender
                    : sender // ignore: cast_nullable_to_non_nullable
                        as String?,
            replyMessageId:
                freezed == replyMessageId
                    ? _value.replyMessageId
                    : replyMessageId // ignore: cast_nullable_to_non_nullable
                        as String?,
            messageOrder:
                null == messageOrder
                    ? _value.messageOrder
                    : messageOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            messageType:
                null == messageType
                    ? _value.messageType
                    : messageType // ignore: cast_nullable_to_non_nullable
                        as String,
            channelId:
                freezed == channelId
                    ? _value.channelId
                    : channelId // ignore: cast_nullable_to_non_nullable
                        as String?,
            zaloCliMsgId:
                freezed == zaloCliMsgId
                    ? _value.zaloCliMsgId
                    : zaloCliMsgId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            deletedAt:
                freezed == deletedAt
                    ? _value.deletedAt
                    : deletedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            contactInfo:
                null == contactInfo
                    ? _value.contactInfo
                    : contactInfo // ignore: cast_nullable_to_non_nullable
                        as ContactInfoDto,
            contentInfo:
                null == contentInfo
                    ? _value.contentInfo
                    : contentInfo // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            ticketInfo:
                null == ticketInfo
                    ? _value.ticketInfo
                    : ticketInfo // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            files:
                null == files
                    ? _value.files
                    : files // ignore: cast_nullable_to_non_nullable
                        as List<FileAttachmentDto>,
            reaction:
                null == reaction
                    ? _value.reaction
                    : reaction // ignore: cast_nullable_to_non_nullable
                        as List<MessageReactionDto>,
            replyMessage:
                null == replyMessage
                    ? _value.replyMessage
                    : replyMessage // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            slackMessage:
                null == slackMessage
                    ? _value.slackMessage
                    : slackMessage // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            zohoDeskMessage:
                null == zohoDeskMessage
                    ? _value.zohoDeskMessage
                    : zohoDeskMessage // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
          )
          as $Val,
    );
  }

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactInfoDtoCopyWith<$Res> get contactInfo {
    return $ContactInfoDtoCopyWith<$Res>(_value.contactInfo, (value) {
      return _then(_value.copyWith(contactInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageDtoImplCopyWith<$Res>
    implements $MessageDtoCopyWith<$Res> {
  factory _$$MessageDtoImplCopyWith(
    _$MessageDtoImpl value,
    $Res Function(_$MessageDtoImpl) then,
  ) = __$$MessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'messageID') String messageId,
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'ticketID') String? ticketId,
    String? sender,
    @JsonKey(name: 'replyMessageID') String? replyMessageId,
    int messageOrder,
    String messageType,
    @JsonKey(name: 'channelID') String? channelId,
    @JsonKey(name: 'zaloCliMsgID') String? zaloCliMsgId,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    ContactInfoDto contactInfo,
    Map<String, dynamic> contentInfo,
    Map<String, dynamic> ticketInfo,
    List<FileAttachmentDto> files,
    List<MessageReactionDto> reaction,
    Map<String, dynamic> replyMessage,
    Map<String, dynamic> slackMessage,
    Map<String, dynamic> zohoDeskMessage,
  });

  @override
  $ContactInfoDtoCopyWith<$Res> get contactInfo;
}

/// @nodoc
class __$$MessageDtoImplCopyWithImpl<$Res>
    extends _$MessageDtoCopyWithImpl<$Res, _$MessageDtoImpl>
    implements _$$MessageDtoImplCopyWith<$Res> {
  __$$MessageDtoImplCopyWithImpl(
    _$MessageDtoImpl _value,
    $Res Function(_$MessageDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? chatRoomId = null,
    Object? contactId = null,
    Object? ticketId = freezed,
    Object? sender = freezed,
    Object? replyMessageId = freezed,
    Object? messageOrder = null,
    Object? messageType = null,
    Object? channelId = freezed,
    Object? zaloCliMsgId = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? contactInfo = null,
    Object? contentInfo = null,
    Object? ticketInfo = null,
    Object? files = null,
    Object? reaction = null,
    Object? replyMessage = null,
    Object? slackMessage = null,
    Object? zohoDeskMessage = null,
  }) {
    return _then(
      _$MessageDtoImpl(
        messageId:
            null == messageId
                ? _value.messageId
                : messageId // ignore: cast_nullable_to_non_nullable
                    as String,
        chatRoomId:
            null == chatRoomId
                ? _value.chatRoomId
                : chatRoomId // ignore: cast_nullable_to_non_nullable
                    as String,
        contactId:
            null == contactId
                ? _value.contactId
                : contactId // ignore: cast_nullable_to_non_nullable
                    as String,
        ticketId:
            freezed == ticketId
                ? _value.ticketId
                : ticketId // ignore: cast_nullable_to_non_nullable
                    as String?,
        sender:
            freezed == sender
                ? _value.sender
                : sender // ignore: cast_nullable_to_non_nullable
                    as String?,
        replyMessageId:
            freezed == replyMessageId
                ? _value.replyMessageId
                : replyMessageId // ignore: cast_nullable_to_non_nullable
                    as String?,
        messageOrder:
            null == messageOrder
                ? _value.messageOrder
                : messageOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        messageType:
            null == messageType
                ? _value.messageType
                : messageType // ignore: cast_nullable_to_non_nullable
                    as String,
        channelId:
            freezed == channelId
                ? _value.channelId
                : channelId // ignore: cast_nullable_to_non_nullable
                    as String?,
        zaloCliMsgId:
            freezed == zaloCliMsgId
                ? _value.zaloCliMsgId
                : zaloCliMsgId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        deletedAt:
            freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        contactInfo:
            null == contactInfo
                ? _value.contactInfo
                : contactInfo // ignore: cast_nullable_to_non_nullable
                    as ContactInfoDto,
        contentInfo:
            null == contentInfo
                ? _value._contentInfo
                : contentInfo // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        ticketInfo:
            null == ticketInfo
                ? _value._ticketInfo
                : ticketInfo // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        files:
            null == files
                ? _value._files
                : files // ignore: cast_nullable_to_non_nullable
                    as List<FileAttachmentDto>,
        reaction:
            null == reaction
                ? _value._reaction
                : reaction // ignore: cast_nullable_to_non_nullable
                    as List<MessageReactionDto>,
        replyMessage:
            null == replyMessage
                ? _value._replyMessage
                : replyMessage // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        slackMessage:
            null == slackMessage
                ? _value._slackMessage
                : slackMessage // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        zohoDeskMessage:
            null == zohoDeskMessage
                ? _value._zohoDeskMessage
                : zohoDeskMessage // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageDtoImpl implements _MessageDto {
  const _$MessageDtoImpl({
    @JsonKey(name: 'messageID') this.messageId = '',
    @JsonKey(name: 'chatRoomID') this.chatRoomId = '',
    @JsonKey(name: 'contactID') this.contactId = '',
    @JsonKey(name: 'ticketID') this.ticketId,
    this.sender,
    @JsonKey(name: 'replyMessageID') this.replyMessageId,
    this.messageOrder = 0,
    this.messageType = '',
    @JsonKey(name: 'channelID') this.channelId,
    @JsonKey(name: 'zaloCliMsgID') this.zaloCliMsgId,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.contactInfo,
    final Map<String, dynamic> contentInfo = const {},
    final Map<String, dynamic> ticketInfo = const {},
    final List<FileAttachmentDto> files = const [],
    final List<MessageReactionDto> reaction = const [],
    final Map<String, dynamic> replyMessage = const {},
    final Map<String, dynamic> slackMessage = const {},
    final Map<String, dynamic> zohoDeskMessage = const {},
  }) : _contentInfo = contentInfo,
       _ticketInfo = ticketInfo,
       _files = files,
       _reaction = reaction,
       _replyMessage = replyMessage,
       _slackMessage = slackMessage,
       _zohoDeskMessage = zohoDeskMessage;

  factory _$MessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDtoImplFromJson(json);

  @override
  @JsonKey(name: 'messageID')
  final String messageId;
  @override
  @JsonKey(name: 'chatRoomID')
  final String chatRoomId;
  @override
  @JsonKey(name: 'contactID')
  final String contactId;
  @override
  @JsonKey(name: 'ticketID')
  final String? ticketId;
  @override
  final String? sender;
  @override
  @JsonKey(name: 'replyMessageID')
  final String? replyMessageId;
  @override
  @JsonKey()
  final int messageOrder;
  @override
  @JsonKey()
  final String messageType;
  @override
  @JsonKey(name: 'channelID')
  final String? channelId;
  @override
  @JsonKey(name: 'zaloCliMsgID')
  final String? zaloCliMsgId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final ContactInfoDto contactInfo;
  final Map<String, dynamic> _contentInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get contentInfo {
    if (_contentInfo is EqualUnmodifiableMapView) return _contentInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contentInfo);
  }

  final Map<String, dynamic> _ticketInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get ticketInfo {
    if (_ticketInfo is EqualUnmodifiableMapView) return _ticketInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ticketInfo);
  }

  final List<FileAttachmentDto> _files;
  @override
  @JsonKey()
  List<FileAttachmentDto> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  final List<MessageReactionDto> _reaction;
  @override
  @JsonKey()
  List<MessageReactionDto> get reaction {
    if (_reaction is EqualUnmodifiableListView) return _reaction;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reaction);
  }

  final Map<String, dynamic> _replyMessage;
  @override
  @JsonKey()
  Map<String, dynamic> get replyMessage {
    if (_replyMessage is EqualUnmodifiableMapView) return _replyMessage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_replyMessage);
  }

  final Map<String, dynamic> _slackMessage;
  @override
  @JsonKey()
  Map<String, dynamic> get slackMessage {
    if (_slackMessage is EqualUnmodifiableMapView) return _slackMessage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_slackMessage);
  }

  final Map<String, dynamic> _zohoDeskMessage;
  @override
  @JsonKey()
  Map<String, dynamic> get zohoDeskMessage {
    if (_zohoDeskMessage is EqualUnmodifiableMapView) return _zohoDeskMessage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_zohoDeskMessage);
  }

  @override
  String toString() {
    return 'MessageDto(messageId: $messageId, chatRoomId: $chatRoomId, contactId: $contactId, ticketId: $ticketId, sender: $sender, replyMessageId: $replyMessageId, messageOrder: $messageOrder, messageType: $messageType, channelId: $channelId, zaloCliMsgId: $zaloCliMsgId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, contactInfo: $contactInfo, contentInfo: $contentInfo, ticketInfo: $ticketInfo, files: $files, reaction: $reaction, replyMessage: $replyMessage, slackMessage: $slackMessage, zohoDeskMessage: $zohoDeskMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDtoImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.replyMessageId, replyMessageId) ||
                other.replyMessageId == replyMessageId) &&
            (identical(other.messageOrder, messageOrder) ||
                other.messageOrder == messageOrder) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.zaloCliMsgId, zaloCliMsgId) ||
                other.zaloCliMsgId == zaloCliMsgId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.contactInfo, contactInfo) ||
                other.contactInfo == contactInfo) &&
            const DeepCollectionEquality().equals(
              other._contentInfo,
              _contentInfo,
            ) &&
            const DeepCollectionEquality().equals(
              other._ticketInfo,
              _ticketInfo,
            ) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            const DeepCollectionEquality().equals(other._reaction, _reaction) &&
            const DeepCollectionEquality().equals(
              other._replyMessage,
              _replyMessage,
            ) &&
            const DeepCollectionEquality().equals(
              other._slackMessage,
              _slackMessage,
            ) &&
            const DeepCollectionEquality().equals(
              other._zohoDeskMessage,
              _zohoDeskMessage,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    messageId,
    chatRoomId,
    contactId,
    ticketId,
    sender,
    replyMessageId,
    messageOrder,
    messageType,
    channelId,
    zaloCliMsgId,
    createdAt,
    updatedAt,
    deletedAt,
    contactInfo,
    const DeepCollectionEquality().hash(_contentInfo),
    const DeepCollectionEquality().hash(_ticketInfo),
    const DeepCollectionEquality().hash(_files),
    const DeepCollectionEquality().hash(_reaction),
    const DeepCollectionEquality().hash(_replyMessage),
    const DeepCollectionEquality().hash(_slackMessage),
    const DeepCollectionEquality().hash(_zohoDeskMessage),
  ]);

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith =>
      __$$MessageDtoImplCopyWithImpl<_$MessageDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageDtoImplToJson(this);
  }
}

abstract class _MessageDto implements MessageDto {
  const factory _MessageDto({
    @JsonKey(name: 'messageID') final String messageId,
    @JsonKey(name: 'chatRoomID') final String chatRoomId,
    @JsonKey(name: 'contactID') final String contactId,
    @JsonKey(name: 'ticketID') final String? ticketId,
    final String? sender,
    @JsonKey(name: 'replyMessageID') final String? replyMessageId,
    final int messageOrder,
    final String messageType,
    @JsonKey(name: 'channelID') final String? channelId,
    @JsonKey(name: 'zaloCliMsgID') final String? zaloCliMsgId,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
    required final ContactInfoDto contactInfo,
    final Map<String, dynamic> contentInfo,
    final Map<String, dynamic> ticketInfo,
    final List<FileAttachmentDto> files,
    final List<MessageReactionDto> reaction,
    final Map<String, dynamic> replyMessage,
    final Map<String, dynamic> slackMessage,
    final Map<String, dynamic> zohoDeskMessage,
  }) = _$MessageDtoImpl;

  factory _MessageDto.fromJson(Map<String, dynamic> json) =
      _$MessageDtoImpl.fromJson;

  @override
  @JsonKey(name: 'messageID')
  String get messageId;
  @override
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId;
  @override
  @JsonKey(name: 'contactID')
  String get contactId;
  @override
  @JsonKey(name: 'ticketID')
  String? get ticketId;
  @override
  String? get sender;
  @override
  @JsonKey(name: 'replyMessageID')
  String? get replyMessageId;
  @override
  int get messageOrder;
  @override
  String get messageType;
  @override
  @JsonKey(name: 'channelID')
  String? get channelId;
  @override
  @JsonKey(name: 'zaloCliMsgID')
  String? get zaloCliMsgId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  ContactInfoDto get contactInfo;
  @override
  Map<String, dynamic> get contentInfo;
  @override
  Map<String, dynamic> get ticketInfo;
  @override
  List<FileAttachmentDto> get files;
  @override
  List<MessageReactionDto> get reaction;
  @override
  Map<String, dynamic> get replyMessage;
  @override
  Map<String, dynamic> get slackMessage;
  @override
  Map<String, dynamic> get zohoDeskMessage;

  /// Create a copy of MessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
