import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';

abstract class MarketingBroadcastRepository {
  Future<BroadcastPage<BroadcastTemplate>> getBroadcastTemplates({
    required BroadcastTemplateQuery query,
  });

  Future<BroadcastTemplate> getBroadcastTemplateDetail(String templateId);

  Future<BroadcastTemplate> createBroadcastTemplate(
    BroadcastTemplateUpsertData data,
  );

  Future<BroadcastTemplate> updateBroadcastTemplate({
    required String templateId,
    required BroadcastTemplateUpsertData data,
  });

  Future<bool> deleteBroadcastTemplate(String templateId);

  Future<BroadcastPage<BroadcastItem>> getBroadcasts({
    required BroadcastQuery query,
  });

  Future<BroadcastItem> getBroadcastDetail(String broadcastId);

  Future<BroadcastItem> createBroadcast(BroadcastUpsertData data);

  Future<BroadcastItem> updateBroadcast({
    required String broadcastId,
    required BroadcastUpsertData data,
  });

  Future<bool> deleteBroadcast(String broadcastId);

  Future<BroadcastItem> executeBroadcast(String broadcastId);

  Future<BroadcastItem> stopBroadcast(String broadcastId);

  Future<BroadcastItem> resumeBroadcast(String broadcastId);

  Future<BroadcastPage<BroadcastRecipient>> getBroadcastRecipients({
    required BroadcastRecipientsQuery query,
  });

  Future<BroadcastPage<BroadcastDeliveryReceipt>> getBroadcastDeliveryReceipts({
    required String broadcastId,
    required PaginationQuery query,
  });

  Future<List<FacebookAdAccount>> getFacebookAdminAccounts();

  Future<FacebookAdAccount> createFacebookAdminAccount(
    FacebookAdminAccountCreateData data,
  );
}
