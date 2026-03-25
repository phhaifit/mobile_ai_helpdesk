import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../constants/colors.dart';
import '../store/customer_store.dart';

class CustomerFilterSheet extends StatelessWidget {
  final CustomerStore store;

  const CustomerFilterSheet({required this.store, super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, scrollCtrl) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'B\u1ed9 l\u1ecdc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Observer(
                  builder: (_) => store.selectedTagFilters.isNotEmpty
                      ? TextButton(
                          onPressed: () {
                            store.clearTagFilters();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'X\u00f3a t\u1ea5t c\u1ea3',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            const Divider(),
            const Text(
              'L\u1ecdc theo nh\u00e3n',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Observer(
                builder: (_) {
                  final tags = store.allAvailableTags;
                  if (tags.isEmpty) {
                    return Center(
                      child: Text(
                        'Ch\u01b0a c\u00f3 nh\u00e3n n\u00e0o',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollCtrl,
                    itemCount: tags.length,
                    itemBuilder: (_, i) {
                      final tag = tags[i];
                      return Observer(
                        builder: (_) {
                          final isSelected = store.selectedTagFilters.contains(
                            tag,
                          );
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (_) => store.toggleTagFilter(tag),
                            title: Text(
                              tag,
                              style: const TextStyle(fontSize: 13),
                            ),
                            activeColor: AppColors.primaryBlue,
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(44),
                ),
                child: const Text(
                  '\u00c1p d\u1ee5ng',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
