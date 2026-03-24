import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class GetTicketHistoryUseCase extends UseCase<List<TicketHistory>, String> {
  final TicketRepository _repository;

  GetTicketHistoryUseCase(this._repository);

  @override
  Future<List<TicketHistory>> call({required String params}) {
    return _repository.getTicketHistory(params);
  }
}
