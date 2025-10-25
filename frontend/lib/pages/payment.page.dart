import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const PaymentPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = '';
  String _selectedDeliveryOption = '';
  
  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.payment),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i10n.orderSummary,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.cartItems.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.name} x${item.quantity}'),
                          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          i10n.total,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Payment Method
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i10n.paymentMethod,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(i10n.payOnDelivery),
                      subtitle: Text(i10n.payOnDeliveryDesc),
                      leading: Radio<String>(
                        value: 'pay_on_delivery',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'pay_on_delivery';
                        });
                      },
                    ),
                    ListTile(
                      title: Text(i10n.creditCard),
                      leading: Radio<String>(
                        value: 'credit_card',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'credit_card';
                        });
                      },
                    ),
                    ListTile(
                      title: Text(i10n.mobileMoney),
                      subtitle: Text(i10n.mobileMoneyDesc),
                      leading: Radio<String>(
                        value: 'mobile_money',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'mobile_money';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Delivery Options (shown when payment method is selected)
            if (_selectedPaymentMethod.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i10n.deliveryOptions,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text(i10n.expressDelivery),
                        subtitle: Text(i10n.expressDeliveryDesc),
                        leading: Radio<String>(
                          value: 'express',
                          groupValue: _selectedDeliveryOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _selectedDeliveryOption = 'express';
                          });
                        },
                      ),
                      ListTile(
                        title: Text(i10n.standardDelivery),
                        subtitle: Text(i10n.standardDeliveryDesc),
                        leading: Radio<String>(
                          value: 'standard',
                          groupValue: _selectedDeliveryOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedDeliveryOption = value!;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _selectedDeliveryOption = 'standard';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod.isEmpty || _selectedDeliveryOption.isEmpty
                  ? null
                  : () => _placeOrder(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  '${i10n.confirmOrder} - \$${widget.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _placeOrder() async {
    final i10n = AppLocalizations.of(context)!;
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(i10n.processingOrder),
              ],
            ),
          ),
        ),
      ),
    );
    
    // Simulate order placement
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Close loading dialog
    Navigator.pop(context);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(i10n.orderPlacedSuccess),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate back to shopping cart (which should clear the cart)
    Navigator.pop(context);
  }
}
