import 'dart:async';

import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/add_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_db_connection_usecase.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';

import '../../../di/service_locator.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());

    // stores:------------------------------------------------------------------
    getIt.registerSingleton<ThemeStore>(
      ThemeStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<KnowledgeStore>(
      KnowledgeStore(
        getIt<GetKnowledgeSourcesUseCase>(),
        getIt<AddKnowledgeSourceUseCase>(),
        getIt<DeleteKnowledgeSourceUseCase>(),
        getIt<ReindexSourceUseCase>(),
        getIt<TestDbConnectionUseCase>(),
      ),
    );
  }
}
