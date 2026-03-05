import '../../../domain/entity/chat/message.dart';
import '../../../domain/repository/chat/chat_repository.dart';
import '../../local/datasources/chat/chart_datasources.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChartDataSources chartDataSources;

  ChatRepositoryImpl({required this.chartDataSources});

  @override
  Future<List<Message>> getMessages() {
    return chartDataSources.getMockMessages();
  }
}
