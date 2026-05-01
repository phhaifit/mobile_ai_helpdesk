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
    test('forwards a single status update event', () async {
      final event = {'src-001': KnowledgeSourceStatus.completed};
      fakeRepo.sseStream = Stream.value(event);

      final events = await useCase().toList();

      expect(events.length, 1);
      expect(events.first['src-001'], KnowledgeSourceStatus.completed);
    });

    test('forwards multiple events in order', () async {
      final first = {'src-001': KnowledgeSourceStatus.processing};
      final second = {'src-001': KnowledgeSourceStatus.completed};
      fakeRepo.sseStream = Stream.fromIterable([first, second]);

      final events = await useCase().toList();
      expect(events, hasLength(2));
      expect(events[0]['src-001'], KnowledgeSourceStatus.processing);
      expect(events[1]['src-001'], KnowledgeSourceStatus.completed);
    });

    test('forwards failed status', () async {
      fakeRepo.sseStream = Stream.value(
        {'src-002': KnowledgeSourceStatus.failed},
      );
      final events = await useCase().toList();
      expect(events.first['src-002'], KnowledgeSourceStatus.failed);
    });
  });
}
