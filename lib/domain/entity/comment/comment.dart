import '../enums.dart';

class Comment {
  final String id;
  final String ticketId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final CommentType type;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> attachments;

  const Comment({
    required this.id,
    required this.ticketId,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.attachments = const [],
  });

  Comment copyWith({
    String? id,
    String? ticketId,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    CommentType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attachments,
  }) {
    return Comment(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  String toString() =>
      'Comment(id: $id, ticketId: $ticketId, authorName: $authorName)';
}
