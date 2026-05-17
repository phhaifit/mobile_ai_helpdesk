import 'dart:async';
import 'dart:developer' as developer;

import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/data/realtime/socket/socket_service.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/presentation/chat/store/chat_room_store.dart';
import 'package:ai_helpdesk/presentation/tenant/create_tenant_screen.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../constants/colors.dart';
import 'ai_agent/agent_list_screen.dart';
import 'chat/store/chat_store.dart';
import 'chat/support_inbox_screen.dart';
import 'customer/screens/customer_main_screen.dart';
import 'knowledge/knowledge_source_list_screen.dart';
import 'marketing/campaign_list_screen.dart';
import 'marketing/facebook_admin_setup_screen.dart';
import 'marketing/template_library_screen.dart';
import 'monetization/monetization_screen.dart';
import 'omnichannel/omnichannel_hub_screen.dart';
import 'playground/playground_screen.dart';
import 'prompt/prompt_library_screen.dart';
import 'tenant/employee_screen.dart';
import 'tenant/tenant_info_screen.dart';
import 'ticket/screens/ticket_list_screen.dart';
import 'widgets/sidebar_menu_panel.dart';
import 'widgets/tenant_switcher.dart';

class MainScreen extends StatefulWidget {
  final String initialCategory;

  const MainScreen({super.key, this.initialCategory = 'support_inbox'});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const String _logName = 'MainScreen';

  late String _selectedCategory;
  bool _showSidebarMobile = false;

  List<MenuCategory> _categories = const [];
  bool _categoriesInitialized = false;

  final SocketService _socketService = getIt<SocketService>();
  final ChatStore _chatStore = getIt<ChatStore>();
  final AuthStore _authStore = getIt<AuthStore>();
  final TenantStore _tenantStore = getIt<TenantStore>();

  /// Tenant id for which [SocketService.connect] completed without throwing.
  /// Used to skip redundant reconnects when [TenantStore.currentTenant] matches.
  /// Left null after a failed connect so a later workspace change can retry.
  String? _chatRealtimeTenantId;

