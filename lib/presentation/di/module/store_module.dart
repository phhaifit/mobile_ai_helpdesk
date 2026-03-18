import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../chat/store/chat_store.dart';
import '../../chat/store/chat_room_store.dart';
import '../../customer_management/store/customer_store.dart';
import '../../home/store/language/language_store.dart';
import '../../home/store/theme/theme_store.dart';

import '../../../core/stores/error/error_store.dart';
import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../../domain/repository/customer_management/customer_repository.dart';
import '../../../domain/repository/setting/setting_repository.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    final getIt = GetIt.instance;

    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());

    // --- Chat Stores ---
    getIt.registerSingleton<ChatStore>(ChatStore(getIt<ChatRepository>()));

    getIt.registerSingleton<ChatRoomStore>(
      ChatRoomStore(getIt<ChatRoomRepository>()),
    );

    // --- Customer Management Stores ---
    getIt.registerSingleton<CustomerStore>(
      CustomerStore(getIt<CustomerRepository>()),
    );

    // --- Theme & Language Stores ---
    getIt.registerSingleton<ThemeStore>(
      ThemeStore(getIt<SettingRepository>(), getIt<ErrorStore>()),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(getIt<SettingRepository>(), getIt<ErrorStore>()),
    );
  }
}
