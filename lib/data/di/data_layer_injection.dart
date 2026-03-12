import '../../di/service_locator.dart';
import '../local/datasources/chat/chat_datasource.dart';
import '../local/datasources/chat/chat_room_datasource.dart';
import '../local/datasources/customer_management/customer_datasource.dart';
import '../repository/chat/chat_repository_impl.dart';
import '../repository/chat/chat_room_repository_impl.dart';
import '../repository/customer_management/customer_repository_impl.dart';
import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../../domain/repository/customer_management/customer_repository.dart';

Future<void> setupDataLayerInjection() async {
  // --- Chat messages ---
  getIt.registerSingleton<ChatDataSource>(ChatDataSource());
  getIt.registerSingleton<ChatRepository>(
    ChatRepositoryImpl(getIt<ChatDataSource>()),
  );

  // --- Chat rooms ---
  getIt.registerSingleton<ChatRoomDataSource>(ChatRoomDataSource());
  getIt.registerSingleton<ChatRoomRepository>(
    ChatRoomRepositoryImpl(getIt<ChatRoomDataSource>()),
  );

  // --- Customer management ---
  getIt.registerSingleton<CustomerDataSource>(CustomerDataSource());
  getIt.registerSingleton<CustomerRepository>(
    CustomerRepositoryImpl(getIt<CustomerDataSource>()),
  );
}
