import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class ConnectMessengerParams {
  final String? authCode;

  const ConnectMessengerParams({this.authCode});
}

class ConnectMessengerUseCase
    extends UseCase<ActionFeedback, ConnectMessengerParams?> {
  final OmnichannelRepository _repository;

  ConnectMessengerUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required ConnectMessengerParams? params}) {
    return _repository.connectMessenger(authCode: params?.authCode);
  }
}
