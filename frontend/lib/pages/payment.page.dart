import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.cartItems, required this.totalAmount});
 
  final List<CartItem> cartItems;
  final double totalAmount;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'card';
  String _selectedDeliveryOption = 'standard';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(l10n?.paymentMethods ?? 'Payment Methods'),
          _buildPaymentMethodTile('card', l10n?.creditCard ?? 'Credit Card'),
          _buildPaymentMethodTile('paypal', 'PayPal'),
          _buildPaymentMethodTile('cod', 'Pay on Delivery'),
          const SizedBox(height: 16),
          if (_selectedPaymentMethod == 'cod') ...[
            _buildSectionTitle('Delivery Options'),
            _buildDeliveryOptionTile('express', 'Express Delivery (1-2 hours)'),
            _buildDeliveryOptionTile('standard', 'Standard Delivery (3-5 days)'),
          ],
          const SizedBox(height: 24),
          _buildSectionTitle(l10n?.orderSummary ?? 'Order Summary'),
          Text('Items: ${widget.cartItems.length}'),
          Text('Total: ${widget.totalAmount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPaymentMethodTile(String key, String label) {
    final selected = _selectedPaymentMethod == key;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off),
      title: Text(label),
      onTap: () {
        setState(() => _selectedPaymentMethod = key);
      },
    );
  }

  Widget _buildDeliveryOptionTile(String key, String label) {
    final selected = _selectedDeliveryOption == key;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off),
      title: Text(label),
      onTap: () {
        setState(() => _selectedDeliveryOption = key);
      },
    );
  }
}