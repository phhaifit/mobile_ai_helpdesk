enum BroadcastStatus { draft, scheduled, running, paused, completed, failed }

class PaginationQuery {
  final int offset;
  final int limit;

  const PaginationQuery({this.offset = 0, this.limit = 10});
}

class BroadcastPage<T> {
  final List<T> items;
  final int total;
  final int offset;
  final int limit;

  const BroadcastPage({
    required this.items,
    required this.total,
    required this.offset,
    required this.limit,
  });
}

class BroadcastTemplateQuery {
  final String? search;
  final String? category;
  final String? channel;
  final int offset;
  final int limit;

  const BroadcastTemplateQuery({
    this.search,
    this.category,
    this.channel,
    this.offset = 0,
    this.limit = 10,
  });
}

class BroadcastQuery {
  final BroadcastStatus? status;
  final int offset;
  final int limit;

  const BroadcastQuery({this.status, this.offset = 0, this.limit = 10});
}

class BroadcastRecipientsFilter {
  final List<String> tagValues;
  final String? segmentValue;
  final String? channel;

  const BroadcastRecipientsFilter({
    this.tagValues = const [],
    this.segmentValue,
    this.channel,
  });
}

class BroadcastRecipientsQuery {
  final String broadcastId;
  final BroadcastRecipientsFilter filter;
  final int offset;
  final int limit;

  const BroadcastRecipientsQuery({
    required this.broadcastId,
    this.filter = const BroadcastRecipientsFilter(),
    this.offset = 0,
    this.limit = 10,
  });
}

class BroadcastTemplate {
  final String id;
  final String name;
  final String content;
  final String? category;
  final String? channel;
  final List<String> variableKeys;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BroadcastTemplate({
    required this.id,
    required this.name,
    required this.content,
    required this.variableKeys,
    required this.isActive,
    this.category,
    this.channel,
    this.createdAt,
    this.updatedAt,
  });
}

class BroadcastTemplateUpsertData {
  final String name;
  final String content;
  final String? category;
  final String? channel;
  final List<String> variableKeys;
  final bool isActive;

  const BroadcastTemplateUpsertData({
    required this.name,
    required this.content,
    required this.variableKeys,
    this.category,
    this.channel,
    this.isActive = true,
  });
}

class BroadcastItem {
  final String id;
  final String name;
  final String templateId;
  final BroadcastStatus status;
  final int recipientCount;
  final int sentCount;
  final int deliveredCount;
  final int failedCount;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;

  const BroadcastItem({
    required this.id,
    required this.name,
    required this.templateId,
    required this.status,
    required this.recipientCount,
    required this.sentCount,
    required this.deliveredCount,
    required this.failedCount,
    required this.createdAt,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
  });
}

class BroadcastUpsertData {
  final String name;
  final String templateId;
  final DateTime? scheduledAt;

  const BroadcastUpsertData({
    required this.name,
    required this.templateId,
    this.scheduledAt,
  });
}

class BroadcastRecipient {
  final String id;
  final String? displayName;
  final String? channelAddress;
  final String? segmentValue;
  final List<String> tags;

  const BroadcastRecipient({
    required this.id,
    this.displayName,
    this.channelAddress,
    this.segmentValue,
    this.tags = const [],
  });
}

class BroadcastDeliveryReceipt {
  final String id;
  final String broadcastId;
  final String recipientId;
  final String status;
  final String? channelMessageId;
  final String? errorCode;
  final String? errorMessage;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? failedAt;

  const BroadcastDeliveryReceipt({
    required this.id,
    required this.broadcastId,
    required this.recipientId,
    required this.status,
    this.channelMessageId,
    this.errorCode,
    this.errorMessage,
    this.sentAt,
    this.deliveredAt,
    this.failedAt,
  });
}

class FacebookAdAccount {
  final String id;
  final String? adminName;
  final String? adminEmail;
  final String? pageId;
  final String? pageName;
  final String? status;
  final DateTime? connectedAt;

  const FacebookAdAccount({
    required this.id,
    this.adminName,
    this.adminEmail,
    this.pageId,
    this.pageName,
    this.status,
    this.connectedAt,
  });
}

class FacebookAdminAccountCreateData {
  final String accessToken;
  final String? adminName;
  final String? adminEmail;
  final String? pageId;
  final String? pageName;

  const FacebookAdminAccountCreateData({
    required this.accessToken,
    this.adminName,
    this.adminEmail,
    this.pageId,
    this.pageName,
  });
}
