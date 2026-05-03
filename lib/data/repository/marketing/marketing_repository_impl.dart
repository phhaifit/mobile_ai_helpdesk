import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/core/data/network/exceptions/network_exceptions.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';
import 'package:dio/dio.dart';

class MarketingRepositoryImpl implements MarketingRepository {
  final MarketingBroadcastRepository _broadcastRepository;
  final DioClient _dioClient;

  MarketingRepositoryImpl(this._broadcastRepository, this._dioClient);

  @override
  Future<MarketingOverview> getMarketingOverview() async {
    final templates = await getTemplates();
    final campaigns = await getCampaigns();
    final accounts = await _broadcastRepository.getFacebookAdminAccounts();

    return MarketingOverview(
      campaigns: campaigns,
      templates: templates,
      facebookAdmin: _mapFacebookAdminState(accounts),
    );
  }

  @override
  Future<List<BroadcastCampaign>> getCampaigns() async {
    final templatePage = await _broadcastRepository.getBroadcastTemplates(
      query: const BroadcastTemplateQuery(offset: 0, limit: 200),
    );

    final templateChannelById = {
      for (final template in templatePage.items)
        template.id: _parseCampaignChannel(template.channel),
    };

    final campaignPage = await _broadcastRepository.getBroadcasts(
      query: const BroadcastQuery(offset: 0, limit: 200),
    );

    return campaignPage.items
        .map((item) => _mapCampaign(item, templateChannelById))
        .toList();
  }

  @override
  Future<List<MarketingTemplate>> getTemplates() async {
    final page = await _broadcastRepository.getBroadcastTemplates(
      query: const BroadcastTemplateQuery(offset: 0, limit: 200),
    );

    return page.items.map(_mapTemplate).toList();
  }

  @override
  Future<TemplateSaveResult> saveTemplate(MarketingTemplate template) async {
    final data = BroadcastTemplateUpsertData(
      name: template.name,
      content: template.content,
      category: template.category.name,
      channel: template.channel.name,
      variableKeys: template.variableKeys,
      isActive: template.isActive,
    );

    final saved =
        (template.id.isEmpty)
            ? await _broadcastRepository.createBroadcastTemplate(data)
            : await _broadcastRepository.updateBroadcastTemplate(
              templateId: template.id,
              data: data,
            );

    return TemplateSaveResult(
      isSuccess: true,
      messageKey: 'marketing_success_template_saved',
      template: _mapTemplate(saved),
    );
  }

  @override
  Future<TemplateSaveResult> deleteTemplate(String id) async {
    final success = await _broadcastRepository.deleteBroadcastTemplate(id);

    return TemplateSaveResult(
      isSuccess: success,
      messageKey:
          success
              ? 'marketing_success_template_deleted'
              : 'marketing_error_template_delete_failed',
    );
  }

  @override
  Future<BroadcastCampaign> createCampaign(BroadcastCampaign campaign) async {
    final created = await _broadcastRepository.createBroadcast(
      BroadcastUpsertData(
        name: campaign.name,
        templateId: campaign.templateId,
        scheduledAt: campaign.scheduledAt,
      ),
    );

    return _mapCampaign(created, {
      campaign.templateId: campaign.channel,
    }, fallbackTargeting: campaign.targeting);
  }

  @override
  Future<CampaignActionResult> startCampaign(String id) async {
    final item = await _broadcastRepository.executeBroadcast(id);
    return CampaignActionResult(
      campaignId: item.id,
      newStatus: _mapStatus(item.status),
      messageKey: 'marketing_success_campaign_started',
      isSuccess: true,
    );
  }

  @override
  Future<CampaignActionResult> stopCampaign(String id) async {
    final item = await _broadcastRepository.stopBroadcast(id);
    return CampaignActionResult(
      campaignId: item.id,
      newStatus: _mapStatus(item.status),
      messageKey: 'marketing_success_campaign_stopped',
      isSuccess: true,
    );
  }

  @override
  Future<CampaignActionResult> resumeCampaign(String id) async {
    final item = await _broadcastRepository.resumeBroadcast(id);
    return CampaignActionResult(
      campaignId: item.id,
      newStatus: _mapStatus(item.status),
      messageKey: 'marketing_success_campaign_resumed',
      isSuccess: true,
    );
  }

  @override
  Future<CampaignRecipientTarget> estimateAudience(
    CampaignRecipientTarget target,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        Endpoints.marketingAudienceEstimate(),
        data: {
          'filterType': target.filterType.name,
          'tagValues': target.tagValues,
          if (target.segmentValue != null && target.segmentValue!.isNotEmpty)
            'segmentValue': target.segmentValue,
          if (target.channelFilter != null)
            'channelFilter': target.channelFilter!.name,
        },
      );

      final payload = _asMap(response.data);
      final estimatedCount =
          _asInt(payload['estimatedCount']) ??
          _asInt(payload['count']) ??
          _asInt(payload['total']) ??
          0;

