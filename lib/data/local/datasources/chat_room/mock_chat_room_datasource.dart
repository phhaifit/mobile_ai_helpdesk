import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';

/// In-memory chat-room store used as a debug fallback for the customer
/// detail conversation timeline. Seed IDs match the customers seeded by
/// `MockCustomerDataSource` (`cust_1` / `cust_2` / `cust_3`) and the
/// tickets seeded by `MockTicketDataSource` (`tkt_*`).
class MockChatRoomDataSource {
  final List<CustomerChatRoom> _rooms = [];

  MockChatRoomDataSource() {
    _seed();
  }

  void _seed() {
    final now = DateTime.now();
    _rooms.addAll([
      CustomerChatRoom(
        id: 'chr_1001',
        customerId: 'cust_1',
        channel: 'messenger',
        totalMessage: 24,
        unreadCount: 2,
        lastMessagePreview: 'Mình vẫn chưa đăng nhập được, mong shop hỗ trợ ạ.',
        lastMessageAt: now.subtract(const Duration(hours: 5)),
        linkedTicketIds: const ['tkt_1001'],
      ),
      CustomerChatRoom(
        id: 'chr_1002',
        customerId: 'cust_1',
        channel: 'zalo',
        totalMessage: 12,
        unreadCount: 0,
        lastMessagePreview: 'Cảm ơn shop đã hỗ trợ hoàn tiền.',
        lastMessageAt: now.subtract(const Duration(days: 7)),
        linkedTicketIds: const ['tkt_1002'],
      ),
      CustomerChatRoom(
        id: 'chr_1003',
        customerId: 'cust_1',
        channel: 'webchat',
        totalMessage: 3,
        unreadCount: 0,
        lastMessagePreview: 'Chào shop, mình hỏi về sản phẩm A...',
        lastMessageAt: now.subtract(const Duration(days: 45)),
      ),
      CustomerChatRoom(
        id: 'chr_2001',
        customerId: 'cust_2',
        channel: 'webchat',
        totalMessage: 5,
        unreadCount: 1,
        lastMessagePreview: 'Em đặt lịch lúc 14h chiều mai được không ạ?',
        lastMessageAt: now.subtract(const Duration(hours: 1)),
        linkedTicketIds: const ['tkt_2001'],
      ),
      CustomerChatRoom(
        id: 'chr_3002',
        customerId: 'cust_3',
        channel: 'zalo',
        totalMessage: 18,
        unreadCount: 0,
        lastMessagePreview: 'Hàng đã nhận, cảm ơn.',
        lastMessageAt: now.subtract(const Duration(days: 110)),
        linkedTicketIds: const ['tkt_3002'],
      ),
    ]);
  }

  Future<List<CustomerChatRoom>> getCustomerChatRooms(String customerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final all = _rooms.where((r) => r.customerId == customerId).toList()
      ..sort((a, b) {
        final at = a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bt.compareTo(at);
      });
    return all;
  }
}
