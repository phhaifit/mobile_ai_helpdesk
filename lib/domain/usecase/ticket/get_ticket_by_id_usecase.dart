import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class GetTicketByIdUseCase extends UseCase<Ticket?, String> {
  final TicketRepository _repository;

  GetTicketByIdUseCase(this._repository);

  @override
  Future<Ticket?> call({required String params}) {
    return _repository.getTicketById(params);
  }
}
