import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

/// Maps the API Comment JSON response to the domain [Comment] entity.
///
/// The API schema for comments is not fully specified, so fields are parsed
/// defensively with safe defaults.  Fields not returned by the server (e.g.
/// [type], [attachments]) keep their Phase-1 defaults.
class CommentApiModel {
  final String id;
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
    return CommentApiModel(
      id: json['id'] as String? ?? '',
      ticketId: json['ticketId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Unknown',
      authorAvatar: json['authorAvatar'] as String?,
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
