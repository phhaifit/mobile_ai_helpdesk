import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_database_query_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late TestDatabaseQueryUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = TestDatabaseQueryUseCase(fakeRepo);
  });

  test('returns the preview produced by the repository', () async {
    fakeRepo.testDatabaseQueryResult = const DatabaseQueryPreview(
      rows: [
        {'id': 1, 'title': 'a'},
      ],
      columns: ['id', 'title'],
      message: 'ok',
    );

    final result = await useCase(
      params: const TestDatabaseQueryParams(
        query: 'SELECT 1',
        uri: 'postgresql://u:p@h:5432/db',
      ),
    );
    expect(result.rows, hasLength(1));
    expect(result.columns, ['id', 'title']);
    expect(result.message, 'ok');
    expect(fakeRepo.capturedTestDatabaseQueryArgs, {
      'query': 'SELECT 1',
      'uri': 'postgresql://u:p@h:5432/db',
    });
  });
}
