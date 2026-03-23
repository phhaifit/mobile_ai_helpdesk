import 'dart:async';

import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/add_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_db_connection_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';

import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // use cases:---------------------------------------------------------------
    getIt.registerSingleton<GetTicketsUseCase>(
      GetTicketsUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetKnowledgeSourcesUseCase>(
      GetKnowledgeSourcesUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<AddKnowledgeSourceUseCase>(
      AddKnowledgeSourceUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<DeleteKnowledgeSourceUseCase>(
      DeleteKnowledgeSourceUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<ReindexSourceUseCase>(
      ReindexSourceUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<TestDbConnectionUseCase>(
      TestDbConnectionUseCase(getIt<KnowledgeRepository>()),
    );
  }
}
