import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_tab_bar_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_header_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_search_filter_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_table_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/create_ticket_screen.dart';

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
    _createTicketStore = CreateTicketStore();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Observer(
        builder: (_) {
          // Show create mode
          if (_store.isCreateMode) {
            return CreateTicketScreenBody(
              store: _createTicketStore,
              onClose: _store.closeCreateMode,
            );
          }

          // Get screen width
          final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth < 768;

          // Show list view
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Tab bar - Only show on desktop
                if (!isMobile)
                  Observer(
                    builder: (_) => TicketTabBarWidget(
                      selectedTabIndex: _store.selectedTabIndex,
                      onTabChanged: _store.setSelectedTab,
                    ),
                  ),

                // Mobile tab selector - Only show on mobile
                if (isMobile)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Observer(
                      builder: (_) => SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final tabTitles = [
                              'Phiếu của tôi',
                              'Chưa tiếp nhận',
                              'Tất cả phiếu',
                            ];
                            final isSelected = _store.selectedTabIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ElevatedButton(
                                onPressed: () => _store.setSelectedTab(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? AppColors.primaryBlue
                                      : AppColors.inputBackground,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  tabTitles[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                // Header with title and action buttons
                Observer(
                  builder: (_) => TicketHeaderWidget(
                    tabTitle: _store.tabTitle,
                    ticketCount: _store.ticketCount,
                    onExportPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Xuất Excel: Tính năng đang phát triển')),
                      );
                    },
                    onAddTicketPressed: _store.openCreateMode,
                  ),
                ),

                // Search and filter + Table with tickets (grouped)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.dividerColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Search and filter
                        TicketSearchFilterWidget(
                          searchController: _searchController,
                          onSearchChanged: _store.setSearchQuery,
                          onFilterPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Bộ lọc: Tính năng đang phát triển'),
                              ),
                            );
                          },
                        ),

                        // Divider
                        Container(
                          height: 1,
                          color: AppColors.dividerColor,
                        ),

                        // Table with tickets
                        Expanded(
                          child: Observer(
                            builder: (_) => TicketTableWidget(
                              tickets: _store.filteredTickets,
                              selectedTabIndex: _store.selectedTabIndex,
                              onAcceptTicket: (ticket) {
                                _store.acceptTicket(ticket);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tiếp nhận phiếu: ${ticket.id}'),
                                  ),
                                );
                              },
                              onViewDetails: (ticket) {
                                _store.viewTicketDetails(ticket);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Xem chi tiết phiếu: ${ticket.id}'),
                                  ),
                                );
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
