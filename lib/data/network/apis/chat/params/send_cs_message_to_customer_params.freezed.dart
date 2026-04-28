// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_cs_message_to_customer_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SendCsMessageToCustomerParams _$SendCsMessageToCustomerParamsFromJson(
  Map<String, dynamic> json,
) {
  return _SendCsMessageToCustomerParams.fromJson(json);
}

/// @nodoc
mixin _$SendCsMessageToCustomerParams {
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'contactID')
  String get contactId => throw _privateConstructorUsedError;
  @JsonKey(name: 'channelID')
  String get channelId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticketID', includeIfNull: false)
  String? get ticketId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'replyMessageID', includeIfNull: false)
  String? get replyMessageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'socketID', includeIfNull: false)
  String? get socketId => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  List<FileAttachmentDto>? get files => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get isAutoReply => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get messageTag => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  bool? get mentionReply => throw _privateConstructorUsedError;

  /// Serializes this SendCsMessageToCustomerParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendCsMessageToCustomerParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendCsMessageToCustomerParamsCopyWith<SendCsMessageToCustomerParams>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendCsMessageToCustomerParamsCopyWith<$Res> {
  factory $SendCsMessageToCustomerParamsCopyWith(
    SendCsMessageToCustomerParams value,
    $Res Function(SendCsMessageToCustomerParams) then,
  ) =
      _$SendCsMessageToCustomerParamsCopyWithImpl<
        $Res,
        SendCsMessageToCustomerParams
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'channelID') String channelId,
    @JsonKey(includeIfNull: false) String? groupId,
    @JsonKey(name: 'ticketID', includeIfNull: false) String? ticketId,
    @JsonKey(includeIfNull: false) String? content,
    @JsonKey(includeIfNull: false) String? title,
    @JsonKey(name: 'replyMessageID', includeIfNull: false)
    String? replyMessageId,
    @JsonKey(name: 'socketID', includeIfNull: false) String? socketId,
    @JsonKey(includeIfNull: false) List<FileAttachmentDto>? files,
    @JsonKey(includeIfNull: false) bool? isAutoReply,
    @JsonKey(includeIfNull: false) String? messageTag,
    @JsonKey(includeIfNull: false) bool? mentionReply,
  });
}

/// @nodoc
class _$SendCsMessageToCustomerParamsCopyWithImpl<
  $Res,
  $Val extends SendCsMessageToCustomerParams
>
    implements $SendCsMessageToCustomerParamsCopyWith<$Res> {
  _$SendCsMessageToCustomerParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendCsMessageToCustomerParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatRoomId = null,
    Object? contactId = null,
    Object? channelId = null,
    Object? groupId = freezed,
    Object? ticketId = freezed,
    Object? content = freezed,
    Object? title = freezed,
    Object? replyMessageId = freezed,
    Object? socketId = freezed,
    Object? files = freezed,
    Object? isAutoReply = freezed,
    Object? messageTag = freezed,
    Object? mentionReply = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            channelId:
                null == channelId
                    ? _value.channelId
                    : channelId // ignore: cast_nullable_to_non_nullable
                        as String,
            groupId:
                freezed == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String?,
            ticketId:
                freezed == ticketId
                    ? _value.ticketId
                    : ticketId // ignore: cast_nullable_to_non_nullable
                        as String?,
            content:
                freezed == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String?,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            replyMessageId:
                freezed == replyMessageId
                    ? _value.replyMessageId
                    : replyMessageId // ignore: cast_nullable_to_non_nullable
                        as String?,
            socketId:
                freezed == socketId
                    ? _value.socketId
                    : socketId // ignore: cast_nullable_to_non_nullable
                        as String?,
            files:
                freezed == files
                    ? _value.files
                    : files // ignore: cast_nullable_to_non_nullable
                        as List<FileAttachmentDto>?,
            isAutoReply:
                freezed == isAutoReply
                    ? _value.isAutoReply
                    : isAutoReply // ignore: cast_nullable_to_non_nullable
                        as bool?,
            messageTag:
                freezed == messageTag
                    ? _value.messageTag
                    : messageTag // ignore: cast_nullable_to_non_nullable
                        as String?,
            mentionReply:
                freezed == mentionReply
                    ? _value.mentionReply
                    : mentionReply // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendCsMessageToCustomerParamsImplCopyWith<$Res>
    implements $SendCsMessageToCustomerParamsCopyWith<$Res> {
  factory _$$SendCsMessageToCustomerParamsImplCopyWith(
    _$SendCsMessageToCustomerParamsImpl value,
    $Res Function(_$SendCsMessageToCustomerParamsImpl) then,
  ) = __$$SendCsMessageToCustomerParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'chatRoomID') String chatRoomId,
    @JsonKey(name: 'contactID') String contactId,
    @JsonKey(name: 'channelID') String channelId,
    @JsonKey(includeIfNull: false) String? groupId,
    @JsonKey(name: 'ticketID', includeIfNull: false) String? ticketId,
    @JsonKey(includeIfNull: false) String? content,
    @JsonKey(includeIfNull: false) String? title,
    @JsonKey(name: 'replyMessageID', includeIfNull: false)
    String? replyMessageId,
    @JsonKey(name: 'socketID', includeIfNull: false) String? socketId,
    @JsonKey(includeIfNull: false) List<FileAttachmentDto>? files,
    @JsonKey(includeIfNull: false) bool? isAutoReply,
    @JsonKey(includeIfNull: false) String? messageTag,
    @JsonKey(includeIfNull: false) bool? mentionReply,
  });
}

