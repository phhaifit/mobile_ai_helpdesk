import 'dart:async';
import 'dart:developer' as developer;

import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart'
    show Message;
import 'package:ai_helpdesk/domain/entity/chat/user.dart' show User;
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/events/socket/client/authenticate_socket_connection_event.dart';
import '../../../core/events/socket/client/send_typing_indicator_event.dart';
import '../../../core/events/socket/client/stop_typing_indicator_event.dart';
import '../../../core/events/socket/server/ai/socket_draft_response_progress_event.dart';
import '../../../core/events/socket/server/interactions/agent_stopped_typing_event.dart';
import '../../../core/events/socket/server/interactions/agent_typing_indicator_event.dart';
import '../../../core/events/socket/server/interactions/chat_room_marked_as_seen_event.dart';
import '../../../core/events/socket/server/interactions/customer_stopped_typing_event.dart';
import '../../../core/events/socket/server/interactions/customer_typing_indicator_event.dart';
import '../../../core/events/socket/server/interactions/message_reaction_update_event.dart';
import '../../../core/events/socket/server/interactions/socket_typing_payload.dart';
import '../../../core/events/socket/server/messages/email_message_event.dart';
import '../../../core/events/socket/server/messages/facebook_messenger_message_event.dart';
import '../../../core/events/socket/server/messages/generic_new_message_event.dart';
import '../../../core/events/socket/server/messages/lazada_message_event.dart';
import '../../../core/events/socket/server/messages/lazada_recalled_message_event.dart';
import '../../../core/events/socket/server/messages/phone_sms_message_event.dart';
import '../../../core/events/socket/server/messages/socket_message_payload.dart';
import '../../../core/events/socket/server/messages/web_chat_message_event.dart';
import '../../../core/events/socket/server/messages/zalo_message_event.dart';
import '../../../core/events/socket/server/messages/zendesk_message_event.dart';
import '../../../core/events/socket/server/messages/zohodesk_message_event.dart';
import '../../../core/events/socket/server/tickets/socket_escalation_alert_event.dart';
import '../../../core/events/socket/server/messages/socket_inapp_notification_event.dart';
import '../../../core/events/socket/server/tickets/socket_new_ticket_created_event.dart';
import '../../../core/events/socket/server/tickets/socket_ticket_status_changed_event.dart';

class SocketService {
  static const String _logName = 'SocketService';

  final SharedPreferenceHelper _prefs;

  io.Socket? _socket;
  String? _tenantId;

  final _messageController = StreamController<Message>.broadcast();
  final _typingController = StreamController<SocketTypingPayload>.broadcast();
  final _stopTypingController = StreamController<SocketTypingPayload>.broadcast();
  final _customerTypingController = StreamController<String>.broadcast();
  final _customerStopTypingController = StreamController<String>.broadcast();
  final _seenController =
      StreamController<ChatRoomMarkedAsSeenEvent>.broadcast();
  final _reactionController =
      StreamController<MessageReactionUpdateEvent>.broadcast();
  final _ticketStatusController =
      StreamController<SocketTicketStatusChangedEvent>.broadcast();
  final _newTicketController =
      StreamController<SocketNewTicketCreatedEvent>.broadcast();
  final _notificationController =
      StreamController<SocketInAppNotificationEvent>.broadcast();
  final _escalationController =
      StreamController<SocketEscalationAlertEvent>.broadcast();
  final _draftProgressController =
      StreamController<SocketDraftResponseProgressEvent>.broadcast();
  final _lazadaRecalledController =
      StreamController<LazadaRecalledMessageEvent>.broadcast();

  SocketService(this._prefs);

  Stream<Message> get messages => _messageController.stream;
  Stream<SocketTypingPayload> get typing => _typingController.stream;
  Stream<SocketTypingPayload> get stopTyping => _stopTypingController.stream;
  Stream<String> get customerTyping => _customerTypingController.stream;
  Stream<String> get customerStopTyping => _customerStopTypingController.stream;
  Stream<ChatRoomMarkedAsSeenEvent> get seen => _seenController.stream;
  Stream<MessageReactionUpdateEvent> get reactions => _reactionController.stream;
  Stream<SocketTicketStatusChangedEvent> get ticketStatus =>
      _ticketStatusController.stream;
  Stream<SocketNewTicketCreatedEvent> get newTickets =>
      _newTicketController.stream;
  Stream<SocketInAppNotificationEvent> get notifications =>
      _notificationController.stream;
  Stream<SocketEscalationAlertEvent> get escalations =>
      _escalationController.stream;
  Stream<SocketDraftResponseProgressEvent> get draftProgress =>
      _draftProgressController.stream;
  Stream<LazadaRecalledMessageEvent> get lazadaRecalled =>
      _lazadaRecalledController.stream;

