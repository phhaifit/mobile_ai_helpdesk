import 'dart:async';

import 'package:mobile_ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/auth/change_password_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/auth/login_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/auth/logout_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/auth/register_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/auth/reset_password_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/connect_messenger_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/connect_zalo_from_qr_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/disconnect_messenger_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/disconnect_zalo_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/get_omnichannel_overview_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/retry_zalo_sync_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/sync_messenger_data_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/update_messenger_settings_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/omnichannel/update_zalo_assignments_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/repository/monetization/monetization_repository.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/monetization/get_monetization_overview_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/monetization/simulate_upgrade_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/repository/marketing/marketing_repository.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/get_marketing_overview_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/get_campaigns_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/get_templates_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/save_template_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/delete_template_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/create_campaign_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/start_campaign_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/stop_campaign_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/resume_campaign_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/estimate_audience_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/connect_facebook_admin_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/disconnect_facebook_admin_usecase.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';
import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // Auth Use Cases:-----------------------------------------------------------
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<RegisterUseCase>(
      RegisterUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<LogoutUseCase>(
      LogoutUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetCurrentUserUseCase>(
      GetCurrentUserUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<ChangePasswordUseCase>(
      ChangePasswordUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<ResetPasswordUseCase>(
      ResetPasswordUseCase(getIt<AuthRepository>()),
    );

    // use cases:---------------------------------------------------------------
    getIt.registerSingleton<GetTicketsUseCase>(
      GetTicketsUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetOmnichannelOverviewUseCase>(
      GetOmnichannelOverviewUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<ConnectMessengerUseCase>(
      ConnectMessengerUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<DisconnectMessengerUseCase>(
      DisconnectMessengerUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<SyncMessengerDataUseCase>(
      SyncMessengerDataUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<UpdateMessengerSettingsUseCase>(
      UpdateMessengerSettingsUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<ConnectZaloFromQrUseCase>(
      ConnectZaloFromQrUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<DisconnectZaloUseCase>(
      DisconnectZaloUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<RetryZaloSyncUseCase>(
      RetryZaloSyncUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<UpdateZaloAssignmentsUseCase>(
      UpdateZaloAssignmentsUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<GetMonetizationOverviewUseCase>(
      GetMonetizationOverviewUseCase(getIt<MonetizationRepository>()),
    );

    getIt.registerSingleton<SimulateUpgradeUseCase>(
      SimulateUpgradeUseCase(getIt<MonetizationRepository>()),
    );

    getIt.registerSingleton<GetMarketingOverviewUseCase>(
      GetMarketingOverviewUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<GetCampaignsUseCase>(
      GetCampaignsUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<GetTemplatesUseCase>(
      GetTemplatesUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<SaveTemplateUseCase>(
      SaveTemplateUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<DeleteTemplateUseCase>(
      DeleteTemplateUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<CreateCampaignUseCase>(
      CreateCampaignUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<StartCampaignUseCase>(
      StartCampaignUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<StopCampaignUseCase>(
      StopCampaignUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<ResumeCampaignUseCase>(
      ResumeCampaignUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<EstimateAudienceUseCase>(
      EstimateAudienceUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<ConnectFacebookAdminUseCase>(
      ConnectFacebookAdminUseCase(getIt<MarketingRepository>()),
    );
    getIt.registerSingleton<DisconnectFacebookAdminUseCase>(
      DisconnectFacebookAdminUseCase(getIt<MarketingRepository>()),
    );
  }
}
