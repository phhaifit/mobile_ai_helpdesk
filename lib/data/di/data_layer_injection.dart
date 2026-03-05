import '../../di/service_locator.dart';
import '../local/datasources/chat/chat_datasource.dart';
import '../repository/chat/chat_repository_impl.dart';
import '../../../domain/repository/chat/chat_repository.dart';

Future<void> setupDataLayerInjection() async {
  // 1. Đăng ký DataSource (Dữ liệu thô)
  getIt.registerSingleton<ChatDataSource>(ChatDataSource());

  // 2. Đăng ký Repository (Đây là cầu nối cho Store)
  // Store sẽ gọi ChatRepository (Interface), và GetIt sẽ trả về ChatRepositoryImpl
  getIt.registerSingleton<ChatRepository>(
    ChatRepositoryImpl(getIt<ChatDataSource>()),
  );
}
