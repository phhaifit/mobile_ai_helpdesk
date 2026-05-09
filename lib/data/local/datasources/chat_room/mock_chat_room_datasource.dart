import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';

class MockChatRoomDataSource {
  static const _seedCustomerIds = <String>{'cust_1', 'cust_2', 'cust_3'};

  late final List<CustomerChatRoom> _seedRooms;

  MockChatRoomDataSource() {
    final base = DateTime(2025, 1, 15, 12, 0);

    final rooms = <CustomerChatRoom>[
      CustomerChatRoom(
        id: 'chatroom_cust_1_messenger',
        customerId: 'cust_1',
        channel: 'messenger',
        totalMessage: 52,
        unreadCount: 4,
        lastMessagePreview: 'Can you help me with my order status?',
        lastMessageAt: base.subtract(const Duration(minutes: 8)),
        linkedTicketIds: const ['ticket_cust_1_1'],
      ),
      CustomerChatRoom(
        id: 'chatroom_cust_1_webchat',
        customerId: 'cust_1',
        channel: 'webchat',
        totalMessage: 11,
        unreadCount: 0,
        lastMessagePreview: 'Thanks!',
        lastMessageAt: base.subtract(const Duration(hours: 2)),
        linkedTicketIds: const [],
      ),
      CustomerChatRoom(
        id: 'chatroom_cust_2_zalo',
        customerId: 'cust_2',
        channel: 'zalo',
        totalMessage: 87,
        unreadCount: 12,
        lastMessagePreview: 'Mình muốn đổi sản phẩm.',
        lastMessageAt: base.subtract(const Duration(minutes: 3)),
        linkedTicketIds: const ['ticket_cust_2_1'],
      ),
      CustomerChatRoom(
        id: 'chatroom_cust_2_email',
        customerId: 'cust_2',
        channel: 'email',
        totalMessage: 6,
        unreadCount: 1,
        lastMessagePreview: 'Please find the invoice attached.',
        lastMessageAt: base.subtract(const Duration(days: 1, hours: 3)),
        linkedTicketIds: const [],
      ),
      CustomerChatRoom(
        id: 'chatroom_cust_3_webchat',
        customerId: 'cust_3',
        channel: 'webchat',
        totalMessage: 33,
        unreadCount: 2,
        lastMessagePreview: 'I cannot log in to my account.',
        lastMessageAt: base.subtract(const Duration(minutes: 40)),
        linkedTicketIds: const ['ticket_cust_3_1'],
      ),
    ];

    _seedRooms = rooms
        .where((r) => _seedCustomerIds.contains(r.customerId))
        .take(7)
        .toList(growable: false);
  }

  Future<List<CustomerChatRoom>> getCustomerChatRooms(String customerId) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return _seedRooms
        .where((room) => room.customerId == customerId)
        .toList(growable: false);
  }
}
