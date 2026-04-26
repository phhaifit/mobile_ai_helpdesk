import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // KnowledgeSourceTypeApiX.toApiImportType()
  // ---------------------------------------------------------------------------

  group('KnowledgeSourceType.toApiImportType', () {
    test('webSingle → single_url', () {
      expect(
        KnowledgeSourceType.webSingle.toApiImportType(),
        'single_url',
      );
    });

    test('webFull → whole_site', () {
      expect(
        KnowledgeSourceType.webFull.toApiImportType(),
        'whole_site',
      );
    });

    test('localFile → local_file', () {
      expect(
        KnowledgeSourceType.localFile.toApiImportType(),
        'local_file',
      );
    });

    test('googleDrive → google_drive', () {
      expect(
        KnowledgeSourceType.googleDrive.toApiImportType(),
        'google_drive',
      );
    });

    test('postgresql → database_query', () {
      expect(
        KnowledgeSourceType.postgresql.toApiImportType(),
        'database_query',
      );
    });

    test('sqlServer → database_query', () {
      expect(
        KnowledgeSourceType.sqlServer.toApiImportType(),
        'database_query',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // String.toKnowledgeSourceType()
  // ---------------------------------------------------------------------------

  group('String.toKnowledgeSourceType', () {
    test('"web" → webSingle', () {
      expect('web'.toKnowledgeSourceType(), KnowledgeSourceType.webSingle);
    });

    test('"whole_site" → webFull', () {
      expect('whole_site'.toKnowledgeSourceType(), KnowledgeSourceType.webFull);
    });

    test('"local_file" → localFile', () {
      expect(
        'local_file'.toKnowledgeSourceType(),
        KnowledgeSourceType.localFile,
      );
    });

    test('"google_drive" → googleDrive', () {
      expect(
        'google_drive'.toKnowledgeSourceType(),
        KnowledgeSourceType.googleDrive,
      );
    });

    test('"database_query" → postgresql', () {
      expect(
        'database_query'.toKnowledgeSourceType(),
        KnowledgeSourceType.postgresql,
      );
    });

    test('unknown string falls back to webSingle', () {
      expect(
        'totally_unknown'.toKnowledgeSourceType(),
        KnowledgeSourceType.webSingle,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // String.toKnowledgeSourceStatus()
  // ---------------------------------------------------------------------------

  group('String.toKnowledgeSourceStatus', () {
    test('"completed" → active', () {
      expect(
        'completed'.toKnowledgeSourceStatus(),
        KnowledgeSourceStatus.active,
      );
    });

    test('"pending" → indexing', () {
      expect(
        'pending'.toKnowledgeSourceStatus(),
        KnowledgeSourceStatus.indexing,
      );
    });

    test('"processing" → indexing', () {
      expect(
        'processing'.toKnowledgeSourceStatus(),
        KnowledgeSourceStatus.indexing,
      );
    });

    test('"failed" → error', () {
      expect(
        'failed'.toKnowledgeSourceStatus(),
        KnowledgeSourceStatus.error,
      );
    });

    test('unknown string falls back to indexing', () {
      expect(
        'some_unknown_status'.toKnowledgeSourceStatus(),
        KnowledgeSourceStatus.indexing,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // CrawlIntervalApiX.toApiInterval()
  // ---------------------------------------------------------------------------

  group('CrawlInterval.toApiInterval', () {
    test('manual → ONCE', () {
      expect(CrawlInterval.manual.toApiInterval(), 'ONCE');
    });

    test('daily → DAILY', () {
      expect(CrawlInterval.daily.toApiInterval(), 'DAILY');
    });

    test('weekly → WEEKLY', () {
      expect(CrawlInterval.weekly.toApiInterval(), 'WEEKLY');
    });

    test('monthly → MONTHLY', () {
      expect(CrawlInterval.monthly.toApiInterval(), 'MONTHLY');
    });
  });

  // ---------------------------------------------------------------------------
  // String.toCrawlInterval()
  // ---------------------------------------------------------------------------

  group('String.toCrawlInterval', () {
    test('"ONCE" → manual', () {
      expect('ONCE'.toCrawlInterval(), CrawlInterval.manual);
    });

    test('"DAILY" → daily', () {
      expect('DAILY'.toCrawlInterval(), CrawlInterval.daily);
    });

    test('"WEEKLY" → weekly', () {
      expect('WEEKLY'.toCrawlInterval(), CrawlInterval.weekly);
    });

    test('"MONTHLY" → monthly', () {
      expect('MONTHLY'.toCrawlInterval(), CrawlInterval.monthly);
    });

    test('unknown string falls back to manual', () {
      expect('HOURLY'.toCrawlInterval(), CrawlInterval.manual);
    });
  });

  // ---------------------------------------------------------------------------
  // Round-trip consistency
  // ---------------------------------------------------------------------------

  group('Round-trip: domain → API → domain', () {
    test('CrawlInterval round-trip', () {
      for (final interval in CrawlInterval.values) {
        final apiStr = interval.toApiInterval();
        final restored = apiStr.toCrawlInterval();
        expect(restored, interval, reason: '$interval did not round-trip via $apiStr');
      }
    });
  });
}
