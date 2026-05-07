import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

/// Maps Comment JSON to the domain [Comment] entity.
///
/// Supports two payload shapes:
///   * Ticket-comment endpoint (GET /api/ticket/comment/get-comment/{id}):
///     flat `{ id, ticketId, content, authorId, authorName, ... }`.
///   * Chat-room message (REST /api/chat-room/message + Socket.io
///     SOCKET_MESSAGE): `{ messageID, chatRoomID, contentInfo: { content },
///     sender: { id, name, avatar }, ... }`.
class CommentApiModel {
  final String id;

  /// In ticket-comment shape this is the ticketId; in chat-room shape this
  /// is the chatRoomID — both are surfaced as `ticketId` on the domain entity
  /// so the UI can key comments to whatever scope is active.
  final String ticketId;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CommentApiModel({
    required this.id,
    required this.ticketId,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
    this.updatedAt,
  });

  factory CommentApiModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?;
    final contentInfo = json['contentInfo'] as Map<String, dynamic>?;
    final content = contentInfo?['content'] as String? ??
        json['content'] as String? ??
        '';

    return CommentApiModel(
      id: json['messageID'] as String? ?? json['id'] as String? ?? '',
      ticketId: json['chatRoomID'] as String? ??
          json['ticketId'] as String? ??
          '',
      content: content,
      authorId: sender?['id'] as String? ?? json['authorId'] as String? ?? '',
      authorName: sender?['name'] as String? ??
          json['authorName'] as String? ??
          'Unknown',
      authorAvatar:
          sender?['avatar'] as String? ?? json['authorAvatar'] as String?,
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  Comment toDomain() {
    return Comment(
      id: id,
      ticketId: ticketId,
      authorId: authorId,
      authorName: authorName,
      authorAvatar: authorAvatar,
      content: content,
      type: CommentType.public,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return null;
    }
  }
}