  bool get isConnected => _socket?.connected ?? false;
  String? get socketId => _socket?.id;

  Future<void> connect({
    required String tenantId,
  }) async {
    developer.log('connect requested tenantId=$tenantId', name: _logName);
    await disconnect();

    _tenantId = tenantId;

    final token = await _prefs.authToken;
    if (token == null || token.isEmpty) {
      throw StateError('Missing auth token for socket connection');
    }

    final namespace = '/tenant-$tenantId';
    final socket = io.io(
      'wss://helpdesk-api.jarvis.cx$namespace',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/api/socket')
          .disableAutoConnect()
          .enableForceNew()
          .build(),
    );

    Completer<void> completer = Completer<void>();

    socket.onDisconnect((dynamic reason) {
      unawaited(_prefs.removeSocketId());
      developer.log(
        'onDisconnect tenantId=$tenantId socketId=${socket.id} reason=$reason',
        name: _logName,
      );
    });

    socket.onConnectError((dynamic err) {
      developer.log(
        'onConnectError tenantId=$tenantId err=$err',
        name: _logName,
        error: err is Error ? err : null,
      );
    });

    Future<void> onAnyMessage(dynamic payload) async {
      final p = _parseMessagePayload(payload);
      if (p == null) return;

      final message = await _mapSocketMessagePayload(p);
      _messageController.add(message);
    }

    socket.on(GenericNewMessageEvent.name, onAnyMessage);
    socket.on(FacebookMessengerMessageEvent.name, onAnyMessage);
    socket.on(ZaloMessageEvent.name, onAnyMessage);
    socket.on(EmailMessageEvent.name, onAnyMessage);
    socket.on(PhoneSmsMessageEvent.name, onAnyMessage);
    socket.on(WebChatMessageEvent.name, onAnyMessage);
    socket.on(LazadaMessageEvent.name, onAnyMessage);
    socket.on(ZendeskMessageEvent.name, onAnyMessage);
    socket.on(ZohoDeskMessageEvent.name, onAnyMessage);

    socket.on(AgentTypingIndicatorEvent.name, (payload) {
      final SocketTypingPayload? e = AgentTypingIndicatorEvent.parse(payload);
      if (e != null) _typingController.add(e);
    });

    socket.on(AgentStoppedTypingEvent.name, (payload) {
      final SocketTypingPayload? e = AgentStoppedTypingEvent.parse(payload);
      if (e != null) _stopTypingController.add(e);
    });

    socket.on(CustomerTypingIndicatorEvent.name, (payload) {
      final e = CustomerTypingIndicatorEvent.parse(payload);
      if (e != null) _customerTypingController.add(e.chatRoomId);
    });

    socket.on(CustomerStoppedTypingEvent.name, (payload) {
      final e = CustomerStoppedTypingEvent.parse(payload);
      if (e != null) _customerStopTypingController.add(e.chatRoomId);
    });

    socket.on(ChatRoomMarkedAsSeenEvent.name, (payload) {
      final e = ChatRoomMarkedAsSeenEvent.parse(payload);
      if (e != null) _seenController.add(e);
    });

    socket.on(MessageReactionUpdateEvent.name, (payload) {
      final e = MessageReactionUpdateEvent.parse(payload);
      if (e != null) _reactionController.add(e);
    });

    socket.on(SocketTicketStatusChangedEvent.name, (payload) {
      final e = SocketTicketStatusChangedEvent.parse(payload);
      if (e != null) _ticketStatusController.add(e);
    });

    socket.on(SocketNewTicketCreatedEvent.name, (payload) {
      final e = SocketNewTicketCreatedEvent.parse(payload);
      if (e != null) _newTicketController.add(e);
    });

    socket.on(SocketInAppNotificationEvent.name, (payload) {
      final e = SocketInAppNotificationEvent.parse(payload);
      if (e != null) _notificationController.add(e);
    });

    socket.on(SocketEscalationAlertEvent.name, (payload) {
      final e = SocketEscalationAlertEvent.parse(payload);
      if (e != null) _escalationController.add(e);
    });

    socket.on(SocketDraftResponseProgressEvent.name, (payload) {
      final e = SocketDraftResponseProgressEvent.parse(payload);
      if (e != null) _draftProgressController.add(e);
    });

    socket.on(LazadaRecalledMessageEvent.name, (payload) {
      final e = LazadaRecalledMessageEvent.parse(payload);
      if (e != null) _lazadaRecalledController.add(e);
    });

    socket.onAny((event, data) {
      developer.log(
        'onAnyEvent: EVENT=[$event]\nDATA=$data',
        name: _logName,
      );
    });

    socket.on(AuthenticateSocketConnectionEvent.name, (dynamic payload) {
      developer.log(
        'received ${AuthenticateSocketConnectionEvent.name} '
        'tenantId=$tenantId payload=$payload',
        name: _logName,
      );
    });

    socket.onConnect((_) {
      final String? connectedId = socket.id;
      if (connectedId != null && connectedId.isNotEmpty) {
        unawaited(_prefs.saveSocketId(connectedId));
      }
      developer.log(
        'CONNECTED tenantId=$tenantId nsp=${socket.nsp} id=${socket.id}',
        name: _logName,
      );

      final auth = AuthenticateSocketConnectionEvent(token: token);
      socket.emit(AuthenticateSocketConnectionEvent.name, auth.toJson());

      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _socket = socket;

    socket.connect();

    await completer.future;
  }

  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
    _tenantId = null;
    await _prefs.removeSocketId();
  }

  void emitTyping({
    required String chatRoomId,
    String? customerSupportId,
    String? fullname,
    String? profilePicture,
  }) {
    final SendTypingIndicatorEvent e = SendTypingIndicatorEvent(
      chatRoomId: chatRoomId,
      customerSupportId: customerSupportId,
      fullname: fullname,
      profilePicture: profilePicture,
    );
    _socket?.emit(SendTypingIndicatorEvent.name, e.toJson());
  }

  void emitStopTyping({
    required String chatRoomId,
    String? customerSupportId,
  }) {
    final StopTypingIndicatorEvent e = StopTypingIndicatorEvent(
      chatRoomId: chatRoomId,
      customerSupportId: customerSupportId,
    );
    _socket?.emit(StopTypingIndicatorEvent.name, e.toJson());
  }

  SocketMessagePayload? _parseMessagePayload(dynamic payload) {
    return GenericNewMessageEvent.parse(payload) ??
        FacebookMessengerMessageEvent.parse(payload) ??
        ZaloMessageEvent.parse(payload) ??
        EmailMessageEvent.parse(payload) ??
        PhoneSmsMessageEvent.parse(payload) ??
        WebChatMessageEvent.parse(payload) ??
        LazadaMessageEvent.parse(payload) ??
        ZendeskMessageEvent.parse(payload) ??
        ZohoDeskMessageEvent.parse(payload);
  }

  Future<Message> _mapSocketMessagePayload(SocketMessagePayload p) async {
    final tenantId = await _prefs.tenantId;
    final isMe = p.sender != null && p.sender == tenantId;

    return Message(
      id: p.messageId,
      order: p.order,
      conversationId: p.chatRoomId,
      sender: User(id: p.sender ?? '', name: p.sender ?? '', avatar: ''),
      content: p.displayContent,
      timestamp: p.createdAt ?? DateTime.now(),
      isMe: isMe,
      attachments: const [],
      replyPreview: null,
      reactions: const [],
    );
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _typingController.close();
    _stopTypingController.close();
    _customerTypingController.close();
    _customerStopTypingController.close();
    _seenController.close();
    _reactionController.close();
    _ticketStatusController.close();
    _newTicketController.close();
    _notificationController.close();
    _escalationController.close();
    _draftProgressController.close();
    _lazadaRecalledController.close();
  }
}

