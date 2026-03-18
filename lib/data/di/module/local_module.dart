import 'package:get_it/get_it.dart';
// Import các datasource của bạn
import '../../local/datasources/chat/chat_datasource.dart';
import '../../local/datasources/chat/chat_room_datasource.dart';
import '../../local/datasources/customer_management/customer_datasource.dart';

class LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    final getIt = GetIt.instance;

    // --- Chat DataSources ---
    getIt.registerSingleton<ChatDataSource>(ChatDataSource());
    getIt.registerSingleton<ChatRoomDataSource>(ChatRoomDataSource());

    // --- Customer DataSources ---
    getIt.registerSingleton<CustomerDataSource>(CustomerDataSource());
  }
}
