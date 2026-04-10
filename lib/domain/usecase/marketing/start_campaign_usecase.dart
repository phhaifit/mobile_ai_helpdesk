import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/campaign_id_params.dart';

class StartCampaignUseCase extends UseCase<CampaignActionResult, CampaignIdParams> {
  final MarketingRepository _repository;

  StartCampaignUseCase(this._repository);

  @override
  Future<CampaignActionResult> call({required CampaignIdParams params}) {
    return _repository.startCampaign(params.id);
  }
}
