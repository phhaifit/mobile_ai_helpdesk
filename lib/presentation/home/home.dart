import 'dart:async';

import 'package:ai_helpdesk/core/analytics/analytics_event.dart';
import 'package:ai_helpdesk/core/analytics/analytics_screen.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/presentation/chat/support_inbox_screen.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/monetization/monetization_screen.dart';
import 'package:ai_helpdesk/presentation/omnichannel/omnichannel_hub_screen.dart';
import 'package:ai_helpdesk/presentation/prompt/prompt_library_screen.dart';
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
  int _lastLoggedTabIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_onTabControllerTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _logHomeTabScreen(_tabController.index);
      }
    });
  }

  void _onTabControllerTick() {
    setState(() {});
    if (_tabController.indexIsChanging) {
      return;
    }
    _logHomeTabScreen(_tabController.index);
  }

  void _logHomeTabScreen(int index) {
    const names = <String>[
      AnalyticsScreen.dashboard,
      AnalyticsScreen.tickets,
      AnalyticsScreen.chatInbox,
      AnalyticsScreen.omnichannelTab,
      AnalyticsScreen.monetizationTab,
      AnalyticsScreen.promptTab,
    ];
    if (index < 0 || index >= names.length) {
      return;
    }
    if (index == _lastLoggedTabIndex) {
      return;
    }
    _lastLoggedTabIndex = index;
    unawaited(
      getIt<AnalyticsService>().trackScreenView(
        names[index],
        screenClass: names[index],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabControllerTick);
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
          _buildChatInboxTab(),
          const PromptLibraryScreen(embedInParent: true),
          const SupportInboxScreen(),
          _buildOmnichannelTab(),
          _buildMonetizationTab(),
          _buildPromptTab(),
        ],
      ),
      floatingActionButton: _buildCreateTicketFab(context),
    );
  }

  Widget? _buildCreateTicketFab(BuildContext context) {
    return Builder(
      builder: (context) {
        final isTicketsTab = _tabController.index == 1;
        if (!isTicketsTab) return const SizedBox.shrink();
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.createTicket);
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final l = AppLocalizations.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(l.translate('home_tv_title')),
      actions: [_buildLanguageButton(), _buildThemeButton()],
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: [
          Tab(
            icon: const Icon(Icons.dashboard),
            text: l.translate('home_tab_dashboard'),
          ),
          Tab(
            icon: const Icon(Icons.confirmation_number),
            text: l.translate('home_tab_tickets'),
          ),
          Tab(
            icon: const Icon(Icons.chat_bubble_outline),
            text: l.translate('home_tab_chat'),
          ),
          Tab(
            icon: const Icon(Icons.hub),
            text: l.translate('home_tab_omnichannel'),
          ),
          Tab(
            icon: const Icon(Icons.payments_outlined),
            text: l.translate('monetizationTitle'),
          ),
          Tab(
            icon: const Icon(Icons.library_books_outlined),
            text: l.translate('home_tab_prompt'),
          ),
        ],
      ),
    );
  }

  void _openHomeTab(int index) {
    if (!mounted || index < 0 || index >= 6) return;
    _tabController.animateTo(index);
  }

  Widget _buildDashboardTab() {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.translate('home_tv_welcome'),
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            l.translate('home_dash_section_tabs'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildDashboardTile(
            icon: Icons.confirmation_number_outlined,
            title: l.translate('home_tab_tickets'),
            subtitle: l.translate('home_dash_tab_hint'),
            onTap: () => _openHomeTab(1),
          ),
          _buildDashboardTile(
            icon: Icons.chat_bubble_outline,
            title: l.translate('home_tab_chat'),
            subtitle: l.translate('home_dash_tab_hint'),
            onTap: () => _openHomeTab(2),
          ),
          _buildDashboardTile(
            icon: Icons.hub_outlined,
            title: l.translate('home_tab_omnichannel'),
            subtitle: l.translate('home_dash_tab_hint'),
            onTap: () => _openHomeTab(3),
          ),
          _buildDashboardTile(
            icon: Icons.payments_outlined,
            title: l.translate('monetizationTitle'),
            subtitle: l.translate('home_dash_tab_hint'),
            onTap: () => _openHomeTab(4),
          ),
          _buildDashboardTile(
            icon: Icons.library_books_outlined,
            title: l.translate('home_tab_prompt'),
            subtitle: l.translate('home_dash_tab_hint'),
            onTap: () => _openHomeTab(5),
          ),
          const SizedBox(height: 16),
          Text(
            l.translate('home_dash_section_routes'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildDashboardTile(
            icon: Icons.view_list_outlined,
            title: l.translate('home_dash_ticket_workspace'),
            subtitle: l.translate('home_dash_ticket_workspace_sub'),
            onTap: () => Navigator.of(context).pushNamed(Routes.ticketList),
          ),
          _buildDashboardTile(
            icon: Icons.add_circle_outline,
            title: l.translate('home_dash_create_ticket'),
            subtitle: l.translate('home_dash_create_ticket_sub'),
            onTap: () => Navigator.of(context).pushNamed(Routes.createTicket),
          ),
          _buildDashboardTile(
            icon: Icons.hub,
            title: l.translate('home_dash_open_hub'),
            subtitle: l.translate('home_dash_open_hub_sub'),
            onTap: () => Navigator.of(context).pushNamed(Routes.omnichannelHub),
          ),
          _buildDashboardTile(
            icon: Icons.account_tree_outlined,
            title: l.translate('home_dash_messenger_dashboard'),
            subtitle: l.translate('omnichannel_messenger_dashboard_title'),
            onTap: () =>
                Navigator.of(context).pushNamed(Routes.messengerDashboard),
          ),
          _buildDashboardTile(
            icon: Icons.chat_outlined,
            title: l.translate('home_dash_zalo_overview'),
            subtitle: l.translate('omnichannel_zalo_overview_title'),
            onTap: () => Navigator.of(context).pushNamed(Routes.zaloOverview),
          ),
          _buildDashboardTile(
            icon: Icons.monetization_on_outlined,
            title: l.translate('home_dash_open_monetization'),
            subtitle: l.translate('home_dash_open_monetization_sub'),
            onTap: () => Navigator.of(context).pushNamed(Routes.monetization),
          ),
          _buildDashboardTile(
            icon: Icons.person_outline,
            title: l.translate('profile_tv_title'),
            subtitle: l.translate('profile_btn_edit'),
            onTap: () => Navigator.of(context).pushNamed(Routes.profile),
          ),
          _buildDashboardTile(
            icon: Icons.lock_outline,
            title: l.translate('profile_btn_change_password'),
            subtitle: l.translate('profile_btn_change_password'),
            onTap: () =>
                Navigator.of(context).pushNamed(Routes.changePassword),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTicketsTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 5,
            itemBuilder: (context, index) {
              final ticketId = 'TK-${1000 + index}';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const [
                      Colors.red,
                      Colors.orange,
                      Colors.amber,
                      Colors.green,
                      Colors.blue,
                    ][index],
                    radius: 6,
                  ),
                  title: Text('Ticket #${index + 1}'),
                  subtitle: Text('Mock ticket description ${index + 1}'),
                  trailing: Text(
                    ticketId,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  onTap: () async {
                    await getIt<AnalyticsService>().trackEvent(
                      AnalyticsEvent.agentUsed,
                      parameters: {
                        AnalyticsEvent.paramTicketId: ticketId,
                        AnalyticsEvent.paramAgentType: 'chatbot',
                      },
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Opened agent for $ticketId (event logged)',
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.ticketList);
            },
            child: const Text('View All Tickets'),
          ),
        ),
      ],
    );
  }

  Widget _buildOmnichannelTab() {
    return const OmnichannelHubScreen(showAppBar: false);
  }

  Widget _buildChatInboxTab() {
    return const SupportInboxScreen();
  }

  Widget _buildMonetizationTab() {
    return const MonetizationScreen(embedded: true);
  }

  Widget _buildPromptTab() {
    return const PromptLibraryScreen(embedInParent: true);
  }

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
