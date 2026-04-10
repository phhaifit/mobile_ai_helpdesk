import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class GetCampaignsUseCase extends UseCase<List<BroadcastCampaign>, void> {
  final MarketingRepository _repository;

  GetCampaignsUseCase(this._repository);

  @override
  Future<List<BroadcastCampaign>> call({required void params}) {
    return _repository.getCampaigns();
  }
}
