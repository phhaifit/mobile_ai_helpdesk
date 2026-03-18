import 'dart:async';

import 'package:get_it/get_it.dart';

import '/data/repository/setting/setting_repository_impl.dart';
import '/data/repository/ticket/mock_ticket_repository_impl.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/repository/setting/setting_repository.dart';
import '/domain/repository/ticket/ticket_repository.dart';
// Import Interfaces (Domain)
import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../../domain/repository/customer_management/customer_repository.dart';
// Import DataSources
import '../../local/datasources/chat/chat_datasource.dart';
import '../../local/datasources/chat/chat_room_datasource.dart';
import '../../local/datasources/customer_management/customer_datasource.dart';
// Import Implementations (Data)
import '../../repository/chat/chat_repository_impl.dart';
import '../../repository/chat/chat_room_repository_impl.dart';
import '../../repository/customer_management/customer_repository_impl.dart';

class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    final getIt = GetIt.instance;

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

    // --- Setting Repository ---
    getIt.registerLazySingleton<SettingRepository>(
      () =>
          SettingRepositoryImpl(getIt<SharedPreferenceHelper>())
              as SettingRepository,
    );

    // --- Ticket Repository ---
    getIt.registerLazySingleton<TicketRepository>(
      () => MockTicketRepositoryImpl() as TicketRepository,
    );
  }
}
