import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';

class CustomerFilterSheet extends StatelessWidget {
  final CustomerStore store;

  const CustomerFilterSheet({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Observer(
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).translate('customer_filter_title'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).translate('customer_filter_tags'), 
                style: const TextStyle(fontWeight: FontWeight.w600)
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: store.availableTags.map((t) {
                  final isSelected = store.selectedTagIds.contains(t.id);
                  return FilterChip(
                    label: Text(t.name),
                    selected: isSelected,
                    onSelected: (val) => store.toggleTagFilter(t.id),
                    selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        store.clearFilters();
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).translate('customer_filter_clear')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                      ),
                      onPressed: () {
                        store.applyFilters();
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context).translate('customer_filter_apply'), 
                        style: const TextStyle(color: Colors.white)
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
