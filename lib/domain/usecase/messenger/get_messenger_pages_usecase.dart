import '/core/domain/usecase/use_case.dart';
import '/domain/entity/messenger/messenger_page.dart';
import '/domain/repository/messenger/messenger_repository.dart';

class GetMessengerPagesUseCase
    extends UseCase<List<MessengerPage>, void> {
  final MessengerRepository _repository;

  GetMessengerPagesUseCase(this._repository);

  @override
  Future<List<MessengerPage>> call({required void params}) =>
      _repository.getPages();
}
