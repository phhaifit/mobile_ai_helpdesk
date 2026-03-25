import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class DeleteTicketUseCase extends UseCase<void, String> {
  final TicketRepository _repository;

  DeleteTicketUseCase(this._repository);

  @override
  Future<void> call({required String params}) {
    return _repository.deleteTicket(params);
  }
}
