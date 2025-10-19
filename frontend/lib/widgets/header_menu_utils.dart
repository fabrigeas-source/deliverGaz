import 'package:flutter/material.dart';
import 'package:deliver_gaz/services.dart';
import 'package:deliver_gaz/pages/profile.page.dart';
import 'package:deliver_gaz/pages/orders.page.dart';
import 'package:deliver_gaz/pages/shopping_cart.page.dart';
import 'package:deliver_gaz/pages/signin.page.dart';
import 'package:deliver_gaz/main.dart';
import 'language_selector.dart';

class HeaderMenuUtils {
  static void handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        ProfileDialogUtils.showEditProfileDialog(context);
        break;
      case 'orders':
        OrdersDialogUtils.showOrdersDialog(context);
        break;
      case 'cart':
        ShoppingCartDialogUtils.showShoppingCartDialog(context);
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Sign Out'),
            ],
          ),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Clear session storage
                await SessionStorage.clearSession();
                
                // Check if context is still mounted before navigation
                if (context.mounted) {
                  // Navigate back to sign in page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                    (Route<dynamic> route) => false,
                  );
                  
                  // Show sign out message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Signed out successfully'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  // Build the header menu widget
  static Widget buildHeaderMenu(BuildContext context) {
    return const DynamicHeaderMenu();
  }
}

class DynamicHeaderMenu extends StatefulWidget {
  const DynamicHeaderMenu({super.key});

  @override
  State<DynamicHeaderMenu> createState() => _DynamicHeaderMenuState();
}

class _DynamicHeaderMenuState extends State<DynamicHeaderMenu> {
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _updateCartCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh cart count when the widget becomes visible again
    _updateCartCount();
  }

  Future<void> _updateCartCount() async {
    try {
      final cartApiClient = CartApiClient();
      final cartItems = await cartApiClient.getCartItems();
      
      if (mounted) {
        setState(() {
          _cartItemCount = cartItems.length;
        });
      }
    } catch (e) {
      // Silently handle error - cart count is not critical for header functionality
      if (mounted) {
        setState(() {
          _cartItemCount = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LanguageSelector(
          currentLocale: Localizations.localeOf(context),
          onLocaleChanged: (locale) {
            MyApp.setLocale(context, locale);
          },
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
      onSelected: (String value) {
        HeaderMenuUtils.handleMenuSelection(context, value);
        // Refresh cart count when menu is closed
        if (value == 'cart') {
          Future.delayed(const Duration(milliseconds: 500), () {
            _updateCartCount();
          });
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text('Edit My Information'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem<String>(
          value: 'orders',
          child: ListTile(
            leading: Icon(Icons.shopping_bag, color: Colors.orange),
            title: Text('My Orders'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem<String>(
          value: 'cart',
          child: ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.green),
            title: const Text('My Shopping Cart'),
            trailing: _cartItemCount > 0
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      _cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Sign Out'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    ),
      ],
    );
  }
}