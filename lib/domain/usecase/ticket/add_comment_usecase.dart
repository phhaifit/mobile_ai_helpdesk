import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class AddCommentParams {
  final String ticketId;
  final Comment comment;

  AddCommentParams({required this.ticketId, required this.comment});
}

class AddCommentUseCase extends UseCase<Comment, AddCommentParams> {
  final TicketRepository _repository;

  AddCommentUseCase(this._repository);

  @override
  Future<Comment> call({required AddCommentParams params}) {
    return _repository.addComment(
      ticketId: params.ticketId,
      comment: params.comment,
    );
  }
}