      return target.copyWith(estimatedCount: estimatedCount);
    } on DioException catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  @override
  Future<FacebookAdminState> connectFacebookAdmin(String accessToken) async {
    final account = await _broadcastRepository.createFacebookAdminAccount(
      FacebookAdminAccountCreateData(accessToken: accessToken),
    );
    return _toFacebookAdminState(account);
  }

  @override
  Future<FacebookAdminState> disconnectFacebookAdmin() async {
    final accounts = await _broadcastRepository.getFacebookAdminAccounts();
    if (accounts.isEmpty) {
      return const FacebookAdminState(status: FacebookAdminStatus.notConnected);
    }

    final connected = accounts.firstWhere(
      (a) => (a.status ?? '').toLowerCase() == 'connected',
      orElse: () => accounts.first,
    );

    await _broadcastRepository.disconnectFacebookAdminAccount(connected.id);
    return const FacebookAdminState(status: FacebookAdminStatus.notConnected);
  }

  MarketingTemplate _mapTemplate(BroadcastTemplate source) {
    return MarketingTemplate(
      id: source.id,
      name: source.name,
      content: source.content,
      category: _parseTemplateCategory(source.category),
      channel: _parseCampaignChannel(source.channel),
      variableKeys: source.variableKeys,
      isActive: source.isActive,
      createdAt: source.createdAt ?? DateTime.now(),
    );
  }

  BroadcastCampaign _mapCampaign(
    BroadcastItem source,
    Map<String, CampaignChannel> channelByTemplateId, {
    CampaignRecipientTarget? fallbackTargeting,
  }) {
    final targeting =
        fallbackTargeting ??
        CampaignRecipientTarget(
          filterType: RecipientFilterType.all,
          tagValues: const [],
          estimatedCount: source.recipientCount,
        );

    return BroadcastCampaign(
      id: source.id,
      name: source.name,
      templateId: source.templateId,
      status: _mapStatus(source.status),
      channel:
          channelByTemplateId[source.templateId] ?? CampaignChannel.messenger,
      targeting: targeting,
      scheduledAt: source.scheduledAt,
      startedAt: source.startedAt,
      completedAt: source.completedAt,
      sentCount: source.sentCount,
      deliveredCount: source.deliveredCount,
      failedCount: source.failedCount,
      createdAt: source.createdAt,
      errorMessage: null,
    );
  }

  FacebookAdminState _mapFacebookAdminState(List<FacebookAdAccount> accounts) {
    if (accounts.isEmpty) {
      return const FacebookAdminState(status: FacebookAdminStatus.notConnected);
    }

    final connected = accounts.firstWhere(
      (a) => (a.status ?? '').toLowerCase() == 'connected',
      orElse: () => accounts.first,
    );

    return _toFacebookAdminState(connected);
  }

  FacebookAdminState _toFacebookAdminState(FacebookAdAccount account) {
    return FacebookAdminState(
      status: _parseFacebookStatus(account.status),
      adminName: account.adminName,
      adminEmail: account.adminEmail,
      pageId: account.pageId,
      pageName: account.pageName,
      connectedAt: account.connectedAt,
    );
  }

  CampaignStatus _mapStatus(BroadcastStatus status) {
    switch (status) {
      case BroadcastStatus.draft:
        return CampaignStatus.draft;
      case BroadcastStatus.scheduled:
        return CampaignStatus.scheduled;
      case BroadcastStatus.running:
        return CampaignStatus.running;
      case BroadcastStatus.paused:
        return CampaignStatus.paused;
      case BroadcastStatus.completed:
        return CampaignStatus.completed;
      case BroadcastStatus.failed:
        return CampaignStatus.failed;
    }
  }

  CampaignChannel _parseCampaignChannel(String? raw) {
    final normalized = (raw ?? '').toLowerCase().trim();
    switch (normalized) {
      case 'zalo':
        return CampaignChannel.zalo;
      case 'email':
        return CampaignChannel.email;
      case 'sms':
        return CampaignChannel.sms;
      case 'messenger':
      case 'facebook':
      default:
        return CampaignChannel.messenger;
    }
  }

  TemplateCategory _parseTemplateCategory(String? raw) {
    final normalized = (raw ?? '').toLowerCase().trim();
    switch (normalized) {
      case 'transactional':
        return TemplateCategory.transactional;
      case 'announcement':
        return TemplateCategory.announcement;
      case 'reminder':
        return TemplateCategory.reminder;
      case 'promotional':
      default:
        return TemplateCategory.promotional;
    }
  }

  FacebookAdminStatus _parseFacebookStatus(String? raw) {
    final normalized = (raw ?? '').toLowerCase().trim();
    switch (normalized) {
      case 'connected':
      case 'active':
        return FacebookAdminStatus.connected;
      case 'connecting':
      case 'pending':
        return FacebookAdminStatus.connecting;
      case 'error':
      case 'failed':
        return FacebookAdminStatus.error;
      case 'not_connected':
      case 'disconnected':
      default:
        return FacebookAdminStatus.notConnected;
    }
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final payload = raw['data'] ?? raw['result'] ?? raw['item'];
      if (payload is Map<String, dynamic>) {
        return payload;
      }
      return raw;
    }
    return const <String, dynamic>{};
  }

  int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
