import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/draft_response_progress.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart';

class ObserveDraftProgressUseCase
    extends UseCase<Stream<DraftResponseProgress>, NoParams> {
  final ChatRepository _repository;

  ObserveDraftProgressUseCase(this._repository);

  @override
  Stream<DraftResponseProgress> call({NoParams? params}) {
    return _repository.watchDraftProgress();
  }
}
