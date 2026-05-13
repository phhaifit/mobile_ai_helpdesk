import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';

abstract class CustomerChatRoomRepository {
  /// Returns the chat rooms (omnichannel conversations) belonging to a
  /// single customer, newest message first.
  Future<List<CustomerChatRoom>> getCustomerChatRooms(String customerId);
}
