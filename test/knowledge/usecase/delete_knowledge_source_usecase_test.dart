import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late DeleteKnowledgeSourceUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = DeleteKnowledgeSourceUseCase(fakeRepo);
  });

  group('DeleteKnowledgeSourceUseCase', () {
    test('passes the correct id to the repository', () async {
      const id = 'src-001';

      await useCase(params: id);

      expect(fakeRepo.capturedDeleteId, id);
    });

    test('completes without error for a valid id', () async {
      await expectLater(useCase(params: 'src-001'), completes);
    });

    test('passes a different id on a second call', () async {
      await useCase(params: 'src-001');
      await useCase(params: 'src-002');

      // Last captured id should be the one from the second call.
      expect(fakeRepo.capturedDeleteId, 'src-002');
    });

    test('returns void — completes with no value', () async {
      // DeleteKnowledgeSourceUseCase returns Future<void>; just verify it completes.
      await expectLater(useCase(params: 'src-001'), completes);
    });
  });
}
