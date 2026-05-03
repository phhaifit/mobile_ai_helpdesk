import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KnowledgeSourceType.toApiType', () {
    const cases = {
      KnowledgeSourceType.web: 'web',
      KnowledgeSourceType.wholeSite: 'whole_site',
      KnowledgeSourceType.localFile: 'local_file',
      KnowledgeSourceType.googleDrive: 'google_drive',
      KnowledgeSourceType.databaseQuery: 'database_query',
    };

    cases.forEach((type, api) {
      test('$type → $api', () {
        expect(type.toApiType(), api);
      });
    });
  });

  group('KnowledgeSourceType.toWebImportType', () {
    test('web (single URL) → single_url', () {
      expect(KnowledgeSourceType.web.toWebImportType(), 'single_url');
    });
    test('wholeSite → whole_site', () {
      expect(KnowledgeSourceType.wholeSite.toWebImportType(), 'whole_site');
    });
  });

  group('knowledgeSourceTypeFromApi', () {
    const cases = {
      'web': KnowledgeSourceType.web,
      'whole_site': KnowledgeSourceType.wholeSite,
      'local_file': KnowledgeSourceType.localFile,
      'google_drive': KnowledgeSourceType.googleDrive,
      'database_query': KnowledgeSourceType.databaseQuery,
    };
    cases.forEach((raw, expected) {
      test('"$raw" → $expected', () {
        expect(knowledgeSourceTypeFromApi(raw), expected);
      });
    });
    test('unknown raw falls back to web', () {
      expect(
        knowledgeSourceTypeFromApi('???'),
        KnowledgeSourceType.web,
      );
    });
  });

  group('Status round-trip', () {
    test('every status round-trips through API', () {
      for (final s in KnowledgeSourceStatus.values) {
        final restored = knowledgeSourceStatusFromApi(s.toApiStatus());
        expect(restored, s);
      }
    });

    test('isInFlight covers pending and processing only', () {
      expect(KnowledgeSourceStatus.pending.isInFlight, isTrue);
      expect(KnowledgeSourceStatus.processing.isInFlight, isTrue);
      expect(KnowledgeSourceStatus.completed.isInFlight, isFalse);
      expect(KnowledgeSourceStatus.failed.isInFlight, isFalse);
    });
  });

  group('CrawlInterval round-trip', () {
    test('every interval round-trips through API', () {
      for (final i in CrawlInterval.values) {
        final restored = crawlIntervalFromApi(i.toApiInterval());
        expect(restored, i);
      }
    });

    test('unknown raw falls back to once', () {
      expect(crawlIntervalFromApi('HOURLY'), CrawlInterval.once);
    });
  });
}
