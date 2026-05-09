import 'dart:async';

import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';

abstract class CustomerChatRoomRepository {
  Future<List<CustomerChatRoom>> getCustomerChatRooms(String customerId);
}
