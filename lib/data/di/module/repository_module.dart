import 'dart:async';

import 'package:ai_helpdesk/data/repository/prompt/mock_prompt_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/setting/setting_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

import '../../../di/service_locator.dart';

class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
    getIt.registerSingleton<SettingRepository>(
      SettingRepositoryImpl(getIt<SharedPreferenceHelper>()),
    );

    getIt.registerSingleton<TicketRepository>(
      MockTicketRepositoryImpl(),
    );

    getIt.registerSingleton<PromptRepository>(
      MockPromptRepositoryImpl(),
    );
  }
}
