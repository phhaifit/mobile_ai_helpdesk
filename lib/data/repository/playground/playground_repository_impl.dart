import '/data/local/datasources/playground/playground_datasource.dart';
import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';

class PlaygroundRepositoryImpl implements PlaygroundRepository {
  final PlaygroundDataSource _dataSource;
  PlaygroundRepositoryImpl(this._dataSource);

  @override
  Future<List<PlaygroundSession>> getSessions() => _dataSource.getSessions();

  @override
  Future<PlaygroundSession?> getSessionById(String id) =>
      _dataSource.getSessionById(id);

  @override
  Future<PlaygroundSession> createSession(
    PlaygroundContextType contextType,
    String? agentId,
  ) =>
      _dataSource.createSession(contextType, agentId);

  @override
  Future<PlaygroundMessage> sendMessage(
    String sessionId,
    String content,
    List<String> attachments,
  ) =>
      _dataSource.sendMessage(sessionId, content, attachments);

  @override
  Future<PlaygroundMessage> editMessage(
    String sessionId,
    String messageId,
    String newContent,
  ) =>
      _dataSource.editMessage(sessionId, messageId, newContent);
}
