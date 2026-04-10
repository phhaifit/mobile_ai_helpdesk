import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class DisconnectMessengerUseCase extends UseCase<ActionFeedback, void> {
  final OmnichannelRepository _repository;

  DisconnectMessengerUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required void params}) {
    return _repository.disconnectMessenger();
  }
}
