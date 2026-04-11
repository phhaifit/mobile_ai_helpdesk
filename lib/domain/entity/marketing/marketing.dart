// Enums
enum CampaignStatus { draft, scheduled, running, paused, completed, failed }

enum CampaignChannel { messenger, zalo, email, sms }

enum TemplateCategory { promotional, transactional, announcement, reminder }

enum RecipientFilterType { all, tag, segment, channel }

enum FacebookAdminStatus { notConnected, connecting, connected, error }

// MarketingTemplate
class MarketingTemplate {
  final String id;
  final String name;
  final String content;
  final TemplateCategory category;
  final CampaignChannel channel;
  final List<String> variableKeys;
  final bool isActive;
  final DateTime createdAt;

  const MarketingTemplate({
    required this.id,
    required this.name,
    required this.content,
    required this.category,
    required this.channel,
    required this.variableKeys,
    required this.isActive,
    required this.createdAt,
  });

  MarketingTemplate copyWith({
    String? id,
    String? name,
    String? content,
    TemplateCategory? category,
    CampaignChannel? channel,
    List<String>? variableKeys,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MarketingTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      content: content ?? this.content,
      category: category ?? this.category,
      channel: channel ?? this.channel,
      variableKeys: variableKeys ?? this.variableKeys,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// CampaignRecipientTarget
class CampaignRecipientTarget {
  final RecipientFilterType filterType;
  final List<String> tagValues;
  final String? segmentValue;
  final CampaignChannel? channelFilter;
  final int estimatedCount;

  const CampaignRecipientTarget({
    required this.filterType,
    required this.tagValues,
    required this.estimatedCount,
    this.segmentValue,
    this.channelFilter,
  });

  CampaignRecipientTarget copyWith({
    RecipientFilterType? filterType,
    List<String>? tagValues,
    String? segmentValue,
    CampaignChannel? channelFilter,
    int? estimatedCount,
  }) {
    return CampaignRecipientTarget(
      filterType: filterType ?? this.filterType,
      tagValues: tagValues ?? this.tagValues,
      segmentValue: segmentValue ?? this.segmentValue,
      channelFilter: channelFilter ?? this.channelFilter,
      estimatedCount: estimatedCount ?? this.estimatedCount,
    );
  }
}

// BroadcastCampaign
class BroadcastCampaign {
  final String id;
  final String name;
  final String templateId;
  final CampaignStatus status;
  final CampaignChannel channel;
  final CampaignRecipientTarget targeting;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int sentCount;
  final int deliveredCount;
  final int failedCount;
  final String? errorMessage;
  final DateTime createdAt;

  const BroadcastCampaign({
    required this.id,
    required this.name,
    required this.templateId,
    required this.status,
    required this.channel,
    required this.targeting,
    required this.sentCount,
    required this.deliveredCount,
    required this.failedCount,
    required this.createdAt,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.errorMessage,
  });

  BroadcastCampaign copyWith({
    String? id,
    String? name,
    String? templateId,
    CampaignStatus? status,
    CampaignChannel? channel,
    CampaignRecipientTarget? targeting,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? sentCount,
    int? deliveredCount,
    int? failedCount,
    String? errorMessage,
    DateTime? createdAt,
  }) {
    return BroadcastCampaign(
      id: id ?? this.id,
      name: name ?? this.name,
      templateId: templateId ?? this.templateId,
      status: status ?? this.status,
      channel: channel ?? this.channel,
      targeting: targeting ?? this.targeting,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      sentCount: sentCount ?? this.sentCount,
      deliveredCount: deliveredCount ?? this.deliveredCount,
      failedCount: failedCount ?? this.failedCount,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// FacebookAdminState
class FacebookAdminState {
  final FacebookAdminStatus status;
  final String? adminName;
  final String? adminEmail;
  final String? pageId;
  final String? pageName;
  final DateTime? connectedAt;

  const FacebookAdminState({
    required this.status,
    this.adminName,
    this.adminEmail,
    this.pageId,
    this.pageName,
    this.connectedAt,
  });

  FacebookAdminState copyWith({
    FacebookAdminStatus? status,
    String? adminName,
    String? adminEmail,
    String? pageId,
    String? pageName,
    DateTime? connectedAt,
  }) {
    return FacebookAdminState(
      status: status ?? this.status,
      adminName: adminName ?? this.adminName,
      adminEmail: adminEmail ?? this.adminEmail,
      pageId: pageId ?? this.pageId,
      pageName: pageName ?? this.pageName,
      connectedAt: connectedAt ?? this.connectedAt,
    );
  }
}

// MarketingOverview
class MarketingOverview {
  final List<BroadcastCampaign> campaigns;
  final List<MarketingTemplate> templates;
  final FacebookAdminState facebookAdmin;

  const MarketingOverview({
    required this.campaigns,
    required this.templates,
    required this.facebookAdmin,
  });
}

// CampaignActionResult
class CampaignActionResult {
  final String campaignId;
  final CampaignStatus newStatus;
  final String messageKey;
  final bool isSuccess;

  const CampaignActionResult({
    required this.campaignId,
    required this.newStatus,
    required this.messageKey,
    required this.isSuccess,
  });
}

// TemplateSaveResult
class TemplateSaveResult {
  final MarketingTemplate? template;
  final bool isSuccess;
  final String messageKey;

  const TemplateSaveResult({
    required this.isSuccess,
    required this.messageKey,
    this.template,
  });
}
