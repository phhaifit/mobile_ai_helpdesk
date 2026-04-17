import '/core/domain/usecase/use_case.dart';
import '/domain/repository/messenger/messenger_repository.dart';

class ConnectMessengerPageParams {
  final String pageId;
  final String accessToken;

  const ConnectMessengerPageParams({
    required this.pageId,
    required this.accessToken,
  });
}

class ConnectMessengerPageUseCase
    extends UseCase<void, ConnectMessengerPageParams> {
  final MessengerRepository _repository;

  ConnectMessengerPageUseCase(this._repository);

  @override
  Future<void> call({required ConnectMessengerPageParams params}) =>
      _repository.connectPage(params.pageId, params.accessToken);
}
