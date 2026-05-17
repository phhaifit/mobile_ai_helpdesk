import 'package:ai_helpdesk/data/models/ticket/comment_api_model.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ticket_fixtures.dart';

void main() {
  // ---------------------------------------------------------------------------
  // CommentApiModel.fromJson
  // ---------------------------------------------------------------------------

  group('CommentApiModel.fromJson', () {
    test('maps all fields from well-formed JSON', () {
      final model = CommentApiModel.fromJson(kApiCommentJson);

      expect(model.id, 'cmt-001');
      expect(model.ticketId, kTestTicketId);
      expect(model.content, 'Looking into this now.');
      expect(model.authorId, kTestAuthorId);
      expect(model.authorName, 'Agent 1');
      expect(model.createdAt, DateTime.utc(2024, 6, 1, 10, 0, 0));
    });

    test('uses safe defaults for missing fields', () {
      final model = CommentApiModel.fromJson({});

      expect(model.id, '');
      expect(model.ticketId, '');
      expect(model.content, '');
      expect(model.authorId, '');
      expect(model.authorName, 'Unknown');
      expect(model.authorAvatar, isNull);
      expect(model.updatedAt, isNull);
    });

    test('parses optional authorAvatar when present', () {
      final model = CommentApiModel.fromJson({
        ...kApiCommentJson,
        'authorAvatar': 'https://example.com/avatar.png',
      });

      expect(model.authorAvatar, 'https://example.com/avatar.png');
    });

    test('parses updatedAt when present', () {
      final model = CommentApiModel.fromJson({
        ...kApiCommentJson,
        'updatedAt': '2024-06-01T11:00:00.000Z',
      });

      expect(model.updatedAt, DateTime.utc(2024, 6, 1, 11, 0, 0));
    });

    test('handles invalid createdAt gracefully — falls back to now', () {
      final before = DateTime.now();
      final model = CommentApiModel.fromJson({
        ...kApiCommentJson,
        'createdAt': 'not-a-date',
      });
      final after = DateTime.now();

      // Fallback is DateTime.now() inside fromJson
      expect(
        model.createdAt.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(model.createdAt.isBefore(after.add(const Duration(seconds: 1))), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // CommentApiModel.toDomain
  // ---------------------------------------------------------------------------

  group('CommentApiModel.toDomain', () {
    test('maps to domain Comment with correct fields', () {
      final comment = CommentApiModel.fromJson(kApiCommentJson).toDomain();

      expect(comment.id, 'cmt-001');
      expect(comment.ticketId, kTestTicketId);
      expect(comment.content, 'Looking into this now.');
      expect(comment.authorId, kTestAuthorId);
      expect(comment.authorName, 'Agent 1');
      expect(comment.type, CommentType.public);
    });

    test('defaults to CommentType.public (API does not return type)', () {
      final comment = CommentApiModel.fromJson(kApiCommentJson).toDomain();

      expect(comment.type, CommentType.public);
    });

    test('preserves authorAvatar in domain entity', () {
      final comment = CommentApiModel.fromJson({
        ...kApiCommentJson,
        'authorAvatar': 'https://example.com/avatar.png',
      }).toDomain();

      expect(comment.authorAvatar, 'https://example.com/avatar.png');
    });

    test('attachments list is empty by default', () {
      final comment = CommentApiModel.fromJson(kApiCommentJson).toDomain();

      expect(comment.attachments, isEmpty);
    });
  });
}
