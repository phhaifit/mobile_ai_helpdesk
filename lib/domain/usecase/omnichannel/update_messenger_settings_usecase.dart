import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:mobile_ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class UpdateMessengerSettingsUseCase
    extends UseCase<ActionFeedback, MessengerSettingsUpdate> {
  final OmnichannelRepository _repository;

  UpdateMessengerSettingsUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required MessengerSettingsUpdate params}) {
    return _repository.updateMessengerSettings(params);
  }
}
