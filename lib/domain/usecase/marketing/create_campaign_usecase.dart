import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class CreateCampaignParams {
  final BroadcastCampaign campaign;

  const CreateCampaignParams({required this.campaign});
}

class CreateCampaignUseCase extends UseCase<BroadcastCampaign, CreateCampaignParams> {
  final MarketingRepository _repository;

  CreateCampaignUseCase(this._repository);

  @override
  Future<BroadcastCampaign> call({required CreateCampaignParams params}) {
    return _repository.createCampaign(params.campaign);
  }
}
