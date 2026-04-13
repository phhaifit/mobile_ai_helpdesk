import 'chat_message.dart';

/// Request body for POST /api/v1/ai-agents/{aiAgentId}/ask
/// Maps to AskQuestionDto on the backend.
class AskQuestionRequest {
  final String question;
  final List<ChatMessage>? chatHistory;

  const AskQuestionRequest({required this.question, this.chatHistory});

  Map<String, dynamic> toJson() => {
        'question': question,
        if (chatHistory != null)
          'chatHistory': chatHistory!.map((m) => m.toJson()).toList(),
      };
}
