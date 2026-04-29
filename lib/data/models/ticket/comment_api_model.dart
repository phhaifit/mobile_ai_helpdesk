import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

/// Maps the chat-room Message JSON response to the domain [Comment] entity.
///
/// Used for both REST responses (GET /api/chat-room/message) and
/// Socket.io SOCKET_MESSAGE event payloads.
class CommentApiModel {
  final String id;
  final String chatRoomId;
  final String content;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final DateTime createdAt;

  const CommentApiModel({
    required this.id,
    required this.chatRoomId,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
  });

  factory CommentApiModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?;
    final contentInfo = json['contentInfo'] as Map<String, dynamic>?;
    final content = contentInfo?['content'] as String? ??
        json['content'] as String? ??
        '';

    return CommentApiModel(
      id: json['messageID'] as String? ?? json['id'] as String? ?? '',
      chatRoomId: json['chatRoomID'] as String? ?? '',
      content: content,
      authorId: sender?['id'] as String? ?? '',
      authorName: sender?['name'] as String? ?? 'Unknown',
      authorAvatar: sender?['avatar'] as String?,
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
    );
  }

  Comment toDomain() {
    return Comment(
      id: id,
      ticketId: chatRoomId,
      authorId: authorId,
      authorName: authorName,
      authorAvatar: authorAvatar,
      content: content,
      type: CommentType.public,
      createdAt: createdAt,
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
