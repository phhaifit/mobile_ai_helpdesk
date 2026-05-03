import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class CreateFacebookAdminAccountParams {
  final FacebookAdminAccountCreateData data;

  const CreateFacebookAdminAccountParams({required this.data});
}

class CreateFacebookAdminAccountUseCase
    extends UseCase<FacebookAdAccount, CreateFacebookAdminAccountParams> {
  final MarketingBroadcastRepository _repository;

  CreateFacebookAdminAccountUseCase(this._repository);

  @override
  Future<FacebookAdAccount> call({
    required CreateFacebookAdminAccountParams params,
  }) {
    return _repository.createFacebookAdminAccount(params.data);
  }
}
