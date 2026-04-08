import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/ai_agent/agent_list_screen.dart';
import 'package:ai_helpdesk/presentation/chat/support_inbox_screen.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/knowledge_source_list_screen.dart';
import 'package:ai_helpdesk/presentation/prompt/prompt_library_screen.dart';
import 'package:ai_helpdesk/presentation/monetization/monetization_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_hub_screen.dart';
import 'package:ai_helpdesk/presentation/playground/playground_screen.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final LanguageStore _languageStore = getIt<LanguageStore>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildTicketsTab(),
          const PromptLibraryScreen(embedInParent: true),
          const SupportInboxScreen(),
          _buildOmnichannelTab(),
          _buildMonetizationTab(),
          const AgentListScreen(),
          const PlaygroundScreen(),
          const KnowledgeSourceListScreen(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('home_tv_title')),
      actions: [_buildLanguageButton(), _buildThemeButton()],
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: [
          Tab(
            icon: const Icon(Icons.dashboard),
            text: AppLocalizations.of(context).translate('home_tab_dashboard'),
          ),
          Tab(
            icon: const Icon(Icons.confirmation_number),
            text: AppLocalizations.of(context).translate('home_tab_tickets'),
          ),
          Tab(
            icon: const Icon(Icons.library_books_outlined),
            text: AppLocalizations.of(context).translate('home_tab_prompts'),
          ),
          Tab(
            icon: const Icon(Icons.chat_bubble_outline),
            text: AppLocalizations.of(context).translate('home_tab_chat'),
          ),
          Tab(
            icon: const Icon(Icons.hub),
            text: AppLocalizations.of(context).translate('home_tab_omnichannel'),
          ),
          Tab(
            icon: const Icon(Icons.monetization_on_outlined),
            text: AppLocalizations.of(context).translate('home_tab_monetization'),
          ),
          const Tab(
            icon: Icon(Icons.auto_stories_outlined),
            text: 'Knowledge',
          ),
          Tab(
            icon: const Icon(Icons.workspace_premium),
            text: AppLocalizations.of(
              context,
            ).translate('monetization_tv_title'),
          ),
          Tab(
            icon: const Icon(Icons.smart_toy_outlined),
            text: AppLocalizations.of(context).translate('ai_agent_title'),
          ),
          Tab(
            icon: const Icon(Icons.psychology_outlined),
            text: AppLocalizations.of(context).translate('playground_title'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dashboard Tab
  // ---------------------------------------------------------------------------
  Widget _buildDashboardTab() {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.translate('home_tv_welcome'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard(
                'Total',
                '12',
                Icons.confirmation_number,
                Colors.blue,
              ),
              _buildStatCard('Open', '5', Icons.fiber_new, Colors.orange),
              _buildStatCard('In Progress', '4', Icons.autorenew, Colors.amber),
              _buildStatCard('Resolved', '3', Icons.check_circle, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: color),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tickets Tab
  // ---------------------------------------------------------------------------
  Widget _buildTicketsTab() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.ticketList);
        },
        child: const Text('View All Tickets'),
      ),
    );
  }

  Widget _buildOmnichannelTab() {
    return const OmnichannelHubScreen(showAppBar: false);
  }

  Widget _buildMonetizationTab() {
    return const MonetizationScreen(embedded: true);
  }

  // ---------------------------------------------------------------------------
  // App Bar Actions
  // ---------------------------------------------------------------------------
  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: Icon(
            _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _showLanguageDialog();
      },
      icon: const Icon(Icons.language),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('home_tv_choose_language'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languageStore.supportedLanguages
                .map(
                  (language) => ListTile(
                    title: Text(language.language),
                    onTap: () {
                      _languageStore.changeLanguage(language.locale);
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
