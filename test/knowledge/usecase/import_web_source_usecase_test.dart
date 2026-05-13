import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_web_source_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late ImportWebSourceUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = ImportWebSourceUseCase(fakeRepo);
  });

  test('forwards url, type and interval to repository', () async {
    await useCase(
      params: const ImportWebSourceParams(
        url: 'https://example.com',
        type: KnowledgeSourceType.wholeSite,
        interval: CrawlInterval.weekly,
      ),
    );
    expect(fakeRepo.capturedImportWebArgs, {
      'url': 'https://example.com',
      'type': KnowledgeSourceType.wholeSite,
      'interval': CrawlInterval.weekly,
    });
  });
}
