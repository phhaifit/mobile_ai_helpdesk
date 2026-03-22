import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class DisconnectFacebookAdminUseCase extends UseCase<FacebookAdminState, void> {
  final MarketingRepository _repository;

  DisconnectFacebookAdminUseCase(this._repository);

  @override
  Future<FacebookAdminState> call({required void params}) {
    return _repository.disconnectFacebookAdmin();
  }
}
