import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

/// Opens an SSE connection and emits live status updates from the backend.
///
/// Emits: Map<sourceId, KnowledgeSourceStatus> on each event.
/// The stream completes when the server closes the connection.
class WatchSourceStatusesUseCase {
  final KnowledgeRepository _repository;

  WatchSourceStatusesUseCase(this._repository);

  Stream<Map<String, KnowledgeSourceStatus>> call() {
    return _repository.watchSourceStatuses();
  }
}
