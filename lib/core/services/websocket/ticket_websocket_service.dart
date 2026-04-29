import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;

import 'package:ai_helpdesk/data/models/ticket/comment_api_model.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';

/// Manages a Socket.io connection for real-time chat-room message updates.
///
/// Connects to the /tenant-{tenantId} namespace at the helpdesk socket
/// endpoint. After connecting, emits SOCKET_AUTHENTICATE within 2 seconds.
/// Listens for SOCKET_MESSAGE events and filters to the subscribed chatRoomId.
///
/// Usage:
/// ```dart
/// await wsService.connect(chatRoomId);
/// wsService.commentStream.listen((comment) { ... });
/// await wsService.disconnect();
/// ```
class TicketWebSocketService {
  final AsyncValueGetter<String?> _getToken;
  final AsyncValueGetter<String?> _getTenantId;

  sio.Socket? _socket;
  String? _connectedChatRoomId;

  final _messageController = StreamController<Comment>.broadcast();

  TicketWebSocketService({
    required AsyncValueGetter<String?> getToken,
    required AsyncValueGetter<String?> getTenantId,
  })  : _getToken = getToken,
        _getTenantId = getTenantId;

  /// Broadcasts [Comment] objects received in real time for the connected room.
  Stream<Comment> get commentStream => _messageController.stream;

  String? get connectedChatRoomId => _connectedChatRoomId;

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> connect(String chatRoomId) async {
    if (_connectedChatRoomId == chatRoomId && (_socket?.connected ?? false)) return;
    await disconnect();

    final tenantId = await _getTenantId() ?? '';
    if (tenantId.isEmpty) {
      debugPrint('[TicketWS] no tenantId — skipping socket connection');
      return;
    }

    _connectedChatRoomId = chatRoomId;
    final namespace = Endpoints.socketNamespace(tenantId);
    final url = '${Endpoints.socketUrl}$namespace';

    _socket = sio.io(
      url,
      sio.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setPath(Endpoints.socketPath)
          .build(),
    );

    _socket!.onConnect((_) async {
      debugPrint('[TicketWS] connected — namespace $namespace');
      final token = await _getToken() ?? '';
      _socket!.emit('SOCKET_AUTHENTICATE', {'token': token});
    });

    _socket!.on('SOCKET_AUTHENTICATE', (data) {
      debugPrint('[TicketWS] authenticated: $data');
    });

    _socket!.on('SOCKET_MESSAGE', _onSocketMessage);

    _socket!.onDisconnect((_) {
      debugPrint('[TicketWS] disconnected from $namespace');
    });

    _socket!.onError((error) {
      debugPrint('[TicketWS] error: $error');
    });

    _socket!.connect();
  }

  Future<void> disconnect() async {
    _socket?.off('SOCKET_MESSAGE');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    if (_connectedChatRoomId != null) {
      debugPrint('[TicketWS] disconnected from room $_connectedChatRoomId');
      _connectedChatRoomId = null;
    }
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  void _onSocketMessage(dynamic raw) {
    try {
      final json = raw is Map ? Map<String, dynamic>.from(raw) : null;
      if (json == null) return;

      // Only emit messages for the currently connected chat room.
      final chatRoomId = json['chatRoomID'] as String?;
      if (chatRoomId != _connectedChatRoomId) return;

      final comment = CommentApiModel.fromJson(json).toDomain();
      _messageController.add(comment);
    } catch (e) {
      debugPrint('[TicketWS] message parse error: $e');
    }
  }
}
