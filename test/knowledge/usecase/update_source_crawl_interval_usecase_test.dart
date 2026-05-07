import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_crawl_interval_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';
import '../helpers/knowledge_fixtures.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late UpdateSourceCrawlIntervalUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = UpdateSourceCrawlIntervalUseCase(fakeRepo);
  });

  group('UpdateSourceCrawlIntervalUseCase', () {
    test('forwards id and interval to repository', () async {
      await useCase(
        params: UpdateSourceCrawlIntervalParams(
          id: kWebSource.id,
          interval: CrawlInterval.weekly,
        ),
      );

      expect(fakeRepo.capturedUpdateIntervalId, kWebSource.id);
      expect(fakeRepo.capturedUpdateInterval, CrawlInterval.weekly);
    });

    test('supports every interval value', () async {
      for (final interval in CrawlInterval.values) {
        await useCase(
          params: UpdateSourceCrawlIntervalParams(
            id: kWebSource.id,
            interval: interval,
          ),
        );
        expect(fakeRepo.capturedUpdateInterval, interval);
      }
    });
  });
}
