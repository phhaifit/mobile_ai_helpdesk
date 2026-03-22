import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/domain/repository/marketing/marketing_repository.dart';
import 'package:mobile_ai_helpdesk/domain/usecase/marketing/campaign_id_params.dart';

class StopCampaignUseCase extends UseCase<CampaignActionResult, CampaignIdParams> {
  final MarketingRepository _repository;

  StopCampaignUseCase(this._repository);

  @override
  Future<CampaignActionResult> call({required CampaignIdParams params}) {
    return _repository.stopCampaign(params.id);
  }
}
