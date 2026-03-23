import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class UpdateZaloAssignmentsUseCase
    extends UseCase<ActionFeedback, List<ZaloAssignmentUpdate>> {
  final OmnichannelRepository _repository;

  UpdateZaloAssignmentsUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required List<ZaloAssignmentUpdate> params}) {
    return _repository.updateZaloAssignments(params);
  }
}
