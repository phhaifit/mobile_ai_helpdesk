import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class CreateBroadcastParams {
  final BroadcastUpsertData data;

  const CreateBroadcastParams({required this.data});
}

class CreateBroadcastUseCase
    extends UseCase<BroadcastItem, CreateBroadcastParams> {
  final MarketingBroadcastRepository _repository;

  CreateBroadcastUseCase(this._repository);

  @override
  Future<BroadcastItem> call({required CreateBroadcastParams params}) {
    return _repository.createBroadcast(params.data);
  }
}
