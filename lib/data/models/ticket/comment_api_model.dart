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
    final cs = json['customerSupport'];
    final csMap = cs is Map<String, dynamic>
        ? cs
        : (cs is Map ? Map<String, dynamic>.from(cs) : null);

    final csName = csMap?['fullname'] as String?;
    final csAvatar = csMap?['profilePicture'] as String?;

    return CommentApiModel(
      id: (json['commentID'] ?? json['id']) as String? ?? '',
      ticketId: (json['ticketID'] ?? json['ticketId']) as String? ?? '',
      content: (json['body'] ?? json['content']) as String? ?? '',
      authorId:
          (json['customerSupportID'] ?? json['authorId']) as String? ?? '',
      authorName: csName ??
          json['fullname'] as String? ??
          json['authorName'] as String? ??
          'Unknown',
      authorAvatar: csAvatar ??
          json['profilePicture'] as String? ??
          json['authorAvatar'] as String?,
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
