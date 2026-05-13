class TemplateListQuery {
  final String? search;
  final String? category;
  final String? channel;
  final int page;
  final int pageSize;

  const TemplateListQuery({
    this.search,
    this.category,
    this.channel,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toQuery() => {
    if (search != null && search!.trim().isNotEmpty) 'search': search,
    if (category != null && category!.trim().isNotEmpty) 'category': category,
    if (channel != null && channel!.trim().isNotEmpty) 'channel': channel,
    'page': page,
    'pageSize': pageSize,
  };
}

class TemplateUpsertRequest {
  final String name;
  final String content;
  final String category;
  final String channel;
  final List<String> variableKeys;
  final bool isActive;

  const TemplateUpsertRequest({
    required this.name,
    required this.content,
    required this.category,
    required this.channel,
    required this.variableKeys,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'content': content,
    'category': category,
    'channel': channel,
    'variableKeys': variableKeys,
    'isActive': isActive,
  };
}

class CampaignCreateRequest {
  final String name;
  final String templateId;
  final String channel;
  final Map<String, dynamic> targeting;
  final DateTime? scheduledAt;

  const CampaignCreateRequest({
    required this.name,
    required this.templateId,
    required this.channel,
    required this.targeting,
    this.scheduledAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'templateId': templateId,
    'channel': channel,
    'targeting': targeting,
    if (scheduledAt != null) 'scheduledAt': scheduledAt!.toIso8601String(),
  };
}

class AudienceEstimateRequest {
  final String filterType;
  final List<String> tagValues;
  final String? segmentValue;
  final String? channelFilter;

  const AudienceEstimateRequest({
    required this.filterType,
    this.tagValues = const [],
    this.segmentValue,
    this.channelFilter,
  });

  Map<String, dynamic> toJson() => {
    'filterType': filterType,
    'tagValues': tagValues,
    if (segmentValue != null && segmentValue!.trim().isNotEmpty)
      'segmentValue': segmentValue,
    if (channelFilter != null && channelFilter!.trim().isNotEmpty)
      'channelFilter': channelFilter,
  };
}

class AudienceEstimateResponse {
  final int estimatedCount;

  const AudienceEstimateResponse({required this.estimatedCount});

  factory AudienceEstimateResponse.fromJson(Map<String, dynamic> json) {
    return AudienceEstimateResponse(
      estimatedCount: (json['estimatedCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class FacebookConnectRequest {
  final String accessToken;

  const FacebookConnectRequest({required this.accessToken});

  Map<String, dynamic> toJson() => {'accessToken': accessToken};
}

class FacebookPageSummary {
  final String id;
  final String name;

  const FacebookPageSummary({required this.id, required this.name});

  factory FacebookPageSummary.fromJson(Map<String, dynamic> json) {
    return FacebookPageSummary(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class FacebookConnectionResponse {
  final String status;
  final String? adminName;
  final String? adminEmail;
  final String? pageId;
  final String? pageName;
  final DateTime? connectedAt;

  const FacebookConnectionResponse({
    required this.status,
    this.adminName,
    this.adminEmail,
    this.pageId,
    this.pageName,
    this.connectedAt,
  });

  factory FacebookConnectionResponse.fromJson(Map<String, dynamic> json) {
    return FacebookConnectionResponse(
      status: json['status'] as String? ?? 'notConnected',
      adminName: json['adminName'] as String?,
      adminEmail: json['adminEmail'] as String?,
      pageId: json['pageId'] as String?,
      pageName: json['pageName'] as String?,
      connectedAt:
          json['connectedAt'] == null
              ? null
              : DateTime.tryParse(json['connectedAt'] as String),
    );
  }
}

class DeliveryReceiptItem {
  final String recipientId;
  final String status;
  final String? channelMessageId;
  final String? errorCode;
  final String? errorMessage;
  final DateTime? sentAt;
  final DateTime? deliveredAt;

  const DeliveryReceiptItem({
    required this.recipientId,
    required this.status,
    this.channelMessageId,
    this.errorCode,
    this.errorMessage,
    this.sentAt,
    this.deliveredAt,
  });

  factory DeliveryReceiptItem.fromJson(Map<String, dynamic> json) {
    return DeliveryReceiptItem(
      recipientId: json['recipientId'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      channelMessageId: json['channelMessageId'] as String?,
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      sentAt:
          json['sentAt'] == null
              ? null
              : DateTime.tryParse(json['sentAt'] as String),
      deliveredAt:
          json['deliveredAt'] == null
              ? null
              : DateTime.tryParse(json['deliveredAt'] as String),
    );
  }
}

class DeliveryReceiptPageResponse {
  final List<DeliveryReceiptItem> items;
  final int total;
  final int page;
  final int pageSize;

  const DeliveryReceiptPageResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory DeliveryReceiptPageResponse.fromJson(Map<String, dynamic> json) {
    final rawItems =
        (json['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();

    return DeliveryReceiptPageResponse(
      items: rawItems.map(DeliveryReceiptItem.fromJson).toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
    );
  }
}

class CampaignStatusEvent {
  final String campaignId;
  final String status;
  final int sentCount;
  final int deliveredCount;
  final int failedCount;
  final DateTime occurredAt;

  const CampaignStatusEvent({
    required this.campaignId,
    required this.status,
    required this.sentCount,
    required this.deliveredCount,
    required this.failedCount,
    required this.occurredAt,
  });

  factory CampaignStatusEvent.fromJson(Map<String, dynamic> json) {
    return CampaignStatusEvent(
      campaignId: json['campaignId'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      sentCount: (json['sentCount'] as num?)?.toInt() ?? 0,
      deliveredCount: (json['deliveredCount'] as num?)?.toInt() ?? 0,
      failedCount: (json['failedCount'] as num?)?.toInt() ?? 0,
      occurredAt:
          DateTime.tryParse(json['occurredAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
