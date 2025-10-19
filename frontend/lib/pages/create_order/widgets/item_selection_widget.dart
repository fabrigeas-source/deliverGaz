import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';
import 'item_card_widget.dart';

/// Widget for displaying the item selection step in create order page
class ItemSelectionWidget extends StatelessWidget {
  final List<OrderItem> availableItems;
  final Map<String, int> selectedItems;
  final Function(OrderItem) onItemTap;

  const ItemSelectionWidget({
    super.key,
    required this.availableItems,
    required this.selectedItems,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            i10n.selectItemsForOrder,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            i10n.chooseItemsDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          
          // Group items by category
          ..._buildItemsByCategory(context),
        ],
      ),
    );
  }

  List<Widget> _buildItemsByCategory(BuildContext context) {
    Map<String, List<OrderItem>> itemsByCategory = {};
    for (var item in availableItems) {
      if (!itemsByCategory.containsKey(item.category)) {
        itemsByCategory[item.category] = [];
      }
      itemsByCategory[item.category]!.add(item);
    }

    List<Widget> widgets = [];
    itemsByCategory.forEach((category, items) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              ...items.map((item) => ItemCardWidget(
                item: item,
                selectedItems: selectedItems,
                onTap: () => onItemTap(item),
              )),
            ],
          ),
        ),
      );
    });
    return widgets;
  }
}