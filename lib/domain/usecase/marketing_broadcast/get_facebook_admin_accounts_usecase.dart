import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetFacebookAdminAccountsUseCase
    extends UseCase<List<FacebookAdAccount>, void> {
  final MarketingBroadcastRepository _repository;

  GetFacebookAdminAccountsUseCase(this._repository);

  @override
  Future<List<FacebookAdAccount>> call({required void params}) {
    return _repository.getFacebookAdminAccounts();
  }
}
