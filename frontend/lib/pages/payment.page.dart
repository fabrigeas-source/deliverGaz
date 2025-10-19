import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';
import 'order_confirmation.page.dart';

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
  int _selectedPaymentMethod = 0;
  bool _isProcessingPayment = false;
  
  // Form controllers
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Cash on Delivery fields
  final _deliveryAddressController = TextEditingController();
  final _deliveryPhoneController = TextEditingController();
  final _deliveryNotesController = TextEditingController();
  
  // Form keys
  final _formKey = GlobalKey<FormState>();
  
  // Payment methods - initialized in build method to access context for localization
  late List<PaymentMethod> _paymentMethods;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _deliveryAddressController.dispose();
    _deliveryPhoneController.dispose();
    _deliveryNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    
    // Initialize payment methods with localized text
    _paymentMethods = [
      PaymentMethod(
        id: 0,
        name: i10n.creditDebitCard,
        icon: Icons.credit_card,
        description: i10n.creditDebitCardDesc,
      ),
      PaymentMethod(
        id: 1,
        name: i10n.mobileMoney,
        icon: Icons.phone_android,
        description: i10n.mobileMoneyDesc,
      ),
      PaymentMethod(
        id: 2,
        name: i10n.bankTransfer,
        icon: Icons.account_balance,
        description: i10n.bankTransferDesc,
      ),
      PaymentMethod(
        id: 3,
        name: i10n.payOnDelivery,
        icon: Icons.delivery_dining,
        description: i10n.payOnDeliveryDesc,
      ),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.payment),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Order Summary
          _buildOrderSummary(),
          
          // Payment Form
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(i10n.paymentMethod),
                    const SizedBox(height: 16),
                    _buildPaymentMethods(),
                    const SizedBox(height: 24),
                    
                    if (_selectedPaymentMethod == 0) ...[
                      _buildSectionTitle(i10n.cardDetails),
                      const SizedBox(height: 16),
                      _buildCardForm(i10n),
                    ] else if (_selectedPaymentMethod == 1) ...[
                      _buildSectionTitle(i10n.mobileMoneyDetails),
                      const SizedBox(height: 16),
                      _buildMobileMoneyForm(i10n),
                    ] else if (_selectedPaymentMethod == 2) ...[
                      _buildSectionTitle(i10n.bankTransferDetails),
                      const SizedBox(height: 16),
                      _buildBankTransferForm(i10n),
                    ] else if (_selectedPaymentMethod == 3) ...[
                      _buildSectionTitle(i10n.deliveryInformation),
                      const SizedBox(height: 16),
                      _buildCashOnDeliveryForm(i10n),
                    ],
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          
          // Pay Now Button
          _buildPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final i10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            i10n.orderSummary,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            i10n.itemCount(widget.cartItems.length),
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            i10n.totalAmount(widget.totalAmount.toStringAsFixed(2)),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: _paymentMethods.map((method) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: RadioListTile<int>(
            value: method.id,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
            title: Row(
              children: [
                Icon(method.icon, size: 24),
                const SizedBox(width: 12),
                Text(method.name),
              ],
            ),
            subtitle: Text(method.description),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCardForm(AppLocalizations i10n) {
    return Column(
      children: [
        TextFormField(
          controller: _cardNumberController,
          decoration: InputDecoration(
            labelText: i10n.cardNumber,
            hintText: '1234 5678 9012 3456',
            prefixIcon: const Icon(Icons.credit_card),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return i10n.pleaseEnterCardNumber;
            }
            if (value.replaceAll(' ', '').length < 16) {
              return i10n.pleaseEnterValidCardNumber;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _cardHolderController,
          decoration: InputDecoration(
            labelText: i10n.cardholderName,
            hintText: i10n.cardholderNameHint,
            prefixIcon: const Icon(Icons.person),
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return i10n.pleaseEnterCardholderName;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: InputDecoration(
                  labelText: i10n.expiryDate,
                  hintText: 'MM/YY',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ExpiryDateFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return i10n.required;
                  }
                  if (value.length < 5) {
                    return i10n.invalidFormat;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(
                  labelText: i10n.cvv,
                  hintText: '123',
                  prefixIcon: const Icon(Icons.security),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return i10n.required;
                  }
                  if (value.length < 3) {
                    return i10n.invalidCvv;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileMoneyForm(AppLocalizations i10n) {
    return Column(
      children: [
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: i10n.phoneNumber,
            hintText: i10n.contactPhoneHint,
            prefixIcon: const Icon(Icons.phone),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return i10n.pleaseEnterPhoneNumber;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: i10n.mobileMoneyProvider,
            prefixIcon: const Icon(Icons.account_balance_wallet),
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(value: 'mtn', child: Text(i10n.mtnMobileMoney)),
            DropdownMenuItem(value: 'orange', child: Text(i10n.orangeMoney)),
            DropdownMenuItem(value: 'express_union', child: Text(i10n.expressUnionMobile)),
          ],
          validator: (value) {
            if (value == null) {
              return i10n.pleaseSelectProvider;
            }
            return null;
          },
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildBankTransferForm(AppLocalizations i10n) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i10n.bankTransferDetailsTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(i10n.accountName),
              Text(i10n.accountNumber),
              Text(i10n.bankName),
              Text(i10n.swiftCode),
              const SizedBox(height: 8),
              Text(
                i10n.referenceNumber(DateTime.now().millisecondsSinceEpoch.toString()),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: i10n.emailForConfirmation,
            hintText: i10n.emailHint,
            prefixIcon: const Icon(Icons.email),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return i10n.pleaseEnterEmail;
            }
            if (!value.contains('@')) {
              return i10n.pleaseEnterValidEmail;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCashOnDeliveryForm(AppLocalizations i10n) {
    return Column(
      children: [
        // Information Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.orange.shade600),
                  const SizedBox(width: 8),
                  Text(
                    i10n.cashOnDeliveryInfo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(i10n.paymentCollectedOnDelivery),
              Text(i10n.haveExactChange),
              Text(i10n.deliveryFee),
              Text(i10n.estimatedDelivery),
              Text(i10n.orderConfirmationSms),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Delivery Details Form
        Text(
          i10n.deliveryDetails,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Delivery Address
        TextFormField(
          controller: _deliveryAddressController,
          decoration: InputDecoration(
            labelText: i10n.deliveryAddress,
            hintText: i10n.deliveryAddressHint,
            prefixIcon: const Icon(Icons.location_on),
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return i10n.pleaseEnterDeliveryAddress;
            }
            if (value.length < 10) {
              return i10n.pleaseEnterCompleteAddress;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Delivery Phone
        TextFormField(
          controller: _deliveryPhoneController,
          decoration: InputDecoration(
            labelText: i10n.contactPhoneNumber,
            hintText: i10n.contactPhoneHint,
            prefixIcon: const Icon(Icons.phone),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return i10n.pleaseEnterContactPhone;
            }
            if (value.length < 9) {
              return i10n.pleaseEnterValidPhone;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Delivery Notes (Optional)
        TextFormField(
          controller: _deliveryNotesController,
          decoration: InputDecoration(
            labelText: i10n.deliveryInstructions,
            hintText: i10n.deliveryInstructionsHint,
            prefixIcon: const Icon(Icons.note),
            border: const OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        
        const SizedBox(height: 20),
        
        // Delivery Time Options
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Text(
                    i10n.deliveryOptions,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              RadioListTile<String>(
                title: Text(i10n.standardDelivery),
                subtitle: Text(i10n.standardDeliveryDesc),
                value: 'standard',
                groupValue: 'standard', // Default selection
                onChanged: (value) {},
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              
              RadioListTile<String>(
                title: Text(i10n.expressDelivery),
                subtitle: Text(i10n.expressDeliveryDesc),
                value: 'express',
                groupValue: 'standard',
                onChanged: (value) {},
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
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
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessingPayment ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isProcessingPayment
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(_selectedPaymentMethod == 3 ? i10n.placingOrder : i10n.processingPayment),
                    ],
                  )
                : Text(
                    _selectedPaymentMethod == 3 
                        ? i10n.payOnDeliveryButton(widget.totalAmount.toStringAsFixed(2))
                        : i10n.payNowButton(widget.totalAmount.toStringAsFixed(2)),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    final i10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Clear cart after successful payment
      final cartApiClient = CartApiClient();
      await cartApiClient.clearCart();

      if (mounted) {
        // Generate order ID
        final orderId = 'DG${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        
        // Get selected payment method name
        final selectedMethod = _paymentMethods.firstWhere((method) => method.id == _selectedPaymentMethod);
        
        // Navigate to order confirmation page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationPage(
              orderId: orderId,
              orderItems: widget.cartItems,
              totalAmount: widget.totalAmount,
              paymentMethod: selectedMethod.name,
              orderDate: DateTime.now(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(_selectedPaymentMethod == 3 
                    ? i10n.orderPlacementFailed(e.toString())
                    : i10n.paymentFailed(e.toString()))),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

class PaymentMethod {
  final int id;
  final String name;
  final IconData icon;
  final String description;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}