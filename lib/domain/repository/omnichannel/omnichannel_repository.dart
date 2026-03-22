import 'dart:async';

import 'package:mobile_ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';

class MessengerSettingsUpdate {
  final bool autoReply;
  final String language;
  final String businessHours;

  const MessengerSettingsUpdate({
    required this.autoReply,
    required this.language,
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

  Future<ActionFeedback> connectMessenger();

  Future<ActionFeedback> disconnectMessenger();

  Future<ActionFeedback> syncMessengerData();

  Future<ActionFeedback> updateMessengerSettings(
    MessengerSettingsUpdate update,
  );

  Future<ActionFeedback> connectZaloFromQr();

  Future<ActionFeedback> disconnectZalo();

  Future<ActionFeedback> retryZaloSync();

  Future<ActionFeedback> updateZaloAssignments(
    List<ZaloAssignmentUpdate> updates,
  );
}
