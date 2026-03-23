import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';

abstract class PromptRepository {
  List<PromptCategory> get categories;

  Future<List<Prompt>> loadPrompts({bool useNetworkDelay = true});

  Future<void> toggleFavorite(String promptId);

  /// Creates or updates a prompt. Mock impl allows editing library seeds; a real API may restrict by [Prompt.isPrivate].
  Future<void> upsertPrivatePrompt(Prompt prompt);

  Future<void> incrementUsage(String promptId);
}
