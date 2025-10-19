import 'package:flutter/material.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

/// Widget for the bottom navigation bar in create order page
class BottomNavigationWidget extends StatelessWidget {
  final Map<String, int> selectedItems;
  final bool isProcessingOrder;
  final VoidCallback onCancel;
  final VoidCallback? onContinue;
  final double totalAmount;

  const BottomNavigationWidget({
    super.key,
    required this.selectedItems,
    required this.isProcessingOrder,
    required this.onCancel,
    this.onContinue,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              child: Text(i10n.cancel),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: (selectedItems.isNotEmpty && !isProcessingOrder) ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: isProcessingOrder
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(i10n.addingToCart),
                      ],
                    )
                  : Text(selectedItems.isNotEmpty 
                      ? i10n.continueToCart('\$${totalAmount.toStringAsFixed(2)}')
                      : i10n.selectItemsFirst),
            ),
          ),
        ],
      ),
    );
  }
}