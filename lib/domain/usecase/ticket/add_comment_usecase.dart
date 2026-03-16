import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';

class AddCommentParams {
  final String ticketId;
  final Comment comment;

  AddCommentParams({required this.ticketId, required this.comment});
}

class AddCommentUseCase extends UseCase<Comment, AddCommentParams> {
  AddCommentUseCase();

  @override
  Future<Comment> call({required AddCommentParams params}) async {
    // TODO: Implement actual comment addition when comment repository is ready
    // For now, return the comment as-is with a generated ID
    await Future.delayed(const Duration(milliseconds: 300));
    return params.comment.copyWith(id: 'comment_${DateTime.now().millisecondsSinceEpoch}');
  }
}
