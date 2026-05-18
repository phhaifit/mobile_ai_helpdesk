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
    required this.createdAt, this.authorAvatar,
    this.updatedAt,
  });

  /// Parses the BE comment shape. Field names are normalised across:
  ///   - `commentID` / `id`            — comment id
  ///   - `ticketID` / `ticketId`       — owning ticket id
  ///   - `body`     / `content`        — comment text
  ///   - `customerSupportID` / `authorId` — author id
  ///   - `customerSupport.fullname`    — author display name (top-level
  ///     `fullname` is usually `null` on freshly-created comments)
  ///   - `customerSupport.profilePicture` / `profilePicture` — avatar URL
  factory CommentApiModel.fromJson(Map<String, dynamic> json) {
    // Ticket-comment shape (BE-canonical, hot-fix path).
    final cs = json['customerSupport'];
    final csMap = cs is Map<String, dynamic>
        ? cs
        : (cs is Map ? Map<String, dynamic>.from(cs) : null);

    // Chat-room message shape (kept as a fallback so CommentApiModel still
    // parses SOCKET_MESSAGE / `/api/chat-room/message` payloads cleanly).
    final sender = json['sender'] as Map<String, dynamic>?;
    final contentInfo = json['contentInfo'] as Map<String, dynamic>?;

    return CommentApiModel(
      id: (json['commentID'] ??
              json['messageID'] ??
              json['id']) as String? ??
          '',
      ticketId: (json['ticketID'] ??
              json['chatRoomID'] ??
              json['ticketId']) as String? ??
          '',
      content: (json['body'] ??
              contentInfo?['content'] ??
              json['content']) as String? ??
          '',
      authorId: (json['customerSupportID'] ??
              sender?['id'] ??
              json['authorId']) as String? ??
          '',
      authorName: (csMap?['fullname'] ??
              sender?['name'] ??
              json['fullname'] ??
              json['authorName']) as String? ??
          'Unknown',
      authorAvatar: (csMap?['profilePicture'] ??
              sender?['avatar'] ??
              json['profilePicture'] ??
              json['authorAvatar']) as String?,
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
