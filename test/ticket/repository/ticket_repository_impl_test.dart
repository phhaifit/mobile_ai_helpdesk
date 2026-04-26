import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/ticket/ticket_repository_impl.dart';
import 'package:ai_helpdesk/data/local/ticket/mock_ticket_local_datasource.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_ticket_api.dart';
import '../helpers/ticket_fixtures.dart';

void main() {
  late FakeTicketApi fakeApi;
  late TicketRepositoryImpl repo;

  setUp(() {
    fakeApi = FakeTicketApi();
    final mockLocal = MockTicketLocalDataSource();
    final mockRepo = MockTicketRepositoryImpl(mockLocal);
    repo = TicketRepositoryImpl(fakeApi, mockRepo);
  });

  // ---------------------------------------------------------------------------
  // getCustomerHistory
  // ---------------------------------------------------------------------------

  group('getCustomerHistory', () {
    test('passes customerId to API', () async {
      fakeApi.customerTicketsResponse = [];

      await repo.getCustomerHistory(kTestCustomerId);

      expect(fakeApi.lastGetCustomerTicketsId, kTestCustomerId);
    });

    test('returns empty list when API returns nothing', () async {
      fakeApi.customerTicketsResponse = [];

      final result = await repo.getCustomerHistory(kTestCustomerId);

      expect(result, isEmpty);
    });

    test('maps API JSON list to domain Ticket list', () async {
      fakeApi.customerTicketsResponse = [kApiTicketJson];

      final result = await repo.getCustomerHistory(kTestCustomerId);

      expect(result.length, 1);
      expect(result.first.id, kTestTicketId);
      expect(result.first.title, 'Login issue');
      expect(result.first.status, TicketStatus.open);
      expect(result.first.priority, TicketPriority.high);
      expect(result.first.customerId, kTestCustomerId);
    });

    test('maps multiple tickets', () async {
      fakeApi.customerTicketsResponse = [
        kApiTicketJson,
        {
          ...kApiTicketJson,
          'id': 'ticket-002',
          'title': 'Payment failed',
          'status': 'solved',
          'priority': 'medium',
        },
      ];

      final result = await repo.getCustomerHistory(kTestCustomerId);

      expect(result.length, 2);
      expect(result[1].id, 'ticket-002');
      expect(result[1].status, TicketStatus.resolved);
    });

    test('ignores non-map items in API list', () async {
      fakeApi.customerTicketsResponse = [kApiTicketJson, 'invalid', 42];

      final result = await repo.getCustomerHistory(kTestCustomerId);

      // Only the valid Map item is mapped.
      expect(result.length, 1);
    });

    test('maps channelType to correct TicketSource', () async {
      fakeApi.customerTicketsResponse = [
        {...kApiTicketJson, 'channelType': 'messenger'},
      ];

      final result = await repo.getCustomerHistory(kTestCustomerId);

      expect(result.first.source, TicketSource.messenger);
    });
  });

  // ---------------------------------------------------------------------------
  // getComments
  // ---------------------------------------------------------------------------

  group('getComments', () {
    test('passes ticketId to API', () async {
      fakeApi.commentsResponse = [];

      await repo.getComments(kTestTicketId);

      expect(fakeApi.lastGetCommentsTicketId, kTestTicketId);
    });

    test('returns empty list when API returns nothing', () async {
      fakeApi.commentsResponse = [];

      final result = await repo.getComments(kTestTicketId);

      expect(result, isEmpty);
    });

    test('maps API JSON list to domain Comment list', () async {
      fakeApi.commentsResponse = [kApiCommentJson];

      final result = await repo.getComments(kTestTicketId);

      expect(result.length, 1);
      expect(result.first.id, 'cmt-001');
      expect(result.first.content, 'Looking into this now.');
      expect(result.first.authorName, 'Agent 1');
      expect(result.first.type, CommentType.public);
    });

    test('maps multiple comments in order', () async {
      final comment2Json = {
        ...kApiCommentJson,
        'id': 'cmt-002',
        'content': 'Escalated',
      };
      fakeApi.commentsResponse = [kApiCommentJson, comment2Json];

      final result = await repo.getComments(kTestTicketId);

      expect(result.length, 2);
      expect(result[0].id, 'cmt-001');
      expect(result[1].id, 'cmt-002');
    });

    test('ignores non-map items in API list', () async {
      fakeApi.commentsResponse = [kApiCommentJson, 'bad-data'];

      final result = await repo.getComments(kTestTicketId);

      expect(result.length, 1);
    });
  });

  // ---------------------------------------------------------------------------
  // addComment
  // ---------------------------------------------------------------------------

  group('addComment', () {
    test('passes ticketId and content to API', () async {
      fakeApi.addCommentResponse = kApiAddCommentResponse;

      await repo.addComment(ticketId: kTestTicketId, comment: kTestComment);

      expect(fakeApi.lastAddCommentTicketId, kTestTicketId);
      expect(fakeApi.lastAddCommentContent, kTestComment.content);
    });

    test('returns comment with server-assigned id when API returns id', () async {
      fakeApi.addCommentResponse = kApiAddCommentResponse;

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.id, 'cmt-server-001');
    });

    test('returns comment with server-assigned createdAt', () async {
      fakeApi.addCommentResponse = kApiAddCommentResponse;

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.createdAt, DateTime.utc(2024, 6, 1, 10, 0, 0));
    });

    test('returns optimistic comment with temp id when API returns empty map', () async {
      fakeApi.addCommentResponse = {};

      // kTestComment has id 'cmt-001' (non-empty), so it's returned as-is.
      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.id, kTestComment.id);
      expect(result.content, kTestComment.content);
    });

    test('assigns tmp_xxx id when API returns empty and comment id is empty', () async {
      fakeApi.addCommentResponse = {};
      final commentWithNoId = kTestComment.copyWith(id: '');

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: commentWithNoId,
      );

      expect(result.id, startsWith('tmp_'));
    });

    test('preserves comment content from original when falling back', () async {
      fakeApi.addCommentResponse = {};

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.content, kTestComment.content);
    });
  });
}
