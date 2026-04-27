import 'package:json_annotation/json_annotation.dart';

part 'omnichannel.g.dart';

enum IntegrationConnectionStatus { connected, disconnected, connecting, error }

enum OAuthState { verified, unverified, expired }

enum SyncState { healthy, degraded, offline }
enum ZaloQrStatus { pending, scanned, confirmed, expired }

class ZaloQr {
  final String code;
  final String url;

  const ZaloQr({
    required this.code,
    required this.url,
  });
}

class ZaloQrStatusUpdate {
  final ZaloQrStatus status;
  final String? authCode;

  const ZaloQrStatusUpdate({required this.status, this.authCode});
}

@JsonSerializable()
class ActionFeedback {
  final bool isSuccess;
  final String messageKey;

  const ActionFeedback({required this.isSuccess, required this.messageKey});

  factory ActionFeedback.fromJson(Map<String, dynamic> json) =>
      _$ActionFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$ActionFeedbackToJson(this);
}

@JsonSerializable()
class MessengerIntegrationState {
  final IntegrationConnectionStatus connectionStatus;
  final OAuthState oauthState;
  final String pageName;
  final DateTime? lastSyncAt;
  final bool autoReply;
  final String language;
  final String businessHours;

  const MessengerIntegrationState({
    required this.connectionStatus,
    required this.oauthState,
    required this.pageName,
    required this.lastSyncAt,
    required this.autoReply,
    required this.language,
    required this.businessHours,
  });

  MessengerIntegrationState copyWith({
    IntegrationConnectionStatus? connectionStatus,
    OAuthState? oauthState,
    String? pageName,
    DateTime? lastSyncAt,
    bool? autoReply,
    String? language,
    String? businessHours,
  }) {
    return MessengerIntegrationState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      oauthState: oauthState ?? this.oauthState,
      pageName: pageName ?? this.pageName,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      autoReply: autoReply ?? this.autoReply,
      language: language ?? this.language,
      businessHours: businessHours ?? this.businessHours,
    );
  }

  factory MessengerIntegrationState.fromJson(Map<String, dynamic> json) =>
      _$MessengerIntegrationStateFromJson(json);

  Map<String, dynamic> toJson() => _$MessengerIntegrationStateToJson(this);
}

@JsonSerializable()
class ZaloAccountAssignment {
  final String accountId;
  final String accountName;
  final String assignedCs;

  const ZaloAccountAssignment({
    required this.accountId,
    required this.accountName,
    required this.assignedCs,
  });

  ZaloAccountAssignment copyWith({String? assignedCs}) {
    return ZaloAccountAssignment(
      accountId: accountId,
      accountName: accountName,
      assignedCs: assignedCs ?? this.assignedCs,
    );
  }

  factory ZaloAccountAssignment.fromJson(Map<String, dynamic> json) =>
      _$ZaloAccountAssignmentFromJson(json);

  Map<String, dynamic> toJson() => _$ZaloAccountAssignmentToJson(this);
}

@JsonSerializable()
class ZaloIntegrationState {
  final IntegrationConnectionStatus connectionStatus;
  final OAuthState oauthState;
  final SyncState syncState;
  final String accountName;
  final DateTime? lastMessageSyncAt;
  final List<ZaloAccountAssignment> assignments;

  const ZaloIntegrationState({
    required this.connectionStatus,
    required this.oauthState,
    required this.syncState,
    required this.accountName,
    required this.lastMessageSyncAt,
    required this.assignments,
  });

  ZaloIntegrationState copyWith({
    IntegrationConnectionStatus? connectionStatus,
    OAuthState? oauthState,
    SyncState? syncState,
    String? accountName,
    DateTime? lastMessageSyncAt,
    List<ZaloAccountAssignment>? assignments,
  }) {
    return ZaloIntegrationState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      oauthState: oauthState ?? this.oauthState,
      syncState: syncState ?? this.syncState,
      accountName: accountName ?? this.accountName,
      lastMessageSyncAt: lastMessageSyncAt ?? this.lastMessageSyncAt,
      assignments: assignments ?? this.assignments,
    );
  }

  factory ZaloIntegrationState.fromJson(Map<String, dynamic> json) =>
      _$ZaloIntegrationStateFromJson(json);

  Map<String, dynamic> toJson() => _$ZaloIntegrationStateToJson(this);
}

@JsonSerializable()
class OmnichannelOverview {
  final MessengerIntegrationState messenger;
  final ZaloIntegrationState zalo;

  const OmnichannelOverview({required this.messenger, required this.zalo});

  OmnichannelOverview copyWith({
    MessengerIntegrationState? messenger,
    ZaloIntegrationState? zalo,
  }) {
    return OmnichannelOverview(
      messenger: messenger ?? this.messenger,
      zalo: zalo ?? this.zalo,
    );
  }

  factory OmnichannelOverview.fromJson(Map<String, dynamic> json) =>
      _$OmnichannelOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$OmnichannelOverviewToJson(this);
}
