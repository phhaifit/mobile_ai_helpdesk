import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:mobile_ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class RetryZaloSyncUseCase extends UseCase<ActionFeedback, void> {
  final OmnichannelRepository _repository;

  RetryZaloSyncUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required void params}) {
    return _repository.retryZaloSync();
  }
}