  ReactionDisposer? _tenantChatReaction;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    developer.log('bootstrap: loadTenants', name: _logName);
    await _tenantStore.loadTenants();
    if (!mounted) {
      developer.log('bootstrap: aborted (unmounted after loadTenants)', name: _logName);
      return;
    }
    developer.log('bootstrap: initRealtime', name: _logName);
    await _initRealtime();
    if (!mounted) {
      developer.log('bootstrap: aborted (unmounted after initRealtime)', name: _logName);
      return;
    }
    // Register only after initial realtime so the first [loadTenants] selection
    // does not race [_initRealtime] (duplicate disconnect/connect + double inbox fetch).
    _tenantChatReaction = reaction(
      (_) => _tenantStore.currentTenant?.id,
      (String? tenantId) {
        if (!_authStore.isAuthenticated) {
          return;
        }
        if (tenantId == _chatRealtimeTenantId) {
          developer.log(
            'tenant reaction: skip (already synced) tenantId=$tenantId',
            name: _logName,
          );
          return;
        }
        developer.log(
          'tenant reaction: context change tenantId=$tenantId '
          'previousRealtimeTenantId=$_chatRealtimeTenantId',
          name: _logName,
        );
        unawaited(_onTenantContextChanged(tenantId));
      },
    );
    developer.log('bootstrap: tenant reaction registered', name: _logName);
    final String? currentId = _tenantStore.currentTenant?.id;
    if (_authStore.isAuthenticated &&
        currentId != null &&
        currentId.isNotEmpty &&
        _chatRealtimeTenantId == null) {
      // MobX reaction does not run until a tracked change; retry once if bootstrap connect failed.
      developer.log(
        'bootstrap: retry tenant context (init connect had no socket) tenantId=$currentId',
        name: _logName,
      );
      unawaited(_onTenantContextChanged(currentId));
    }
    developer.log(
      'bootstrap: done chatRealtimeTenantId=$_chatRealtimeTenantId',
      name: _logName,
    );
  }

  Future<void> _openCreateTenantFlow(BuildContext context) async {
    final int tenantCountBeforeCreate = _tenantStore.tenantList.length;
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const CreateTenantScreen(),
        fullscreenDialog: true,
      ),
    );
    await _refreshTenantsAfterCreate(tenantCountBeforeCreate);
  }

  Future<void> _refreshTenantsAfterCreate(int previousCount) async {
    if (_tenantStore.tenantList.length > previousCount) {
      return;
    }

    const List<Duration> retryDelays = <Duration>[
      Duration.zero,
      Duration(milliseconds: 500),
      Duration(milliseconds: 1200),
    ];

    for (int i = 0; i < retryDelays.length; i++) {
      final Duration delay = retryDelays[i];
      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }

      await _tenantStore.loadTenants();

      if (_tenantStore.tenantList.length > previousCount) {
        return;
      }
    }
  }

  Widget _buildTenantSwitcher() {
    return Observer(
      builder: (_) {
        return TenantSwitcher(
          tenants: _tenantStore.tenantList.toList(),
          selectedTenant: _tenantStore.currentTenant,
          isLoading: _tenantStore.isLoading,
          onTenantChanged: (String tenantId) {
            unawaited(_tenantStore.switchTenant(tenantId));
          },
          onCreateTenant: _openCreateTenantFlow,
        );
      },
    );
  }

  /// Refetch rooms, clear message cache, and move the socket to the new
  /// tenant namespace when the selected tenant changes.
  Future<void> _onTenantContextChanged(String? tenantId) async {
    developer.log(
      'onTenantContextChanged: start tenantId=$tenantId',
      name: _logName,
    );
    final ChatRoomStore chatRoomStore = getIt<ChatRoomStore>();
    if (tenantId == null || tenantId.isEmpty) {
      developer.log(
        'onTenantContextChanged: clearing workspace (no tenant)',
        name: _logName,
      );
      await _socketService.disconnect();
      await _chatStore.dispose();
      _chatStore.resetAfterTenantSwitch();
      chatRoomStore.clearRooms();
      _chatRealtimeTenantId = null;
      return;
    }

    await _socketService.disconnect();
    await _chatStore.dispose();
    _chatStore.resetAfterTenantSwitch();
    await chatRoomStore.fetchChatRooms();
    final int roomCount = chatRoomStore.chatRooms.length;
    developer.log(
      'onTenantContextChanged: rooms loaded count=$roomCount tenantId=$tenantId',
      name: _logName,
    );

    try {
      await _socketService.connect(tenantId: tenantId);
      _chatRealtimeTenantId = tenantId;
      developer.log(
        'onTenantContextChanged: connect ok tenantId=$tenantId '
        'socketConnected=${_socketService.isConnected} socketId=${_socketService.socketId}',
        name: _logName,
      );
    } catch (e, s) {
      _chatRealtimeTenantId = null;
      await _chatStore.dispose();
      developer.log(
        'onTenantContextChanged: connect failed tenantId=$tenantId',
        name: _logName,
        error: e,
        stackTrace: s,
      );
    }
    final Iterable<String> roomIds = chatRoomStore.chatRooms.map((room) => room.id);
    await _chatStore.prefetchMessagesForRooms(roomIds);
    developer.log(
      'onTenantContextChanged: prefetch done roomCount=${roomIds.length} '
      'chatRealtimeTenantId=$_chatRealtimeTenantId',
      name: _logName,
    );
  }

  /// Establish the tenant-scoped socket connection and route inbound chat
  /// messages into [ChatStore]. Run from [_bootstrap] after [TenantStore.loadTenants]
  /// so the tenant id matches HTTP headers; the tenant MobX reaction is registered afterward.
  Future<void> _initRealtime() async {
    if (!_authStore.isAuthenticated) {
      developer.log('initRealtime: skip (not authenticated)', name: _logName);
      return;
    }

    final String tenantId = await _resolveInitialRealtimeTenantId();
    developer.log(
      'initRealtime: resolved tenantId=$tenantId',
      name: _logName,
    );

    try {
      await _socketService.connect(tenantId: tenantId);
      _chatRealtimeTenantId = tenantId;
      developer.log(
        'initRealtime: connect ok tenantId=$tenantId '
        'socketConnected=${_socketService.isConnected} socketId=${_socketService.socketId}',
        name: _logName,
      );
    } catch (e, s) {
      await _chatStore.dispose();
      developer.log(
        'initRealtime: connect failed tenantId=$tenantId',
        name: _logName,
        error: e,
        stackTrace: s,
      );
    }
  }

  /// Matches HTTP ([TenantHeaderInterceptor]): prefer in-memory selection, then
  /// persisted last workspace ([TenantRepository.getCachedTenantId]), then
  /// account default — [TenantStore.currentTenant] is often still null on cold
  /// start before [TenantStore.loadTenants] completes.
  Future<String> _resolveInitialRealtimeTenantId() async {
    final TenantStore tenantStore = getIt<TenantStore>();
    final String? fromStore = tenantStore.currentTenant?.id;
    if (fromStore != null && fromStore.isNotEmpty) {
      return fromStore;
    }

    final String? cached =
        await getIt<TenantRepository>().getCachedTenantId();
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    return _authStore.account?.tenantId ?? SentryService.defaultTenantId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_categoriesInitialized) return;
    _categoriesInitialized = true;
    _initializeCategories();

    // If initialCategory is a category title (e.g. 'Hỗ trợ khách hàng'),
    // default to the first menu item inside that category. Otherwise use
    // the provided initialCategory (which may already be a menu item).
    final String initial = widget.initialCategory;
    final matchingCategory = _categories.firstWhere(
      (c) => c.title == initial,
      orElse:
          () => MenuCategory(
            title: '',
            icon: Icons.help_outline_rounded,
            items: [],
          ),
    );

    if (matchingCategory.items.isNotEmpty) {
      _selectedCategory = matchingCategory.items.first.title;
    } else {
      _selectedCategory = initial;
    }
  }

  void _initializeCategories() {
    _categories = [
      MenuCategory(
        title: 'Tổng quan',
        icon: Icons.dashboard_outlined,
        items: [
          MenuItem(
            id: 'dashboard',
            title: 'Dashboard',
            onTap: () => _selectCategory('dashboard'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Hỗ trợ khách hàng',
        icon: Icons.confirmation_number_outlined,
        items: [
          MenuItem(
            id: 'support_inbox',
            title: 'Hộp thư hỗ trợ',
            onTap: () => _selectCategory('support_inbox'),
          ),
          MenuItem(
            id: 'pending_tickets',
            title: 'Phiếu chưa xử lý',
            onTap: () => _selectCategory('pending_tickets'),
          ),
          MenuItem(
            id: 'ai_chat_bot',
            title: 'AI Chat Bot',
            onTap: () => _selectCategory('ai_chat_bot'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Khách hàng & Đơn hàng',
        icon: Icons.people_outline_rounded,
        items: [
          MenuItem(
            id: 'customers',
            title: 'Khách hàng',
            onTap: () => _selectCategory('customers'),
          ),
          MenuItem(
            id: 'orders',
            title: 'Đơn hàng',
            onTap: () => _selectCategory('orders'),
          ),
          MenuItem(
            id: 'products',
            title: 'Sản phẩm',
            onTap: () => _selectCategory('products'),
          ),
          MenuItem(
            id: 'promotions',
            title: 'Khuyến mãi & Vòng quay',
            onTap: () => _selectCategory('promotions'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Công cụ AI',
        icon: Icons.library_books_outlined,
        items: [
          MenuItem(
            id: 'prompt_library',
            title: 'Prompt Library',
            onTap: () => _selectCategory('prompt_library'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Marketing',
        icon: Icons.campaign_outlined,
        items: [
          MenuItem(
            id: Routes.campaignList,
            title: 'Chiến dịch',
            onTap: () => _selectCategory(Routes.campaignList),
          ),
          MenuItem(
            id: Routes.templateLibrary,
            title: 'Template',
            onTap: () => _selectCategory(Routes.templateLibrary),
          ),
        ],
      ),
      MenuCategory(
        title: 'Cài đặt',
        icon: Icons.settings_outlined,
        items: [
          MenuItem(
            id: 'tenant_info',
            title: 'Thông tin doanh nghiệp',
            onTap: () => _selectCategory('tenant_info'),
          ),
          MenuItem(
            id: 'employee_list',
            title: 'Nhân viên',
            onTap: () => _selectCategory('employee_list'),
          ),
          MenuItem(
            id: 'omnichannel',
            title: 'Kênh tích hợp',
            onTap: () => _selectCategory('omnichannel'),
          ),
          MenuItem(
            id: 'channel_permission',
            title: 'Phân quyền kênh',
            onTap: () => _selectCategory('channel_permission'),
          ),
          MenuItem(
            id: 'payment',
            title: 'Thanh toán',
            onTap: () => _selectCategory('payment'),
          ),
          MenuItem(
            id: Routes.templateLibrary,
            title: 'Template',
            onTap: () => _selectCategory(Routes.templateLibrary),
          ),
          MenuItem(
            id: Routes.facebookAdminSetup,
            title: 'Facebook Admin',
            onTap: () => _selectCategory(Routes.facebookAdminSetup),
          ),
        ],
      ),
      MenuCategory(
        title: 'Báo cáo & Thống kê',
        icon: Icons.bar_chart_outlined,
        items: [
          MenuItem(
            id: 'detailed_reports',
            title: 'Báo cáo chi tiết',
            onTap: () => _selectCategory('detailed_reports'),
          ),
          MenuItem(
            id: 'status_reports',
            title: 'Thống kê theo trạng thái',
            onTap: () => _selectCategory('status_reports'),
          ),
        ],
      ),
      MenuCategory(
        title: 'AI & Playground',
        icon: Icons.smart_toy_outlined,
        items: [
          MenuItem(
            id: 'ai_agents',
            title: 'AI Agents',
            onTap: () => _selectCategory('ai_agents'),
          ),
          MenuItem(
            id: 'playground',
            title: 'Playground',
            onTap: () => _selectCategory('playground'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Gói dịch vụ',
        icon: Icons.monetization_on_outlined,
        items: [
          MenuItem(
            id: 'monetization',
            title: 'Monetization',
            onTap: () => _selectCategory('monetization'),
          ),
        ],
      ),
      MenuCategory(
        title: 'Cấu hình Trợ lý AI',
        icon: Icons.auto_stories_outlined,
        items: [
          MenuItem(
            id: 'knowledge',
            title: 'Nạp kiến thức',
            onTap: () => _selectCategory('knowledge'),
          ),
        ],
      ),
    ];
  }

  void _toggleMobileSidebar() {
    setState(() {
      _showSidebarMobile = !_showSidebarMobile;
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      // Close sidebar on mobile after selection
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < 600) {
        _showSidebarMobile = false;
      }
    });
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    // Build desktop layout for chat
    if (isDesktop && _selectedCategory == 'support_inbox') {
      return _buildDesktopChatView();
    }

    // Build content based on category
    Widget contentWidget;

    final isMobile = !isDesktop;

    switch (_selectedCategory) {
      case 'dashboard':
        contentWidget = _wrapWithMenuBar(
          title: 'Dashboard',
          child: _buildDashboardContent(),
          showMenuButton: isMobile,
        );
      case 'pending_tickets':
        contentWidget = _wrapWithMenuBar(
          title: 'Phiếu chưa xử lý',
          child: const TicketListScreen(),
          showMenuButton: isMobile,
        );
      case 'support_inbox':
        contentWidget = SupportInboxScreen(onMenuTap: _toggleMobileSidebar);
      case 'knowledge':
        contentWidget = KnowledgeSourceListScreen(
          embedded: true,
          onMenuTap: _toggleMobileSidebar,
        );
      case 'customers':
        contentWidget = CustomerMainScreen(onMenuTap: _toggleMobileSidebar);
      case 'tenant_info':
        contentWidget = TenantInfoScreen(onMenuTap: _toggleMobileSidebar);
      case 'employee_list':
        contentWidget = EmployeeScreen(onMenuTap: _toggleMobileSidebar);
      case 'ai_agents':
        contentWidget = const AgentListScreen();
      case 'playground':
        contentWidget = const PlaygroundScreen(agent: null);
      case Routes.campaignList:
        contentWidget = CampaignListScreen(onMenuTap: _toggleMobileSidebar);
      case Routes.templateLibrary:
        contentWidget = TemplateLibraryScreen(onMenuTap: _toggleMobileSidebar);
      case Routes.facebookAdminSetup:
        contentWidget = const FacebookAdminSetupScreen();
      case 'prompt_library':
        contentWidget = _wrapWithMenuBar(
          title: 'Prompt Library',
          child: const PromptLibraryScreen(embedInParent: true),
          showMenuButton: isMobile,
        );
      case 'omnichannel':
        contentWidget = _wrapWithMenuBar(
          title: 'Kênh tích hợp',
          child: const OmnichannelHubScreen(showAppBar: false),
          showMenuButton: isMobile,
        );
      case 'monetization':
        contentWidget = _wrapWithMenuBar(
          title: 'Gói dịch vụ',
          child: const MonetizationScreen(embedded: true),
          showMenuButton: isMobile,
        );
      default:
        contentWidget = _wrapWithMenuBar(
          title: _selectedCategory,
          child: _buildPlaceholder(_selectedCategory),
          showMenuButton: isMobile,
        );
    }

    // On desktop: wrap content to prevent full-screen takeover
    if (isDesktop) {
      return ColoredBox(color: AppColors.backgroundGrey, child: contentWidget);
    }

    return contentWidget;
  }

  // Desktop chat view with 3-column layout
  Widget _buildDesktopChatView() {
    return SupportInboxScreen(onMenuTap: _toggleMobileSidebar);
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan hệ thống',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard(
                'Tổng phiếu',
                '12',
                Icons.confirmation_number,
                Colors.blue,
              ),
              _buildStatCard('Đang mở', '5', Icons.fiber_new, Colors.orange),
              _buildStatCard('Đang xử lý', '4', Icons.autorenew, Colors.amber),
              _buildStatCard(
                'Đã giải quyết',
                '3',
                Icons.check_circle,
                Colors.green,
              ),
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
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Wraps a child widget with an AppBar that includes a menu button (mobile only).
  Widget _wrapWithMenuBar({
    required String title,
    required Widget child,
    required bool showMenuButton,
  }) {
    if (!showMenuButton) return child;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _toggleMobileSidebar,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 80,
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tính năng sắp ra mắt',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      // Mobile: Stacked sidebar with overlay
      return Scaffold(
        body: Stack(
          children: [
            _buildContent(),
            if (_showSidebarMobile)
              GestureDetector(
                onTap: () => setState(() => _showSidebarMobile = false),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            if (_showSidebarMobile)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 280,
                  color: Colors.white,
                  child: SidebarMenuContent(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _selectCategory,
                    tenantSwitcher: _buildTenantSwitcher(),
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      // Desktop/Tablet: Side-by-side layout
      return Scaffold(
        body: Row(
          children: [
            // Sidebar (fixed width)
            Container(
              width: 280,
              color: Colors.white,
              child: SidebarMenuContent(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _selectCategory,
                tenantSwitcher: _buildTenantSwitcher(),
              ),
            ),
            // Divider
            Container(width: 1, color: AppColors.dividerColor),
            // Content area
            Expanded(child: _buildContent()),
          ],  
        ),
      );
    }
  }

  @override
  void dispose() {
    developer.log(
      'dispose: teardown realtime (reaction + socket)',
      name: _logName,
    );
    _tenantChatReaction?.call();
    unawaited(_chatStore.dispose());
    getIt<ChatRoomStore>().dispose();
    unawaited(_socketService.disconnect());
    super.dispose();
  }
}
