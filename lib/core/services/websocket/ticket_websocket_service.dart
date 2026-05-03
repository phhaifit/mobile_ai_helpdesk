import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:ai_helpdesk/data/models/ticket/comment_api_model.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';

/// Manages a single WebSocket connection for real-time ticket comment updates.
///
/// Usage:
/// ```dart
/// await wsService.connect(ticketId);
/// wsService.commentStream.listen((comment) { ... });
/// // ...
/// await wsService.disconnect();
/// ```
///
/// The service is a singleton; calling [connect] with a different [ticketId]
/// automatically closes the previous connection first.
///
/// Expected server event format:
/// ```json
/// { "event": "new_comment", "data": { ...CommentApiModel fields... } }
/// ```
class TicketWebSocketService {
  final AsyncValueGetter<String?> _getToken;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _streamSub;
  String? _connectedTicketId;

  final _commentController = StreamController<Comment>.broadcast();

  TicketWebSocketService({required AsyncValueGetter<String?> getToken})
      : _getToken = getToken;

  /// Broadcasts [Comment] objects received from the server in real time.
  Stream<Comment> get commentStream => _commentController.stream;

  String? get connectedTicketId => _connectedTicketId;

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> connect(String ticketId) async {
    if (_connectedTicketId == ticketId && _channel != null) return;
    await disconnect();

    _connectedTicketId = ticketId;
    final token = await _getToken() ?? '';
    final uri = _buildUri(ticketId, token);

    try {
      _channel = WebSocketChannel.connect(uri);
      _streamSub = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      debugPrint('[TicketWS] connected to ticket $ticketId');
    } catch (e) {
      debugPrint('[TicketWS] connect error: $e');
      _connectedTicketId = null;
    }
  }

  Future<void> disconnect() async {
    await _streamSub?.cancel();
    await _channel?.sink.close();
    _streamSub = null;
    _channel = null;
    if (_connectedTicketId != null) {
      debugPrint('[TicketWS] disconnected from ticket $_connectedTicketId');
      _connectedTicketId = null;
    }
  }

  void dispose() {
    disconnect();
    _commentController.close();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  void _onMessage(dynamic raw) {
    try {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      final event = json['event'] as String?;
      if (event == 'new_comment') {
        final data = json['data'] as Map<String, dynamic>;
        final comment = CommentApiModel.fromJson(data).toDomain();
        _commentController.add(comment);
      }
    } catch (e) {
      debugPrint('[TicketWS] message parse error: $e');
    }
  }

  void _onError(Object error) {
    debugPrint('[TicketWS] stream error: $error');
  }

  void _onDone() {
    debugPrint('[TicketWS] connection closed for ticket $_connectedTicketId');
  }

  /// Builds the WebSocket URI, appending the auth token as a query parameter
  /// because the WebSocket protocol does not support custom headers on all
  /// platforms.
  Uri _buildUri(String ticketId, String token) {
    final url = Endpoints.ticketWebSocket(ticketId);
    final uri = Uri.parse(url);
    if (token.isEmpty) return uri;
    return uri.replace(queryParameters: {'token': token});
  }
}
