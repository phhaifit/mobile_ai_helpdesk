import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class EstimateAudienceParams {
  final CampaignRecipientTarget target;

  const EstimateAudienceParams({required this.target});
}

class EstimateAudienceUseCase
    extends UseCase<CampaignRecipientTarget, EstimateAudienceParams> {
  final MarketingRepository _repository;

  EstimateAudienceUseCase(this._repository);

  @override
  Future<CampaignRecipientTarget> call({
    required EstimateAudienceParams params,
  }) {
    return _repository.estimateAudience(params.target);
  }
}
