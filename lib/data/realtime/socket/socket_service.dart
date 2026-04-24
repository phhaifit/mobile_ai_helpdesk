import 'dart:async';

import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  final SharedPreferenceHelper _prefs;

  io.Socket? _socket;
  String? _tenantId;

  final _messageController = StreamController<Message>.broadcast();
  final _typingController = StreamController<String>.broadcast(); // chatRoomId
  final _stopTypingController = StreamController<String>.broadcast();
  final _seenController = StreamController<SocketSeenEvent>.broadcast();
  final _reactionController = StreamController<SocketReactionEvent>.broadcast();
  final _ticketStatusController =
      StreamController<SocketTicketStatusEvent>.broadcast();
  final _notificationController =
      StreamController<SocketNotificationEvent>.broadcast();
  final _draftProgressController =
      StreamController<SocketDraftProgressEvent>.broadcast();

  SocketService(this._prefs);

  Stream<Message> get messages => _messageController.stream;
  Stream<String> get typing => _typingController.stream;
  Stream<String> get stopTyping => _stopTypingController.stream;
  Stream<SocketSeenEvent> get seen => _seenController.stream;
  Stream<SocketReactionEvent> get reactions => _reactionController.stream;
  Stream<SocketTicketStatusEvent> get ticketStatus => _ticketStatusController.stream;
  Stream<SocketNotificationEvent> get notifications =>
      _notificationController.stream;
  Stream<SocketDraftProgressEvent> get draftProgress =>
      _draftProgressController.stream;

  bool get isConnected => _socket?.connected == true;

  Future<void> connect({
    required String tenantId,
  }) async {
    // Avoid reconnect loops if already connected to same tenant.
    if (_socket != null && _tenantId == tenantId) {
      if (_socket!.connected) return;
    } else {
      await disconnect();
    }

    _tenantId = tenantId;

    final token = await _prefs.authToken;
    if (token == null || token.isEmpty) {
      throw StateError('Missing auth token for socket connection');
    }

    final namespace = '/tenant-$tenantId';
    _socket = io.io(
      'https://helpdesk-api.jarvis.cx$namespace',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setPath('/api/socket')
          .enableForceNew()
          .build(),
    );

    _socket!.onConnect((_) {
      _socket!.emit('SOCKET_AUTHENTICATE', {'token': token});
    });

    _socket!.on('SOCKET_MESSAGE', (payload) async {
      final message = await _mapSocketMessage(payload);
      if (message != null) {
        _messageController.add(message);
      }
    });

    _socket!.on('SOCKET_TYPING', (payload) {
      final chatRoomId = _chatRoomIdFromPayload(payload);
      if (chatRoomId != null) _typingController.add(chatRoomId);
    });

    _socket!.on('SOCKET_STOP_TYPING', (payload) {
      final chatRoomId = _chatRoomIdFromPayload(payload);
      if (chatRoomId != null) _stopTypingController.add(chatRoomId);
    });

    _socket!.on('SOCKET_SEEN_CHAT_ROOM', (payload) {
      final e = SocketSeenEvent.fromPayload(payload);
      if (e != null) _seenController.add(e);
    });

    _socket!.on('SOCKET_REACT_MESSAGE', (payload) {
      final e = SocketReactionEvent.fromPayload(payload);
      if (e != null) _reactionController.add(e);
    });

    _socket!.on('SOCKET_CHANGE_TICKET_STATUS', (payload) {
      final e = SocketTicketStatusEvent.fromPayload(payload);
      if (e != null) _ticketStatusController.add(e);
    });

    _socket!.on('SOCKET_NOTI', (payload) {
      final e = SocketNotificationEvent.fromPayload(payload);
      if (e != null) _notificationController.add(e);
    });

    _socket!.on('SOCKET_DRAFT_RESPONSE_PROGRESS', (payload) {
      final e = SocketDraftProgressEvent.fromPayload(payload);
      if (e != null) _draftProgressController.add(e);
    });

    _socket!.connect();
  }

  Future<void> disconnect() async {
    _socket?.dispose();
    _socket = null;
    _tenantId = null;
  }

  void emitTyping(String chatRoomId) {
    _socket?.emit('SOCKET_TYPING', {'chatRoomID': chatRoomId});
  }

  void emitStopTyping(String chatRoomId) {
    _socket?.emit('SOCKET_STOP_TYPING', {'chatRoomID': chatRoomId});
  }

  String? _chatRoomIdFromPayload(dynamic payload) {
    if (payload is Map) {
      final m = payload.cast<String, dynamic>();
      final id = m['chatRoomID']?.toString();
      if (id != null && id.isNotEmpty) return id;
    }
    return null;
  }

  Future<Message?> _mapSocketMessage(dynamic payload) async {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();

    final messageId = m['messageID']?.toString() ?? '';
    final chatRoomId = m['chatRoomID']?.toString() ?? '';
    if (messageId.isEmpty || chatRoomId.isEmpty) return null;

    final tokenUser = await _prefs.getUser();
    final myId = tokenUser?.id;
    final sender = m['sender']?.toString();
    final isMe = myId != null && sender != null && sender == myId;

    final content = (m['content'] is String && (m['content'] as String).isNotEmpty)
        ? (m['content'] as String)
        : (m['contentInfo'] is Map &&
                (m['contentInfo'] as Map).cast<String, dynamic>()['content']
                    is String)
            ? (m['contentInfo'] as Map).cast<String, dynamic>()['content'] as String
            : '';

    final createdAt = m['createdAt'] is String
        ? DateTime.tryParse(m['createdAt'] as String)
        : null;

    return Message(
      id: messageId,
      chatRoomId: chatRoomId,
      content: content,
      timestamp: createdAt ?? DateTime.now(),
      isMe: isMe,
      senderName: isMe ? 'You' : (sender == null ? 'Customer' : 'Agent'),
      isPending: false,
      readStatus: MessageReadStatus.delivered,
    );
  }
}

