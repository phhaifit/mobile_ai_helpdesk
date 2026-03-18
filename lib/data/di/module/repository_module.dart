import 'package:get_it/get_it.dart';
// Import Interfaces (Domain)
import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../../domain/repository/customer_management/customer_repository.dart';

// Import Implementations (Data)
import '../../repository/chat/chat_repository_impl.dart';
import '../../repository/chat/chat_room_repository_impl.dart';
import '../../repository/customer_management/customer_repository_impl.dart';

// Import DataSources để truyền vào Constructor
import '../../local/datasources/chat/chat_datasource.dart';
import '../../local/datasources/chat/chat_room_datasource.dart';
import '../../local/datasources/customer_management/customer_datasource.dart';

class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    final getIt = GetIt.instance;

    // Đăng ký Repository bằng cách lấy DataSource đã khởi tạo từ LocalModule

    // --- Chat Repositories ---
    getIt.registerSingleton<ChatRepository>(
      ChatRepositoryImpl(getIt<ChatDataSource>()),
    );

    getIt.registerSingleton<ChatRoomRepository>(
      ChatRoomRepositoryImpl(getIt<ChatRoomDataSource>()),
    );

    // --- Customer Repositories ---
    getIt.registerSingleton<CustomerRepository>(
      CustomerRepositoryImpl(getIt<CustomerDataSource>()),
    );
  }
}
