import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/in_app_notification.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart';

class ObserveInAppNotificationsUseCase
    extends UseCase<Stream<InAppNotification>, NoParams> {
  final ChatRoomRepository _repository;

  ObserveInAppNotificationsUseCase(this._repository);

  @override
  Stream<InAppNotification> call({NoParams? params}) {
    return _repository.watchInAppNotifications();
  }
}
