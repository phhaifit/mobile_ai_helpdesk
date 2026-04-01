import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class TestDbConnectionUseCase
    extends UseCase<bool, Map<String, dynamic>> {
  final KnowledgeRepository _repository;

  TestDbConnectionUseCase(this._repository);

  @override
  Future<bool> call({required Map<String, dynamic> params}) {
    return _repository.testDbConnection(params);
  }
}
