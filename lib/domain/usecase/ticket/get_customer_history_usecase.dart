import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class GetCustomerHistoryUseCase extends UseCase<List<Ticket>, String> {
  final TicketRepository _repository;

  GetCustomerHistoryUseCase(this._repository);

  @override
  Future<List<Ticket>> call({required String params}) {
    return _repository.getCustomerHistory(params);
  }
}
