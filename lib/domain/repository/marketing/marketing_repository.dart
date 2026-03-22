import 'dart:async';

import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';

abstract class MarketingRepository {
  Future<MarketingOverview> getMarketingOverview();

  Future<List<BroadcastCampaign>> getCampaigns();

  Future<List<MarketingTemplate>> getTemplates();

  Future<TemplateSaveResult> saveTemplate(MarketingTemplate template);

  Future<TemplateSaveResult> deleteTemplate(String id);

  Future<BroadcastCampaign> createCampaign(BroadcastCampaign campaign);

  Future<CampaignActionResult> startCampaign(String id);

  Future<CampaignActionResult> stopCampaign(String id);

  Future<CampaignActionResult> resumeCampaign(String id);

  Future<CampaignRecipientTarget> estimateAudience(
      CampaignRecipientTarget target);

  Future<FacebookAdminState> connectFacebookAdmin(String accessToken);

  Future<FacebookAdminState> disconnectFacebookAdmin();
}
