import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetFacebookAdminPagesParams {
  final String accountId;

  const GetFacebookAdminPagesParams({required this.accountId});
}

class GetFacebookAdminPagesUseCase
    extends UseCase<List<FacebookPage>, GetFacebookAdminPagesParams> {
  final MarketingBroadcastRepository _repository;

  GetFacebookAdminPagesUseCase(this._repository);

  @override
  Future<List<FacebookPage>> call({
    required GetFacebookAdminPagesParams params,
  }) {
    return _repository.getFacebookAdminPages(params.accountId);
  }
}
