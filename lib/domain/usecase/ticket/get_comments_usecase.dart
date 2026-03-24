import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class GetCommentsUseCase extends UseCase<List<Comment>, String> {
  final TicketRepository _repository;

  GetCommentsUseCase(this._repository);

  @override
  Future<List<Comment>> call({required String params}) {
    return _repository.getComments(params);
  }
}
