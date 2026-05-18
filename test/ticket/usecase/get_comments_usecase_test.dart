import 'package:ai_helpdesk/domain/usecase/ticket/get_comments_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_ticket_repository.dart';
import '../helpers/ticket_fixtures.dart';

void main() {
  late FakeTicketRepository fakeRepo;
  late GetCommentsUseCase useCase;

  setUp(() {
    fakeRepo = FakeTicketRepository();
    useCase = GetCommentsUseCase(fakeRepo);
  });

  group('GetCommentsUseCase', () {
    test('passes ticketId to repository', () async {
      fakeRepo.commentsToReturn = [];

      await useCase(params: kTestTicketId);

      expect(fakeRepo.capturedGetCommentsTicketId, kTestTicketId);
    });

    test('returns empty list when ticket has no comments', () async {
      fakeRepo.commentsToReturn = [];

      final result = await useCase(params: kTestTicketId);

      expect(result, isEmpty);
    });

    test('returns all comments from repository', () async {
      fakeRepo.commentsToReturn = [kTestComment, kTestComment2];

      final result = await useCase(params: kTestTicketId);

      expect(result.length, 2);
      expect(result[0].id, kTestComment.id);
      expect(result[1].id, kTestComment2.id);
    });

    test('comments have correct ticketId', () async {
      fakeRepo.commentsToReturn = [kTestComment, kTestComment2];

      final result = await useCase(params: kTestTicketId);

      for (final comment in result) {
        expect(comment.ticketId, kTestTicketId);
      }
    });

    test('returns comments with correct content', () async {
      fakeRepo.commentsToReturn = [kTestComment];

      final result = await useCase(params: kTestTicketId);

      expect(result.first.content, kTestComment.content);
    });
  });
}
