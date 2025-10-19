import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';
import 'package:deliver_gaz/pages/shopping_cart.page.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';
import 'widgets/index.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final Map<String, int> _selectedItems = {};
  bool _isProcessingOrder = false;
  int _cartItemCount = 0;
  
  final List<OrderItem> _availableItems = [
    OrderItem(
      id: 'gas_13kg',
      name: '13kg Gas Cylinder',
      description: 'Standard 13kg propane gas cylinder for home use',
      price: 45.99,
      image: Icons.propane_tank,
      category: 'Gas Cylinders',
    ),
    OrderItem(
      id: 'gas_9kg',
      name: '9kg Gas Cylinder',
      description: 'Compact 9kg propane gas cylinder',
      price: 32.99,
      image: Icons.propane_tank,
      category: 'Gas Cylinders',
    ),
    OrderItem(
      id: 'gas_45kg',
      name: '45kg Gas Cylinder',
      description: 'Large 45kg propane gas cylinder for commercial use',
      price: 89.99,
      image: Icons.propane_tank,
      category: 'Gas Cylinders',
    ),
    OrderItem(
      id: 'regulator',
      name: 'Gas Regulator',
      description: 'High-quality gas regulator with safety valve',
      price: 25.50,
      image: Icons.settings,
      category: 'Accessories',
    ),
    OrderItem(
      id: 'hose_2m',
      name: '2m Gas Hose',
      description: 'Flexible 2-meter gas hose with connectors',
      price: 15.99,
      image: Icons.cable,
      category: 'Accessories',
    ),
    OrderItem(
      id: 'hose_5m',
      name: '5m Gas Hose',
      description: 'Extended 5-meter gas hose for outdoor use',
      price: 28.99,
      image: Icons.cable,
      category: 'Accessories',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _updateCartCount();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.createNewOrder),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          CartIconWidget(
            cartItemCount: _cartItemCount,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
              ).then((_) {
                _updateCartCount();
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Content area
          Expanded(
            child: ItemSelectionWidget(
              availableItems: _availableItems,
              selectedItems: _selectedItems,
              onItemTap: _showQuantityDialog,
            ),
          ),
          
          // Bottom navigation
          BottomNavigationWidget(
            selectedItems: _selectedItems,
            isProcessingOrder: _isProcessingOrder,
            totalAmount: _calculateTotal(),
            onCancel: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(i10n.orderCreationCancelled),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            onContinue: (_selectedItems.isNotEmpty && !_isProcessingOrder) ? _continueToCart : null,
          ),
        ],
      ),
    );
  }


  void _showQuantityDialog(OrderItem item) {
    final i10n = AppLocalizations.of(context)!;
    int currentQuantity = _selectedItems[item.id] ?? 0;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(i10n.selectQuantity),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(item.image, size: 24),
                const SizedBox(width: 8),
                Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 8),
            Text('\$${item.price.toStringAsFixed(2)} ${i10n.each}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Text('${i10n.quantity}:', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setDialogState) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentQuantity > 0 ? () {
                      setDialogState(() {
                        currentQuantity--;
                      });
                    } : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentQuantity.toString(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: currentQuantity < 99 ? () {
                      setDialogState(() {
                        currentQuantity++;
                      });
                    } : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
            if (currentQuantity > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${i10n.subtotal}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '\$${(item.price * currentQuantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Show cancel snackbar for quantity selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(i10n.actionCancelled),
                  backgroundColor: Colors.grey,
                  duration: const Duration(seconds: 1),
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: Text(i10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (currentQuantity > 0) {
                // Add directly to cart instead of just to order
                _addSingleItemToCart(item, currentQuantity);
                
                // Also update the selected items for the order view
                setState(() {
                  _selectedItems[item.id] = currentQuantity;
                });
              } else {
                // Remove from both cart and selected items
                setState(() {
                  _selectedItems.remove(item.id);
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.remove_shopping_cart, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${item.name} ${i10n.removedFromSelection}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
              
              Navigator.pop(dialogContext);
            },
            child: Text(currentQuantity > 0 ? i10n.addToCart : i10n.removeFromCart),
          ),
        ],
      ),
    );
  }

  double _calculateTotal() {
    double total = 0;
    _selectedItems.forEach((itemId, quantity) {
      OrderItem item = _availableItems.firstWhere((i) => i.id == itemId);
      total += item.price * quantity;
    });
    return total;
  }

  /// Add a single item directly to cart (bypassing order creation)
  void _addSingleItemToCart(OrderItem item, int quantity) async {
    final i10n = AppLocalizations.of(context)!;
    try {
      final cartApiClient = CartApiClient();
      
      await cartApiClient.addToCart(
        productId: item.id,
        name: item.name,
        price: item.price,
        image: item.image,
        quantity: quantity,
      );

      if (mounted) {
        // Update cart count
        _updateCartCount();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$quantity x ${item.name} ${i10n.addedToCart}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = i10n.failedToAddItemToCart;
        if (e is ApiException) {
          errorMessage = e.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _continueToCart() async {
    final i10n = AppLocalizations.of(context)!;
    setState(() {
      _isProcessingOrder = true;
    });

    try {
      final cartApiClient = CartApiClient();
      
      // Add each selected item to the cart
      for (var entry in _selectedItems.entries) {
        final item = _availableItems.firstWhere((i) => i.id == entry.key);
        
        // Convert OrderItem to cart format and add to cart
        await cartApiClient.addToCart(
          productId: item.id,
          name: item.name,
          price: item.price,
          image: item.image,
          quantity: entry.value,
        );
      }

      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });

        // Update cart count
        _updateCartCount();

        // Show success snackbar briefly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${i10n.itemsAddedToCart} ${_selectedItems.length} ${i10n.orderItems}. ${i10n.total}: \$${_calculateTotal().toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Clear the current order since it's been added to cart
        setState(() {
          _selectedItems.clear();
        });

        // Navigate directly to shopping cart page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });

        // Show error snackbar
        String errorMessage = i10n.failedToAddItemsToCart;
        if (e is ApiException) {
          errorMessage = '${i10n.cartError}: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: i10n.retry,
              textColor: Colors.white,
              onPressed: () {
                _continueToCart(); // Retry the process
              },
            ),
          ),
        );
      }
    }
  }

  /// Update cart item count for display in app bar
  void _updateCartCount() async {
    try {
      final cartApiClient = CartApiClient();
      final cartItems = await cartApiClient.getCartItems();
      
      if (mounted) {
        setState(() {
          _cartItemCount = cartItems.length;
        });
      }
    } catch (e) {
      // Silently handle error - cart count is not critical for functionality
      if (mounted) {
        setState(() {
          _cartItemCount = 0;
        });
      }
    }
  }


}

