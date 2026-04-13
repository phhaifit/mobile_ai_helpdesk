/// A single message in a chat history — shared across AskQuestionDto,
/// ChatCompletionDto, and DraftResponseDto.
class ChatMessage {
  final String role;
  final String content;

  const ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}
