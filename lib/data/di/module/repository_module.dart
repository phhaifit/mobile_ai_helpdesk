import 'dart:async';

import 'package:mobile_ai_helpdesk/data/repository/invitation/mock_invitation_repository_impl.dart';
import 'package:mobile_ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:mobile_ai_helpdesk/data/network/apis/auth/auth_api.dart';
import 'package:mobile_ai_helpdesk/data/repository/auth/auth_repository_impl.dart';
import 'package:mobile_ai_helpdesk/data/repository/omnichannel/mock_omnichannel_repository_impl.dart';
import 'package:mobile_ai_helpdesk/data/repository/setting/setting_repository_impl.dart';
import 'package:mobile_ai_helpdesk/data/repository/team/mock_team_repository_impl.dart';
import 'package:mobile_ai_helpdesk/data/repository/tenant/mock_tenant_repository_impl.dart';
import 'package:mobile_ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:mobile_ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:mobile_ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:mobile_ai_helpdesk/data/repository/monetization/mock_monetization_repository_impl.dart';
import 'package:mobile_ai_helpdesk/domain/repository/monetization/monetization_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/team/team_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/customer_management/customer_repository.dart';
import 'package:get_it/get_it.dart';
import '../../local/datasources/chat/chat_datasource.dart';
import '../../local/datasources/chat/chat_room_datasource.dart';
import '../../local/datasources/customer_management/customer_datasource.dart';
import '../../repository/chat/chat_repository_impl.dart';
import '../../repository/chat/chat_room_repository_impl.dart';
import '../../repository/customer_management/customer_repository_impl.dart';

class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    final getIt = GetIt.instance;

    // Auth API:----------------------------------------------------------------
    getIt.registerSingleton<AuthApi>(AuthApi());

    // Auth Local Datasource:---------------------------------------------------
    getIt.registerSingleton<AuthLocalDatasource>(
      AuthLocalDatasource(getIt<SharedPreferenceHelper>()),
    );

    // Auth Repository:----------------------------------------------------------
    getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(getIt<AuthApi>(), getIt<AuthLocalDatasource>()),
    );

    // --- Chat Repositories ---
    getIt.registerSingleton<ChatRepository>(
      ChatRepositoryImpl(getIt<ChatDataSource>()),
    );

    getIt.registerSingleton<OmnichannelRepository>(
      MockOmnichannelRepositoryImpl(),
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


    getIt.registerSingleton<MonetizationRepository>(
      MockMonetizationRepositoryImpl(),
    );

    // --- Ticket Repository ---
    getIt.registerSingleton<TicketRepository>(MockTicketRepositoryImpl());

    // --- Tenant Repository ---
    getIt.registerSingleton<TenantRepository>(MockTenantRepositoryImpl());

    // --- Team Repository ---
    getIt.registerSingleton<TeamRepository>(MockTeamRepositoryImpl());

    // --- Invitation Repository ---
    getIt.registerSingleton<InvitationRepository>(
      MockInvitationRepositoryImpl(getIt<TeamRepository>()),
    );
  }
}
