import '../../di/service_locator.dart';
import '../chat/store/chat_store.dart';
import '../chat/store/chat_room_store.dart';
import '../customer_management/store/customer_store.dart';
import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../../domain/repository/customer_management/customer_repository.dart';

Future<void> setupPresentationLayerInjection() async {
  getIt.registerSingleton<ChatStore>(ChatStore(getIt<ChatRepository>()));
  getIt.registerSingleton<ChatRoomStore>(
    ChatRoomStore(getIt<ChatRoomRepository>()),
  );
  getIt.registerSingleton<CustomerStore>(
    CustomerStore(getIt<CustomerRepository>()),
  );
}
