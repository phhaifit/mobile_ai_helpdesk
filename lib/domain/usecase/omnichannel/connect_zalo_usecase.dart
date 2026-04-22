import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class ConnectZaloUseCase extends UseCase<ActionFeedback, String> {
  final OmnichannelRepository _repository;

  ConnectZaloUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required String params}) {
    return _repository.connectZalo(params);
  }
}
