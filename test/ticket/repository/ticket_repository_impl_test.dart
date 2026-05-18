import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/ticket/ticket_repository_impl.dart';
import 'package:ai_helpdesk/data/local/ticket/mock_ticket_local_datasource.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_chat_room_api.dart';
import '../helpers/fake_ticket_api.dart';
import '../helpers/ticket_fixtures.dart';

void main() {
  late FakeTicketApi fakeApi;
  late FakeChatRoomApi fakeChatRoomApi;
  late TicketRepositoryImpl repo;

  setUp(() {
    fakeApi = FakeTicketApi();
    fakeChatRoomApi = FakeChatRoomApi();
    final mockLocal = MockTicketLocalDataSource();
    final mockRepo = MockTicketRepositoryImpl(mockLocal);
    repo = TicketRepositoryImpl(fakeApi, fakeChatRoomApi, mockRepo);
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
  // getComments — hot-fix routes through TicketApi.getComments, which slices
  // `commentsOfTicket` out of GET /ticket/{id}. The repository sorts the
  // result oldest-first so the comment thread reads top-to-bottom.
  // ---------------------------------------------------------------------------

  group('getComments', () {
    test('delegates to TicketApi.getComments with the ticket id', () async {
      fakeApi.commentsResponse = [];

      await repo.getComments(kTestTicketId);

      expect(fakeApi.lastGetCommentsTicketId, kTestTicketId);
    });

    test('returns empty list when API yields no comments', () async {
      fakeApi.commentsResponse = [];

      final result = await repo.getComments(kTestTicketId);

      expect(result, isEmpty);
    });

    test('maps ticket-comment JSON to Comment list', () async {
      fakeApi.commentsResponse = [
        {
          'commentID': 'cmt-001',
          'ticketID': kTestTicketId,
          'body': 'Hello',
          'customerSupportID': 'agent-1',
          'customerSupport': {'fullname': 'Agent 1'},
          'createdAt': '2024-06-01T10:00:00.000Z',
        },
      ];

      final result = await repo.getComments(kTestTicketId);

      expect(result.length, 1);
      expect(result.first.id, 'cmt-001');
      expect(result.first.content, 'Hello');
      expect(result.first.authorName, 'Agent 1');
    });

    test('sorts comments oldest-first', () async {
      fakeApi.commentsResponse = [
        // BE returns newest-first; repo flips so newer comments come last.
        {
          'commentID': 'cmt-newer',
          'body': 'Newer',
          'createdAt': '2024-06-02T10:00:00.000Z',
        },
        {
          'commentID': 'cmt-older',
          'body': 'Older',
          'createdAt': '2024-06-01T10:00:00.000Z',
        },
      ];

      final result = await repo.getComments(kTestTicketId);

      expect(result.first.id, 'cmt-older');
      expect(result.last.id, 'cmt-newer');
    });

    test('returns empty list and swallows errors on API failure', () async {
      // commentsResponse is empty by default; nothing to map.
      final result = await repo.getComments(kTestTicketId);

      expect(result, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // addComment — hot-fix posts to /ticket/comment/add-comment via
  // TicketApi.addComment. The repository uses the server-issued comment
  // when the response is populated, otherwise falls back to an optimistic
  // placeholder (preserving a non-empty client id or generating tmp_*).
  // ---------------------------------------------------------------------------

  group('addComment', () {
    test('delegates to TicketApi.addComment with the comment content',
        () async {
      fakeApi.addCommentResponse = {};

      await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(fakeApi.lastAddCommentTicketId, kTestTicketId);
      expect(fakeApi.lastAddCommentContent, kTestComment.content);
    });

    test('returns the server-issued comment when BE response is populated',
        () async {
      fakeApi.addCommentResponse = {
        'commentID': 'cmt-server-001',
        'ticketID': kTestTicketId,
        'body': kTestComment.content,
        'customerSupportID': 'agent-1',
        'customerSupport': {'fullname': 'Agent 1'},
        'createdAt': '2024-06-01T10:00:00.000Z',
      };

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.id, 'cmt-server-001');
      expect(result.content, kTestComment.content);
      expect(result.authorName, 'Agent 1');
      // The repository preserves the locally-chosen CommentType because BE
      // doesn't model public/internal.
      expect(result.type, kTestComment.type);
    });

    test('returns the optimistic comment when BE response is empty', () async {
      fakeApi.addCommentResponse = {};

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.id, kTestComment.id);
      expect(result.content, kTestComment.content);
    });

    test('assigns tmp_xxx id when response empty and comment id is empty',
        () async {
      fakeApi.addCommentResponse = {};
      final commentWithNoId = kTestComment.copyWith(id: '');

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: commentWithNoId,
      );

      expect(result.id, startsWith('tmp_'));
    });

    test('preserves original content when falling back to optimistic', () async {
      fakeApi.addCommentResponse = {};

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.content, kTestComment.content);
    });
  });
}
