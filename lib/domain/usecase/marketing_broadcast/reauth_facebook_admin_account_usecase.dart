import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class ReauthFacebookAdminAccountParams {
  final String accountId;
  final String accessToken;

  const ReauthFacebookAdminAccountParams({
    required this.accountId,
    required this.accessToken,
  });
}

class ReauthFacebookAdminAccountUseCase
    extends UseCase<FacebookAdAccount, ReauthFacebookAdminAccountParams> {
  final MarketingBroadcastRepository _repository;

  ReauthFacebookAdminAccountUseCase(this._repository);

  @override
  Future<FacebookAdAccount> call({
    required ReauthFacebookAdminAccountParams params,
  }) {
    return _repository.reauthFacebookAdminAccount(
      accountId: params.accountId,
      accessToken: params.accessToken,
    );
  }
}