class SocketSeenEvent {
  final String chatRoomId;
  final String messageId;
  final int messageOrder;
  final String? customerSupportId;

  SocketSeenEvent({
    required this.chatRoomId,
    required this.messageId,
    required this.messageOrder,
    required this.customerSupportId,
  });

  static SocketSeenEvent? fromPayload(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final chatRoomId = m['chatRoomID']?.toString() ?? '';
    final messageId = m['messageID']?.toString() ?? '';
    final order = m['messageOrder'];
    if (chatRoomId.isEmpty || messageId.isEmpty || order is! num) return null;
    return SocketSeenEvent(
      chatRoomId: chatRoomId,
      messageId: messageId,
      messageOrder: order.toInt(),
      customerSupportId: m['customerSupportID']?.toString(),
    );
  }
}

class SocketReactionEvent {
  final String chatRoomId;
  final String messageId;
  final String emoji;
  final int amount;
  final String? messageReactionId;
  final String? customerSupportId;
  final String? customerId;

  SocketReactionEvent({
    required this.chatRoomId,
    required this.messageId,
    required this.emoji,
    required this.amount,
    required this.messageReactionId,
    required this.customerSupportId,
    required this.customerId,
  });

  static SocketReactionEvent? fromPayload(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final chatRoomId = m['chatRoomID']?.toString() ?? '';
    final messageId = m['messageID']?.toString() ?? '';
    final emoji = m['emoji']?.toString() ?? '';
    final amount = m['amount'];
    if (chatRoomId.isEmpty || messageId.isEmpty || emoji.isEmpty || amount is! num) {
      return null;
    }
    return SocketReactionEvent(
      chatRoomId: chatRoomId,
      messageId: messageId,
      emoji: emoji,
      amount: amount.toInt(),
      messageReactionId: m['messageReactionID']?.toString(),
      customerSupportId: m['customerSupportID']?.toString(),
      customerId: m['customerID']?.toString(),
    );
  }
}

class SocketTicketStatusEvent {
  final String chatRoomId;
  final String ticketId;
  final String status;

  SocketTicketStatusEvent({
    required this.chatRoomId,
    required this.ticketId,
    required this.status,
  });

  static SocketTicketStatusEvent? fromPayload(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final chatRoomId = m['chatRoomID']?.toString() ?? '';
    final ticketId = m['ticketID']?.toString() ?? '';
    final status = m['status']?.toString() ?? '';
    if (chatRoomId.isEmpty || ticketId.isEmpty || status.isEmpty) return null;
    return SocketTicketStatusEvent(chatRoomId: chatRoomId, ticketId: ticketId, status: status);
  }
}

class SocketNotificationEvent {
  final String id;
  final String title;
  final String body;
  final DateTime? createdAt;

  SocketNotificationEvent({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  static SocketNotificationEvent? fromPayload(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final id = m['id']?.toString() ?? '';
    if (id.isEmpty) return null;
    return SocketNotificationEvent(
      id: id,
      title: m['title']?.toString() ?? '',
      body: m['body']?.toString() ?? '',
      createdAt: m['createdAt'] is String ? DateTime.tryParse(m['createdAt'] as String) : null,
    );
  }
}

class SocketDraftProgressEvent {
  final String taskId;
  final String step;
  final String status;
  final Map<String, dynamic>? result;

  SocketDraftProgressEvent({
    required this.taskId,
    required this.step,
    required this.status,
    required this.result,
  });

  static SocketDraftProgressEvent? fromPayload(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final taskId = m['taskId']?.toString() ?? '';
    final step = m['step']?.toString() ?? '';
    final status = m['status']?.toString() ?? '';
    if (taskId.isEmpty || step.isEmpty || status.isEmpty) return null;
    return SocketDraftProgressEvent(
      taskId: taskId,
      step: step,
      status: status,
      result: m['result'] is Map ? (m['result'] as Map).cast<String, dynamic>() : null,
    );
  }
}