/// @nodoc
class __$$SendCsMessageToCustomerParamsImplCopyWithImpl<$Res>
    extends
        _$SendCsMessageToCustomerParamsCopyWithImpl<
          $Res,
          _$SendCsMessageToCustomerParamsImpl
        >
    implements _$$SendCsMessageToCustomerParamsImplCopyWith<$Res> {
  __$$SendCsMessageToCustomerParamsImplCopyWithImpl(
    _$SendCsMessageToCustomerParamsImpl _value,
    $Res Function(_$SendCsMessageToCustomerParamsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendCsMessageToCustomerParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatRoomId = null,
    Object? contactId = null,
    Object? channelId = null,
    Object? groupId = freezed,
    Object? ticketId = freezed,
    Object? content = freezed,
    Object? title = freezed,
    Object? replyMessageId = freezed,
    Object? socketId = freezed,
    Object? files = freezed,
    Object? isAutoReply = freezed,
    Object? messageTag = freezed,
    Object? mentionReply = freezed,
  }) {
    return _then(
      _$SendCsMessageToCustomerParamsImpl(
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
        channelId:
            null == channelId
                ? _value.channelId
                : channelId // ignore: cast_nullable_to_non_nullable
                    as String,
        groupId:
            freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String?,
        ticketId:
            freezed == ticketId
                ? _value.ticketId
                : ticketId // ignore: cast_nullable_to_non_nullable
                    as String?,
        content:
            freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String?,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        replyMessageId:
            freezed == replyMessageId
                ? _value.replyMessageId
                : replyMessageId // ignore: cast_nullable_to_non_nullable
                    as String?,
        socketId:
            freezed == socketId
                ? _value.socketId
                : socketId // ignore: cast_nullable_to_non_nullable
                    as String?,
        files:
            freezed == files
                ? _value._files
                : files // ignore: cast_nullable_to_non_nullable
                    as List<FileAttachmentDto>?,
        isAutoReply:
            freezed == isAutoReply
                ? _value.isAutoReply
                : isAutoReply // ignore: cast_nullable_to_non_nullable
                    as bool?,
        messageTag:
            freezed == messageTag
                ? _value.messageTag
                : messageTag // ignore: cast_nullable_to_non_nullable
                    as String?,
        mentionReply:
            freezed == mentionReply
                ? _value.mentionReply
                : mentionReply // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SendCsMessageToCustomerParamsImpl
    implements _SendCsMessageToCustomerParams {
  const _$SendCsMessageToCustomerParamsImpl({
    @JsonKey(name: 'chatRoomID') required this.chatRoomId,
    @JsonKey(name: 'contactID') required this.contactId,
    @JsonKey(name: 'channelID') required this.channelId,
    @JsonKey(includeIfNull: false) this.groupId,
    @JsonKey(name: 'ticketID', includeIfNull: false) this.ticketId,
    @JsonKey(includeIfNull: false) this.content,
    @JsonKey(includeIfNull: false) this.title,
    @JsonKey(name: 'replyMessageID', includeIfNull: false) this.replyMessageId,
    @JsonKey(name: 'socketID', includeIfNull: false) this.socketId,
    @JsonKey(includeIfNull: false) final List<FileAttachmentDto>? files,
    @JsonKey(includeIfNull: false) this.isAutoReply,
    @JsonKey(includeIfNull: false) this.messageTag,
    @JsonKey(includeIfNull: false) this.mentionReply,
  }) : _files = files;

  factory _$SendCsMessageToCustomerParamsImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$SendCsMessageToCustomerParamsImplFromJson(json);

  @override
  @JsonKey(name: 'chatRoomID')
  final String chatRoomId;
  @override
  @JsonKey(name: 'contactID')
  final String contactId;
  @override
  @JsonKey(name: 'channelID')
  final String channelId;
  @override
  @JsonKey(includeIfNull: false)
  final String? groupId;
  @override
  @JsonKey(name: 'ticketID', includeIfNull: false)
  final String? ticketId;
  @override
  @JsonKey(includeIfNull: false)
  final String? content;
  @override
  @JsonKey(includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'replyMessageID', includeIfNull: false)
  final String? replyMessageId;
  @override
  @JsonKey(name: 'socketID', includeIfNull: false)
  final String? socketId;
  final List<FileAttachmentDto>? _files;
  @override
  @JsonKey(includeIfNull: false)
  List<FileAttachmentDto>? get files {
    final value = _files;
    if (value == null) return null;
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(includeIfNull: false)
  final bool? isAutoReply;
  @override
  @JsonKey(includeIfNull: false)
  final String? messageTag;
  @override
  @JsonKey(includeIfNull: false)
  final bool? mentionReply;

  @override
  String toString() {
    return 'SendCsMessageToCustomerParams(chatRoomId: $chatRoomId, contactId: $contactId, channelId: $channelId, groupId: $groupId, ticketId: $ticketId, content: $content, title: $title, replyMessageId: $replyMessageId, socketId: $socketId, files: $files, isAutoReply: $isAutoReply, messageTag: $messageTag, mentionReply: $mentionReply)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendCsMessageToCustomerParamsImpl &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.replyMessageId, replyMessageId) ||
                other.replyMessageId == replyMessageId) &&
            (identical(other.socketId, socketId) ||
                other.socketId == socketId) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.isAutoReply, isAutoReply) ||
                other.isAutoReply == isAutoReply) &&
            (identical(other.messageTag, messageTag) ||
                other.messageTag == messageTag) &&
            (identical(other.mentionReply, mentionReply) ||
                other.mentionReply == mentionReply));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chatRoomId,
    contactId,
    channelId,
    groupId,
    ticketId,
    content,
    title,
    replyMessageId,
    socketId,
    const DeepCollectionEquality().hash(_files),
    isAutoReply,
    messageTag,
    mentionReply,
  );

  /// Create a copy of SendCsMessageToCustomerParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendCsMessageToCustomerParamsImplCopyWith<
    _$SendCsMessageToCustomerParamsImpl
  >
  get copyWith => __$$SendCsMessageToCustomerParamsImplCopyWithImpl<
    _$SendCsMessageToCustomerParamsImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendCsMessageToCustomerParamsImplToJson(this);
  }
}

