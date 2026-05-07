import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_tab_bar_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_header_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_search_filter_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_filter_dialog.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_table_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/create_ticket_screen.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late final TicketTabStore _store;
  late final CreateTicketStore _createTicketStore;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _store = GetIt.instance<TicketTabStore>();
    _createTicketStore = GetIt.instance<CreateTicketStore>();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Observer(
        builder: (_) {
          // Show create mode
          if (_store.isCreateMode) {
            return CreateTicketScreenBody(
              store: _createTicketStore,
              onCreated: (_) async {
                await _store.loadTickets();
              },
              onClose: _store.closeCreateMode,
            );
          }

          // Get screen width
          final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth < 768;

          // Show list view
          return Padding(
            padding: EdgeInsets.all(isMobile ? 8.0 : 20.0),
            child: Column(
              children: [
                // Tab bar - Only show on desktop
                if (!isMobile)
                  Observer(
                    builder:
                        (_) => TicketTabBarWidget(
                          selectedTabIndex: _store.selectedTabIndex,
                          onTabChanged: _store.setSelectedTab,
                        ),
                  ),

                // Mobile tab selector — segmented control
                if (isMobile)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Observer(
                      builder: (_) {
                        const tabTitles = [
                          'Phiếu của tôi',
                          'Chưa tiếp nhận',
                          'Tất cả phiếu',
                        ];
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: List.generate(tabTitles.length, (index) {
                              final isSelected =
                                  _store.selectedTabIndex == index;
                              return Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _store.setSelectedTab(index),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 180),
                                    curve: Curves.easeOut,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: isSelected
                                          ? const [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                blurRadius: 4,
                                                offset: Offset(0, 1),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      tabTitles[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primaryBlue
                                            : AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),

                // Header with title and action buttons
                Observer(
                  builder:
                      (_) => TicketHeaderWidget(
                        tabTitle: _store.tabTitle,
                        ticketCount: _store.ticketCount,
                        onExportPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Xuất Excel: Tính năng đang phát triển',
                              ),
                            ),
                          );
                        },
                        onAddTicketPressed: _store.openCreateMode,
                      ),
                ),

                // Search and filter + Table with tickets (grouped)
                Expanded(
                  child: Container(
                    decoration: isMobile
                        ? null
                        : BoxDecoration(
                            border: Border.all(color: AppColors.dividerColor, width: 1),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                    child: Column(
                      children: [
                        // Search and filter
                        TicketSearchFilterWidget(
                          searchController: _searchController,
                          onSearchChanged: _store.setSearchQuery,
                          hasActiveFilter: !_store.activeFilter.isEmpty,
                          activeFilterCount:
                              _store.activeFilter.activeFilterCount,
                          onFilterPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => TicketFilterDialog(
                                    initialFilter: _store.activeFilter,
                                    allTickets: _store.allTickets,
                                    onFilterChanged: (newFilter) {
                                      _store.setFilter(newFilter);
                                    },
                                    onFilterCleared: () {
                                      _store.clearFilter();
                                    },
                                  ),
                            );
                          },
                        ),

                        // Divider
                        Container(height: 1, color: AppColors.dividerColor),

                        // Table with tickets
                        Expanded(
                          child: Observer(
                            builder:
                                (_) => TicketTableWidget(
                                  tickets: _store.filteredTickets,
                                  selectedTabIndex: _store.selectedTabIndex,
                                  currentAgentId: _store.currentAgentId,
                                  onLoadMore: _store.loadMore,
                                  isLoadingMore: _store.isLoadingMore,
                                  hasMore: _store.hasMore,
                                  onAcceptTicket: (ticket) {
                                    _store.acceptTicket(ticket);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Tiếp nhận phiếu: ${ticket.id}',
                                        ),
                                      ),
                                    );
                                  },
                                  onCancelTicket: (ticket) async {
                                    final isSuccess = await _store.cancelTicket(
                                      ticket,
                                    );
                                    final message =
                                        isSuccess
                                            ? l.translate('ticketCancelSuccess')
                                            : l.translate('ticketCancelFailed');

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$message ${ticket.id}'),
                                      ),
                                    );
                                  },
                                  onViewDetails: (ticket) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.ticketDetail,
                                      arguments: ticket.id,
                                    ).then((result) {
                                      _store.loadTickets();
                                    });
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
