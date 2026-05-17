import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/data/local/sembast/sembast_client.dart';
import '/data/local/constants/db_constants.dart';
import '/data/local/datasources/chat_room/mock_chat_room_datasource.dart';
import '/data/local/datasources/ticket/mock_ticket_datasource.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '../../local/datasources/customer/mock_customer_datasource.dart';
import '../../local/datasources/playground/playground_datasource.dart';

class LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    final getIt = GetIt.instance;

    // --- Playground DataSource ---
    getIt.registerSingleton<PlaygroundDataSource>(PlaygroundDataSource());

    // --- Customer DataSources ---
    getIt.registerSingleton<MockCustomerDataSource>(MockCustomerDataSource());

    // --- Sprint 3 debug fallback data sources ---
    getIt.registerSingleton<MockTicketDataSource>(MockTicketDataSource());
    getIt.registerSingleton<MockChatRoomDataSource>(MockChatRoomDataSource());

    // preference manager:------------------------------------------------------
    getIt.registerSingletonAsync<SharedPreferences>(
      SharedPreferences.getInstance,
    );
    getIt.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()),
    );

    // database:----------------------------------------------------------------
    getIt.registerSingletonAsync<SembastClient>(
      () async => SembastClient.provideDatabase(
        databaseName: DBConstants.dbName,
        databasePath:
            kIsWeb
                ? '/assets/db'
                : (await getApplicationDocumentsDirectory()).path,
      ),
    );
  }
}
