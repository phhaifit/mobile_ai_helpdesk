import 'package:ai_helpdesk/domain/usecase/ticket/add_comment_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_ticket_repository.dart';
import '../helpers/ticket_fixtures.dart';

void main() {
  late FakeTicketRepository fakeRepo;
  late AddCommentUseCase useCase;

  setUp(() {
    fakeRepo = FakeTicketRepository();
    useCase = AddCommentUseCase(fakeRepo);
  });

  group('AddCommentUseCase', () {
    test('passes ticketId and comment to repository', () async {
      fakeRepo.addCommentResult = kTestComment;

      await useCase(
        params: AddCommentParams(
          ticketId: kTestTicketId,
          comment: kTestComment,
        ),
      );

      expect(fakeRepo.capturedAddCommentTicketId, kTestTicketId);
      expect(fakeRepo.capturedAddComment?.id, kTestComment.id);
      expect(fakeRepo.capturedAddComment?.content, kTestComment.content);
    });

    test('returns comment from repository', () async {
      fakeRepo.addCommentResult = kTestComment;

      final result = await useCase(
        params: AddCommentParams(
          ticketId: kTestTicketId,
          comment: kTestComment,
        ),
      );

      expect(result.id, kTestComment.id);
      expect(result.content, kTestComment.content);
    });

    test('returns the input comment when addCommentResult is null (echo)', () async {
      fakeRepo.addCommentResult = null;

      final result = await useCase(
        params: AddCommentParams(
          ticketId: kTestTicketId,
          comment: kTestComment,
        ),
      );

      expect(result, kTestComment);
    });

    test('works for internal comment type', () async {
      fakeRepo.addCommentResult = kTestComment2;

      final result = await useCase(
        params: AddCommentParams(
          ticketId: kTestTicketId,
          comment: kTestComment2,
        ),
      );

      expect(result.id, kTestComment2.id);
      expect(result.type, kTestComment2.type);
    });

    test('captures comment content correctly', () async {
      fakeRepo.addCommentResult = kTestComment;

      await useCase(
        params: AddCommentParams(
          ticketId: kTestTicketId,
          comment: kTestComment,
        ),
      );

      expect(fakeRepo.capturedAddComment?.content, 'Looking into this now.');
    });
  });
}
