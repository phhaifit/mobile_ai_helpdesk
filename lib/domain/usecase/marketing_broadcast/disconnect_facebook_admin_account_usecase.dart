import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class DisconnectFacebookAdminAccountParams {
  final String accountId;

  const DisconnectFacebookAdminAccountParams({required this.accountId});
}

class DisconnectFacebookAdminAccountUseCase
    extends UseCase<bool, DisconnectFacebookAdminAccountParams> {
  final MarketingBroadcastRepository _repository;

  DisconnectFacebookAdminAccountUseCase(this._repository);

  @override
  Future<bool> call({required DisconnectFacebookAdminAccountParams params}) {
    return _repository.disconnectFacebookAdminAccount(params.accountId);
  }
}
