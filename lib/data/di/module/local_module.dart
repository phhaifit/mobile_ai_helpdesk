import 'dart:async';

import '/core/data/local/sembast/sembast_client.dart';
import '/data/local/constants/db_constants.dart';
import '/data/local/datasources/post/post_datasource.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../di/service_locator.dart';

class LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    // preference manager:------------------------------------------------------
    getIt.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance);
    getIt.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()),
    );

    // database:----------------------------------------------------------------

    getIt.registerSingletonAsync<SembastClient>(
      () async => SembastClient.provideDatabase(
        databaseName: DBConstants.DB_NAME,
        databasePath: kIsWeb
            ? "/assets/db"
            : (await getApplicationDocumentsDirectory()).path,
      ),
    );

    // data sources:------------------------------------------------------------
    getIt.registerSingleton(
        PostDataSource(await getIt.getAsync<SembastClient>()));
  }
}
