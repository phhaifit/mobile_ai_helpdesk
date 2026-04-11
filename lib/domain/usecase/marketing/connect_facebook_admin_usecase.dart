import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class ConnectFacebookAdminParams {
  final String accessToken;

  const ConnectFacebookAdminParams({required this.accessToken});
}

class ConnectFacebookAdminUseCase
    extends UseCase<FacebookAdminState, ConnectFacebookAdminParams> {
  final MarketingRepository _repository;

  ConnectFacebookAdminUseCase(this._repository);

  @override
  Future<FacebookAdminState> call({
    required ConnectFacebookAdminParams params,
  }) {
    return _repository.connectFacebookAdmin(params.accessToken);
  }
}
