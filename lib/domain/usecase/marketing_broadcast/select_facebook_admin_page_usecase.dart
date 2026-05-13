import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class SelectFacebookAdminPageParams {
  final String accountId;
  final String pageId;

  const SelectFacebookAdminPageParams({
    required this.accountId,
    required this.pageId,
  });
}

class SelectFacebookAdminPageUseCase
    extends UseCase<FacebookAdAccount, SelectFacebookAdminPageParams> {
  final MarketingBroadcastRepository _repository;

  SelectFacebookAdminPageUseCase(this._repository);

  @override
  Future<FacebookAdAccount> call({
    required SelectFacebookAdminPageParams params,
  }) {
    return _repository.selectFacebookAdminPage(
      accountId: params.accountId,
      pageId: params.pageId,
    );
  }
}
