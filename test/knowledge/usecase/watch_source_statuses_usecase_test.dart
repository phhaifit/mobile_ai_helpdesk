import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/watch_source_statuses_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late WatchSourceStatusesUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = WatchSourceStatusesUseCase(fakeRepo);
  });

  group('WatchSourceStatusesUseCase', () {
    test('returns an empty stream when repository emits nothing', () async {
      fakeRepo.sseStream = Stream.empty();

      final events = await useCase().toList();

      expect(events, isEmpty);
    });

    test('forwards a single status update event', () async {
      final event = {'src-001': KnowledgeSourceStatus.active};
      fakeRepo.sseStream = Stream.value(event);

      final events = await useCase().toList();

      expect(events.length, 1);
      expect(events.first['src-001'], KnowledgeSourceStatus.active);
    });

    test('forwards multiple status update events in order', () async {
      final first = {'src-001': KnowledgeSourceStatus.indexing};
      final second = {'src-001': KnowledgeSourceStatus.active};
      fakeRepo.sseStream = Stream.fromIterable([first, second]);

      final events = await useCase().toList();

      expect(events.length, 2);
      expect(events[0]['src-001'], KnowledgeSourceStatus.indexing);
      expect(events[1]['src-001'], KnowledgeSourceStatus.active);
    });

    test('forwards error status', () async {
      final event = {'src-002': KnowledgeSourceStatus.error};
      fakeRepo.sseStream = Stream.value(event);

      final events = await useCase().toList();

      expect(events.first['src-002'], KnowledgeSourceStatus.error);
    });

    test('forwards updates for multiple sources in one event', () async {
      final event = {
        'src-001': KnowledgeSourceStatus.active,
        'src-002': KnowledgeSourceStatus.indexing,
      };
      fakeRepo.sseStream = Stream.value(event);

      final events = await useCase().toList();

      expect(events.first.length, 2);
      expect(events.first['src-001'], KnowledgeSourceStatus.active);
      expect(events.first['src-002'], KnowledgeSourceStatus.indexing);
    });
  });
}
