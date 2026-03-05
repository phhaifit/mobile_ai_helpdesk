import '../../di/service_locator.dart';
import '../chat/store/chat_store.dart';
import '../../../domain/repository/chat/chat_repository.dart';

Future<void> setupPresentationLayerInjection() async {
  // ... các đăng ký cũ của project

  // Đăng ký ChatStore dưới dạng Singleton
  // (Để tin nhắn không bị mất khi bạn chuyển màn hình tạm thời)
  getIt.registerSingleton<ChatStore>(ChatStore(getIt<ChatRepository>()));
}
