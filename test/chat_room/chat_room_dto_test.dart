import 'package:ai_helpdesk/data/network/dto/chat_room/chat_room_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatRoomDto.toEntity', () {
    test('computes unreadCount as totalMessage - seenMessageOrder', () {
      final dto = ChatRoomDto.fromJson({
        'chatRoomID': 'chr_1',
        'customerID': 'cust_1',
        'totalMessage': 42,
        'seenMessageOrder': 38,
      });
      final entity = dto.toEntity();
      expect(entity.unreadCount, 4);
      expect(entity.hasUnread, isTrue);
    });

    test('clamps negative unread (seen > total) to zero', () {
      final dto = ChatRoomDto.fromJson({
        'chatRoomID': 'chr_1',
        'totalMessage': 5,
        'seenMessageOrder': 10,
      });
      expect(dto.toEntity().unreadCount, 0);
    });

    test('extracts last message preview and channel from contactInfo.name', () {
      final dto = ChatRoomDto.fromJson({
        'chatRoomID': 'chr_1',
        'lastMessage': {
          'messageID': 'msg_1',
          'createdAt': '2026-01-15T10:30:00.000Z',
          'contactInfo': {'name': 'messenger'},
          'contentInfo': {'content': 'Hello, I need help'},
        },
      });
      final entity = dto.toEntity();
      expect(entity.channel, 'messenger');
      expect(entity.lastMessagePreview, 'Hello, I need help');
      expect(entity.lastMessageAt, isNotNull);
    });

    test('collects linked ticket IDs from tickets[]', () {
      final dto = ChatRoomDto.fromJson({
        'chatRoomID': 'chr_1',
        'tickets': [
          {'ticketID': 'tkt_1'},
          {'ticketID': 'tkt_2'},
        ],
      });
      expect(dto.toEntity().linkedTicketIds, ['tkt_1', 'tkt_2']);
    });
  });
}
