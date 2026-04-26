import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
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
    test('passes the correct id to the repository', () async {
      fakeRepo.sourcesToReturn = [kWebSource];

      await useCase(params: kWebSource.id);

      expect(fakeRepo.capturedReindexId, kWebSource.id);
    });

    test('returns the reindexed source from repository', () async {
      fakeRepo.reindexResult = kWebSource;

      final result = await useCase(params: kWebSource.id);

      expect(result.id, kWebSource.id);
      expect(result.status, kWebSource.status);
    });

    test('falls back to matching source in sourcesToReturn when reindexResult is null', () async {
      fakeRepo.reindexResult = null;
      fakeRepo.sourcesToReturn = [kWebSource];

      final result = await useCase(params: kWebSource.id);

      expect(result.id, kWebSource.id);
    });

    test('returns source with indexing status when configured as such', () async {
      final indexingSource = KnowledgeSource(
        id: kWebSource.id,
        name: kWebSource.name,
        type: kWebSource.type,
        status: KnowledgeSourceStatus.indexing,
        lastSyncAt: kTestDate,
        crawlInterval: kWebSource.crawlInterval,
        config: kWebSource.config,
      );
      fakeRepo.reindexResult = indexingSource;

      final result = await useCase(params: kWebSource.id);

      expect(result.status, KnowledgeSourceStatus.indexing);
    });

    test('completes without error', () async {
      fakeRepo.reindexResult = kWebSource;

      await expectLater(useCase(params: kWebSource.id), completes);
    });
  });
}
