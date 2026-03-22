import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:mobile_ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class ConnectZaloFromQrUseCase extends UseCase<ActionFeedback, void> {
  final OmnichannelRepository _repository;

  ConnectZaloFromQrUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required void params}) {
    return _repository.connectZaloFromQr();
  }
}
