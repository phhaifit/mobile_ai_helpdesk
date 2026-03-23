import 'dart:async';

import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';

class MockPromptRepositoryImpl implements PromptRepository {
  MockPromptRepositoryImpl() {
    _prompts.addAll(_seedPublic);
  }

  final List<Prompt> _prompts = [];

  static const List<Prompt> _seedPublic = [
    Prompt(
      id: 'pub_greet',
      title: 'Customer greeting',
      body: 'Hello! Thank you for contacting us. How can I help you today?',
      categoryId: 'support',
      isFavorite: false,
      usageCount: 14,
      isPrivate: false,
    ),
    Prompt(
      id: 'pub_ticket_close',
      title: 'Ticket resolution summary',
      body:
          'Here is a summary of the steps we took to resolve your ticket. Please let us know if anything else comes up.',
      categoryId: 'support',
      isFavorite: true,
      usageCount: 9,
      isPrivate: false,
    ),
    Prompt(
      id: 'pub_sales_intro',
      title: 'Product introduction',
      body:
          'I would love to walk you through our plan options and find the best fit for your team.',
      categoryId: 'sales',
      isFavorite: false,
      usageCount: 6,
      isPrivate: false,
    ),
    Prompt(
      id: 'pub_sales_followup',
      title: 'Follow-up after demo',
      body:
          'Thanks for your time today. I am sharing the recap and next steps we discussed.',
      categoryId: 'sales',
      isFavorite: false,
      usageCount: 3,
      isPrivate: false,
    ),
    Prompt(
      id: 'pub_tech_debug',
      title: 'API troubleshooting',
      body:
          'Could you share the request ID, timestamp, and endpoint so we can trace the error in our logs?',
      categoryId: 'technical',
      isFavorite: false,
      usageCount: 21,
      isPrivate: false,
    ),
    Prompt(
      id: 'pub_general_thanks',
      title: 'Thank you note',
      body: 'We appreciate your patience and your business. Have a great day!',
      categoryId: 'general',
      isFavorite: false,
      usageCount: 11,
      isPrivate: false,
    ),
  ];

  @override
  List<PromptCategory> get categories => const [
        PromptCategory(id: 'all', nameKey: 'prompt_cat_all'),
        PromptCategory(id: 'support', nameKey: 'prompt_cat_support'),
        PromptCategory(id: 'sales', nameKey: 'prompt_cat_sales'),
        PromptCategory(id: 'technical', nameKey: 'prompt_cat_technical'),
        PromptCategory(id: 'general', nameKey: 'prompt_cat_general'),
      ];

  @override
  Future<List<Prompt>> loadPrompts({bool useNetworkDelay = true}) async {
    if (useNetworkDelay) {
      await Future.delayed(const Duration(milliseconds: 320));
    }
    return List<Prompt>.unmodifiable(_prompts);
  }

  @override
  Future<void> toggleFavorite(String promptId) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final i = _prompts.indexWhere((p) => p.id == promptId);
    if (i < 0) {
      return;
    }
    final p = _prompts[i];
    _prompts[i] = p.copyWith(isFavorite: !p.isFavorite);
  }

  @override
  Future<void> upsertPrivatePrompt(Prompt prompt) async {
    await Future.delayed(const Duration(milliseconds: 120));
    if (prompt.id.isEmpty) {
      final id = 'priv_${DateTime.now().millisecondsSinceEpoch}';
      _prompts.add(
        prompt.copyWith(id: id, isPrivate: true),
      );
      return;
    }
    final i = _prompts.indexWhere((p) => p.id == prompt.id);
    if (i >= 0) {
      _prompts[i] = prompt;
    } else {
      _prompts.add(prompt);
    }
  }

  @override
  Future<void> incrementUsage(String promptId) async {
    final i = _prompts.indexWhere((p) => p.id == promptId);
    if (i < 0) {
      return;
    }
    final p = _prompts[i];
    _prompts[i] = p.copyWith(usageCount: p.usageCount + 1);
  }
}
