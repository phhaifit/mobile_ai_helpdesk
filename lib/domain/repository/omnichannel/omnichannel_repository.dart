import 'dart:async';

import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';

class MessengerSettingsUpdate {
  final bool autoReply;
  final String businessHours;

  const MessengerSettingsUpdate({
    required this.autoReply,
    required this.businessHours,
  });
}

class ZaloAssignmentUpdate {
  final String accountId;
  final String assignedCs;

  const ZaloAssignmentUpdate({
    required this.accountId,
    required this.assignedCs,
  });
}

abstract class OmnichannelRepository {
  Future<OmnichannelOverview> getOverview();

  Future<ActionFeedback> connectMessenger({String? authCode});

  Future<ActionFeedback> disconnectMessenger({String? channelId});

  Future<ActionFeedback> syncMessengerData();

  Future<ActionFeedback> updateMessengerSettings(
    MessengerSettingsUpdate update,
  );

  Future<ZaloQr> generateZaloQr();

  Future<ZaloQrStatusUpdate> getZaloQrStatus(String code);

  Future<ActionFeedback> connectZalo(String authCode);

  Future<ActionFeedback> disconnectZalo();

  Future<ActionFeedback> retryZaloSync();

  Future<ActionFeedback> updateZaloAssignments(
    List<ZaloAssignmentUpdate> updates,
  );
}
