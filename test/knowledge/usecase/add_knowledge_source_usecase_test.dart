import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/add_knowledge_source_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';
import '../helpers/knowledge_fixtures.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late AddKnowledgeSourceUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = AddKnowledgeSourceUseCase(fakeRepo);
  });

  group('AddKnowledgeSourceUseCase', () {
    test('passes the source to the repository', () async {
      fakeRepo.addSourceResult = kWebSource;

      await useCase(params: kWebSource);

      expect(fakeRepo.capturedAddSource, kWebSource);
    });

    test('returns the source from repository', () async {
      fakeRepo.addSourceResult = kWebSource;

      final result = await useCase(params: kWebSource);

      expect(result.id, kWebSource.id);
      expect(result.name, kWebSource.name);
    });

    test('returns whatever the repository echoes when addSourceResult is null', () async {
      // addSourceResult defaults to null → FakeKnowledgeRepository returns params
      fakeRepo.addSourceResult = null;

      final result = await useCase(params: kWebSource);

      expect(result, kWebSource);
    });

    test('works for webFull type', () async {
      fakeRepo.addSourceResult = kWebFullSource;

      final result = await useCase(params: kWebFullSource);

      expect(result.type, KnowledgeSourceType.webFull);
    });

    test('captured source matches what was passed', () async {
      final source = kWebSource;

      await useCase(params: source);

      expect(fakeRepo.capturedAddSource?.id, source.id);
      expect(fakeRepo.capturedAddSource?.type, source.type);
      expect(fakeRepo.capturedAddSource?.crawlInterval, source.crawlInterval);
      expect(fakeRepo.capturedAddSource?.config, source.config);
    });
  });
}
