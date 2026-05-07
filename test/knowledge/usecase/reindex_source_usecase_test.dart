import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';
import '../helpers/knowledge_fixtures.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late ReindexSourceUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = ReindexSourceUseCase(fakeRepo);
  });

  group('ReindexSourceUseCase', () {
    test('forwards id to repository', () async {
      await useCase(params: kWebSource.id);
      expect(fakeRepo.capturedReindexId, kWebSource.id);
    });

    test('completes without error', () async {
      await expectLater(useCase(params: kWebSource.id), completes);
    });
  });
}
