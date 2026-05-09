import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

import 'package:ai_helpdesk/data/local/mock_data.dart';

class MockTicketDataSource {
  static const _seedCustomerIds = <String>{'cust_1', 'cust_2', 'cust_3'};

  late final List<Ticket> _seedTickets;

  MockTicketDataSource() {
    final agents = MockDataGenerator.generateAgents();
    final tickets = MockDataGenerator.generateTickets(agents);

    // Keep the seed small and predictable so customer detail remains easy to smoke-test.
    _seedTickets =
        tickets
            .where((t) => _seedCustomerIds.contains(t.customerId))
            .take(7)
            .map(_attachChatRoomLink)
            .toList();
  }

  Ticket _attachChatRoomLink(Ticket ticket) {
    final chatRoomId = switch (ticket.customerId) {
      'cust_1' => 'chatroom_cust_1_messenger',
      'cust_2' => 'chatroom_cust_2_zalo',
      'cust_3' => 'chatroom_cust_3_webchat',
      _ => null,
    };

    return ticket.copyWith(chatRoomId: chatRoomId);
  }

  Future<List<Ticket>> getCustomerTickets(String customerId) async {
    // Keep parity with other mock datasources (small artificial delay).
    await Future.delayed(const Duration(milliseconds: 250));

    return _seedTickets
        .where((ticket) => ticket.customerId == customerId)
        .toList();
  }
}
