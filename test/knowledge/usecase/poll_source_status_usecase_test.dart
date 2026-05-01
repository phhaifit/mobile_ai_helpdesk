import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/poll_source_status_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_knowledge_repository.dart';

void main() {
  late FakeKnowledgeRepository fakeRepo;
  late PollSourceStatusUseCase useCase;

  setUp(() {
    fakeRepo = FakeKnowledgeRepository();
    useCase = PollSourceStatusUseCase(fakeRepo);
  });

  test('forwards ids and returns status map', () async {
    fakeRepo.pollResult = {
      'a': KnowledgeSourceStatus.processing,
      'b': KnowledgeSourceStatus.completed,
    };
    final result = await useCase(params: ['a', 'b']);
    expect(fakeRepo.capturedPollIds, ['a', 'b']);
    expect(result['a'], KnowledgeSourceStatus.processing);
    expect(result['b'], KnowledgeSourceStatus.completed);
  });
}
