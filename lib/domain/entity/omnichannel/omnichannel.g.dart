// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omnichannel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionFeedback _$ActionFeedbackFromJson(Map<String, dynamic> json) =>
    ActionFeedback(
      isSuccess: json['isSuccess'] as bool,
      messageKey: json['messageKey'] as String,
    );

Map<String, dynamic> _$ActionFeedbackToJson(ActionFeedback instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'messageKey': instance.messageKey,
    };

MessengerIntegrationState _$MessengerIntegrationStateFromJson(
  Map<String, dynamic> json,
) => MessengerIntegrationState(
  connectionStatus: $enumDecode(
    _$IntegrationConnectionStatusEnumMap,
    json['connectionStatus'],
  ),
  oauthState: $enumDecode(_$OAuthStateEnumMap, json['oauthState']),
  pageName: json['pageName'] as String,
  lastSyncAt:
      json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
  syncedCustomers: (json['syncedCustomers'] as num).toInt(),
  failedCustomers: (json['failedCustomers'] as num).toInt(),
  autoReply: json['autoReply'] as bool,
  language: json['language'] as String,
  businessHours: json['businessHours'] as String,
);

Map<String, dynamic> _$MessengerIntegrationStateToJson(
  MessengerIntegrationState instance,
) => <String, dynamic>{
  'connectionStatus':
      _$IntegrationConnectionStatusEnumMap[instance.connectionStatus]!,
  'oauthState': _$OAuthStateEnumMap[instance.oauthState]!,
  'pageName': instance.pageName,
  'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
  'syncedCustomers': instance.syncedCustomers,
  'failedCustomers': instance.failedCustomers,
  'autoReply': instance.autoReply,
  'language': instance.language,
  'businessHours': instance.businessHours,
};

const _$IntegrationConnectionStatusEnumMap = {
  IntegrationConnectionStatus.connected: 'connected',
  IntegrationConnectionStatus.disconnected: 'disconnected',
  IntegrationConnectionStatus.connecting: 'connecting',
  IntegrationConnectionStatus.error: 'error',
};

const _$OAuthStateEnumMap = {
  OAuthState.verified: 'verified',
  OAuthState.unverified: 'unverified',
  OAuthState.expired: 'expired',
};

ZaloAccountAssignment _$ZaloAccountAssignmentFromJson(
  Map<String, dynamic> json,
) => ZaloAccountAssignment(
  accountId: json['accountId'] as String,
  accountName: json['accountName'] as String,
  assignedCs: json['assignedCs'] as String,
);

Map<String, dynamic> _$ZaloAccountAssignmentToJson(
  ZaloAccountAssignment instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'accountName': instance.accountName,
  'assignedCs': instance.assignedCs,
};

ZaloIntegrationState _$ZaloIntegrationStateFromJson(
  Map<String, dynamic> json,
) => ZaloIntegrationState(
  connectionStatus: $enumDecode(
    _$IntegrationConnectionStatusEnumMap,
    json['connectionStatus'],
  ),
  oauthState: $enumDecode(_$OAuthStateEnumMap, json['oauthState']),
  syncState: $enumDecode(_$SyncStateEnumMap, json['syncState']),
  accountName: json['accountName'] as String,
  lastMessageSyncAt:
      json['lastMessageSyncAt'] == null
          ? null
          : DateTime.parse(json['lastMessageSyncAt'] as String),
  assignments:
      (json['assignments'] as List<dynamic>)
          .map((e) => ZaloAccountAssignment.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ZaloIntegrationStateToJson(
  ZaloIntegrationState instance,
) => <String, dynamic>{
  'connectionStatus':
      _$IntegrationConnectionStatusEnumMap[instance.connectionStatus]!,
  'oauthState': _$OAuthStateEnumMap[instance.oauthState]!,
  'syncState': _$SyncStateEnumMap[instance.syncState]!,
  'accountName': instance.accountName,
  'lastMessageSyncAt': instance.lastMessageSyncAt?.toIso8601String(),
  'assignments': instance.assignments,
};

const _$SyncStateEnumMap = {
  SyncState.healthy: 'healthy',
  SyncState.degraded: 'degraded',
  SyncState.offline: 'offline',
};

OmnichannelOverview _$OmnichannelOverviewFromJson(Map<String, dynamic> json) =>
    OmnichannelOverview(
      messenger: MessengerIntegrationState.fromJson(
        json['messenger'] as Map<String, dynamic>,
      ),
      zalo: ZaloIntegrationState.fromJson(json['zalo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OmnichannelOverviewToJson(
  OmnichannelOverview instance,
) => <String, dynamic>{'messenger': instance.messenger, 'zalo': instance.zalo};