abstract class _SendCsMessageToCustomerParams
    implements SendCsMessageToCustomerParams {
  const factory _SendCsMessageToCustomerParams({
    @JsonKey(name: 'chatRoomID') required final String chatRoomId,
    @JsonKey(name: 'contactID') required final String contactId,
    @JsonKey(name: 'channelID') required final String channelId,
    @JsonKey(includeIfNull: false) final String? groupId,
    @JsonKey(name: 'ticketID', includeIfNull: false) final String? ticketId,
    @JsonKey(includeIfNull: false) final String? content,
    @JsonKey(includeIfNull: false) final String? title,
    @JsonKey(name: 'replyMessageID', includeIfNull: false)
    final String? replyMessageId,
    @JsonKey(name: 'socketID', includeIfNull: false) final String? socketId,
    @JsonKey(includeIfNull: false) final List<FileAttachmentDto>? files,
    @JsonKey(includeIfNull: false) final bool? isAutoReply,
    @JsonKey(includeIfNull: false) final String? messageTag,
    @JsonKey(includeIfNull: false) final bool? mentionReply,
  }) = _$SendCsMessageToCustomerParamsImpl;

  factory _SendCsMessageToCustomerParams.fromJson(Map<String, dynamic> json) =
      _$SendCsMessageToCustomerParamsImpl.fromJson;

  @override
  @JsonKey(name: 'chatRoomID')
  String get chatRoomId;
  @override
  @JsonKey(name: 'contactID')
  String get contactId;
  @override
  @JsonKey(name: 'channelID')
  String get channelId;
  @override
  @JsonKey(includeIfNull: false)
  String? get groupId;
  @override
  @JsonKey(name: 'ticketID', includeIfNull: false)
  String? get ticketId;
  @override
  @JsonKey(includeIfNull: false)
  String? get content;
  @override
  @JsonKey(includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'replyMessageID', includeIfNull: false)
  String? get replyMessageId;
  @override
  @JsonKey(name: 'socketID', includeIfNull: false)
  String? get socketId;
  @override
  @JsonKey(includeIfNull: false)
  List<FileAttachmentDto>? get files;
  @override
  @JsonKey(includeIfNull: false)
  bool? get isAutoReply;
  @override
  @JsonKey(includeIfNull: false)
  String? get messageTag;
  @override
  @JsonKey(includeIfNull: false)
  bool? get mentionReply;

  /// Create a copy of SendCsMessageToCustomerParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendCsMessageToCustomerParamsImplCopyWith<
    _$SendCsMessageToCustomerParamsImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
