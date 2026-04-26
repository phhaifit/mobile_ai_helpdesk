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
    test('passes the correct id and interval to the repository', () async {
      fakeRepo.updateIntervalResult = kWebSource;

      await useCase(
        params: UpdateSourceCrawlIntervalParams(
          id: kWebSource.id,
          crawlInterval: CrawlInterval.weekly,
        ),
      );

      expect(fakeRepo.capturedUpdateIntervalId, kWebSource.id);
      expect(fakeRepo.capturedUpdateInterval, CrawlInterval.weekly);
    });

    test('returns the updated source', () async {
      fakeRepo.updateIntervalResult = kWebSource;

      final result = await useCase(
        params: UpdateSourceCrawlIntervalParams(
          id: kWebSource.id,
          crawlInterval: CrawlInterval.daily,
        ),
      );

      expect(result.id, kWebSource.id);
    });

    test('can update to manual interval', () async {
      fakeRepo.updateIntervalResult = kWebSource;

      await useCase(
        params: UpdateSourceCrawlIntervalParams(
          id: kWebSource.id,
          crawlInterval: CrawlInterval.manual,
        ),
      );

      expect(fakeRepo.capturedUpdateInterval, CrawlInterval.manual);
    });

    test('can update to monthly interval', () async {
      fakeRepo.updateIntervalResult = kWebSource;

      await useCase(
        params: UpdateSourceCrawlIntervalParams(
          id: kWebSource.id,
          crawlInterval: CrawlInterval.monthly,
        ),
      );

      expect(fakeRepo.capturedUpdateInterval, CrawlInterval.monthly);
    });

    test('falls back to matching source in sourcesToReturn when updateIntervalResult is null', () async {
      fakeRepo.updateIntervalResult = null;
      fakeRepo.sourcesToReturn = [kWebSource];

      final result = await useCase(
        params: UpdateSourceCrawlIntervalParams(
          id: kWebSource.id,
          crawlInterval: CrawlInterval.weekly,
        ),
      );

      expect(result.id, kWebSource.id);
    });
  });
}
