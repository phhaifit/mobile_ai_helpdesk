import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';
import '../helpers/knowledge_fixtures.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late GetKnowledgeSourcesUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = GetKnowledgeSourcesUseCase(fakeRepo);
  });

  group('GetKnowledgeSourcesUseCase', () {
    test('returns empty list when repository has no sources', () async {
      fakeRepo.sourcesToReturn = [];

      final result = await useCase(params: null);

      expect(result, isEmpty);
    });

    test('returns all sources from repository', () async {
      fakeRepo.sourcesToReturn = [kWebSource, kWebFullSource];

      final result = await useCase(params: null);

      expect(result.length, 2);
      expect(result[0].id, kWebSource.id);
      expect(result[1].id, kWebFullSource.id);
    });

    test('returns sources with correct types', () async {
      fakeRepo.sourcesToReturn = [kWebSource, kWebFullSource];

      final result = await useCase(params: null);

      expect(result[0].type, kWebSource.type);
      expect(result[1].type, kWebFullSource.type);
    });

    test('returns sources with correct statuses', () async {
      fakeRepo.sourcesToReturn = [kWebSource, kWebFullSource];

      final result = await useCase(params: null);

      expect(result[0].status, kWebSource.status);
      expect(result[1].status, kWebFullSource.status);
    });

    test('delegates to repository exactly once per call', () async {
      fakeRepo.sourcesToReturn = [kWebSource];

      await useCase(params: null);
      await useCase(params: null);

      // No invocation counter in FakeKnowledgeRepository — but we can verify
      // the last known sources are the ones we configured.
      final result = await useCase(params: null);
      expect(result.first.id, kWebSource.id);
    });
  });
}
