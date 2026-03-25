import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class GetOmnichannelOverviewUseCase extends UseCase<OmnichannelOverview, void> {
  final OmnichannelRepository _repository;

  GetOmnichannelOverviewUseCase(this._repository);

  @override
  Future<OmnichannelOverview> call({required void params}) {
    return _repository.getOverview();
  }
}
