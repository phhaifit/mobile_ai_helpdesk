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
  // getComments — flows through chat-room (resolves chatRoomId from ticket)
  // ---------------------------------------------------------------------------

  group('getComments', () {
    const kChatRoomId = 'chatroom-001';

    test('returns empty list when ticket has no chatRoomId', () async {
      fakeApi.ticketDetailResponse = {'id': kTestTicketId};

      final result = await repo.getComments(kTestTicketId);

      expect(result, isEmpty);
    });

    test('resolves chatRoomId from ticket detail', () async {
      fakeApi.ticketDetailResponse = {
        'id': kTestTicketId,
        'chatRoomId': kChatRoomId,
      };
      fakeChatRoomApi.messagesResponse = [];

      await repo.getComments(kTestTicketId);

      expect(fakeApi.lastGetTicketDetailId, kTestTicketId);
      expect(fakeChatRoomApi.lastGetMessagesChatRoomId, kChatRoomId);
    });

    test('returns empty list when chat-room has no messages', () async {
      fakeApi.ticketDetailResponse = {
        'id': kTestTicketId,
        'chatRoomId': kChatRoomId,
      };
      fakeChatRoomApi.messagesResponse = [];

      final result = await repo.getComments(kTestTicketId);

      expect(result, isEmpty);
    });

    test('maps chat-room messages to Comment list', () async {
      fakeApi.ticketDetailResponse = {
        'id': kTestTicketId,
        'chatRoomId': kChatRoomId,
      };
      fakeChatRoomApi.messagesResponse = [
        {
          'messageID': 'msg-001',
          'chatRoomID': kChatRoomId,
          'contentInfo': {'content': 'Hello'},
          'sender': {'id': 'agent-1', 'name': 'Agent 1'},
          'createdAt': '2024-06-01T10:00:00.000Z',
        }
      ];

      final result = await repo.getComments(kTestTicketId);

      expect(result.length, 1);
      expect(result.first.id, 'msg-001');
      expect(result.first.content, 'Hello');
      expect(result.first.authorName, 'Agent 1');
    });

    test('returns empty list and swallows errors on API failure', () async {
      // ticketDetailResponse is empty by default; getMessages will not be called.
      final result = await repo.getComments(kTestTicketId);

      expect(result, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // addComment — flows through chat-room (resolves chatRoomId + channelId)
  // ---------------------------------------------------------------------------

  group('addComment', () {
    const kChatRoomId = 'chatroom-001';
    const kChannelId = 'chan-001';

    test('returns optimistic comment when ticket has no chatRoomId', () async {
      fakeApi.ticketDetailResponse = {'id': kTestTicketId};

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.id, kTestComment.id);
      expect(result.content, kTestComment.content);
    });

    test('resolves chatRoomId then sends via chat-room API', () async {
      fakeApi.ticketDetailResponse = {
        'id': kTestTicketId,
        'chatRoomId': kChatRoomId,
      };
      fakeChatRoomApi.chatRoomDetailResponse = {
        'lastMessage': {'channelID': kChannelId, 'contactID': 'contact-1'},
      };
      fakeChatRoomApi.sendMessageResponse = {
        'messageID': 'msg-server-001',
        'chatRoomID': kChatRoomId,
        'contentInfo': {'content': kTestComment.content},
        'sender': {'id': 'agent-1', 'name': 'Agent 1'},
        'createdAt': '2024-06-01T10:00:00.000Z',
      };

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(fakeChatRoomApi.lastSendMessageChatRoomId, kChatRoomId);
      expect(fakeChatRoomApi.lastSendMessageChannelId, kChannelId);
      expect(fakeChatRoomApi.lastSendMessageContent, kTestComment.content);
      expect(result.id, 'msg-server-001');
    });

    test('returns optimistic comment when channelId is missing', () async {
      fakeApi.ticketDetailResponse = {
        'id': kTestTicketId,
        'chatRoomId': kChatRoomId,
      };
      fakeChatRoomApi.chatRoomDetailResponse = {};

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.id, kTestComment.id);
      expect(result.content, kTestComment.content);
    });

    test('assigns tmp_xxx id when chatRoomId missing and comment id empty',
        () async {
      fakeApi.ticketDetailResponse = {'id': kTestTicketId};
      final commentWithNoId = kTestComment.copyWith(id: '');

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: commentWithNoId,
      );

      expect(result.id, startsWith('tmp_'));
    });

    test('preserves original content when falling back', () async {
      fakeApi.ticketDetailResponse = {'id': kTestTicketId};

      final result = await repo.addComment(
        ticketId: kTestTicketId,
        comment: kTestComment,
      );

      expect(result.content, kTestComment.content);
    });
  });
}
