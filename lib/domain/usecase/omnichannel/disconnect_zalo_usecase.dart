import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class DisconnectZaloUseCase extends UseCase<ActionFeedback, void> {
  final OmnichannelRepository _repository;

  DisconnectZaloUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required void params}) {
    return _repository.disconnectZalo();
  }
}
