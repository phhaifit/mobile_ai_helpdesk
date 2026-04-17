import '/core/domain/usecase/use_case.dart';
import '/domain/repository/messenger/messenger_repository.dart';

class DisconnectMessengerPageUseCase extends UseCase<void, String> {
  final MessengerRepository _repository;

  DisconnectMessengerPageUseCase(this._repository);

  @override
  Future<void> call({required String params}) =>
      _repository.disconnectPage(params);
}
