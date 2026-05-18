import 'chat_message.dart';

/// Request body for POST /api/v1/ai-agents/{aiAgentId}/chat-complete
/// Maps to ChatCompletionDto on the backend.
class ChatCompletionRequest {
  final String prompt;
  final List<ChatMessage> chatHistory;

  const ChatCompletionRequest({
    required this.prompt,
    required this.chatHistory,
  });

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'chatHistory': chatHistory.map((m) => m.toJson()).toList(),
      };
}
