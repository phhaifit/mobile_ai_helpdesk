import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/data/local/sembast/sembast_client.dart';
import '/data/local/constants/db_constants.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '../../local/datasources/ai_agent/ai_agent_datasource.dart';
import '../../local/datasources/chat/chat_datasource.dart';
import '../../local/datasources/chat/chat_room_datasource.dart';
import '../../local/datasources/customer_management/customer_datasource.dart';
import '../../local/datasources/playground/playground_datasource.dart';

class LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    final getIt = GetIt.instance;

    // --- AI Agent DataSources ---
    getIt.registerSingleton<AiAgentDataSource>(AiAgentDataSource());
    getIt.registerSingleton<PlaygroundDataSource>(PlaygroundDataSource());

    // --- Chat DataSources ---
    getIt.registerSingleton<ChatDataSource>(ChatDataSource());
    getIt.registerSingleton<ChatRoomDataSource>(ChatRoomDataSource());

    // --- Customer DataSources ---
    getIt.registerSingleton<CustomerDataSource>(CustomerDataSource());

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
        databasePath: kIsWeb
            ? "/assets/db"
            : (await getApplicationDocumentsDirectory()).path,
      ),
    );
  }
}
