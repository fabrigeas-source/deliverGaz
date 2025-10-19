import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';

/// Mock API service for shopping cart management
class MockCartApiService {
  static final MockCartApiService _instance = MockCartApiService._internal();
  factory MockCartApiService() => _instance;
  MockCartApiService._internal();

  // Simulate network delay
  static const Duration _networkDelay = Duration(milliseconds: 300);

  // Mock cart database (per user)
  final Map<String, List<CartItem>> _userCarts = {
    'user_001': [
      CartItem(
        id: 'gas_13kg',
        name: '13kg Gas Cylinder',
        price: 45.99,
        quantity: 2,
        image: Icons.propane_tank,
      ),
      CartItem(
        id: 'regulator',
        name: 'Gas Regulator',
        price: 25.50,
        quantity: 1,
        image: Icons.settings,
      ),
    ],
  };

  String? _currentUserId = 'user_001'; // Mock current user

  /// GET /api/cart
  /// Get user's cart items
  Future<ApiResponse<List<CartItem>>> getCartItems() async {
    await Future.delayed(_networkDelay);

    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final cartItems = _userCarts[_currentUserId!] ?? [];
      return ApiResponse.success(List.from(cartItems));
    } catch (e) {
      return ApiResponse.error('Failed to fetch cart: $e');
    }
  }

  /// POST /api/cart/items
  /// Add item to cart
  Future<ApiResponse<CartItem>> addToCart({
    required String productId,
    required String name,
    required double price,
    required IconData image,
    int quantity = 1,
  }) async {
    await Future.delayed(_networkDelay);

    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      if (_userCarts[_currentUserId!] == null) {
        _userCarts[_currentUserId!] = [];
      }

      final existingItemIndex = _userCarts[_currentUserId!]!
          .indexWhere((item) => item.id == productId);

      if (existingItemIndex != -1) {
        // Update existing item quantity
        _userCarts[_currentUserId!]![existingItemIndex].quantity += quantity;
        return ApiResponse.success(_userCarts[_currentUserId!]![existingItemIndex]);
      } else {
        // Add new item
        final newItem = CartItem(
          id: productId,
          name: name,
          price: price,
          quantity: quantity,
          image: image,
        );
        _userCarts[_currentUserId!]!.add(newItem);
        return ApiResponse.success(newItem);
      }
    } catch (e) {
      return ApiResponse.error('Failed to add to cart: $e');
    }
  }

  /// PUT /api/cart/items/:id
  /// Update cart item quantity
  Future<ApiResponse<CartItem>> updateCartItem(String productId, int quantity) async {
    await Future.delayed(_networkDelay);

    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final cartItems = _userCarts[_currentUserId!] ?? [];
      final itemIndex = cartItems.indexWhere((item) => item.id == productId);

      if (itemIndex == -1) {
        throw Exception('Item not found in cart');
      }

      if (quantity <= 0) {
        // Remove item if quantity is 0 or less
        cartItems.removeAt(itemIndex);
        return ApiResponse.success(CartItem(
          id: productId,
          name: '',
          price: 0,
          quantity: 0,
          image: Icons.delete,
        ));
      } else {
        // Update quantity
        cartItems[itemIndex].quantity = quantity;
        return ApiResponse.success(cartItems[itemIndex]);
      }
    } catch (e) {
      return ApiResponse.error('Failed to update cart item: $e');
    }
  }

  /// DELETE /api/cart/items/:id
  /// Remove item from cart
  Future<ApiResponse<void>> removeFromCart(String productId) async {
    await Future.delayed(_networkDelay);

    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final cartItems = _userCarts[_currentUserId!] ?? [];
      cartItems.removeWhere((item) => item.id == productId);

      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Failed to remove from cart: $e');
    }
  }

  /// DELETE /api/cart
  /// Clear entire cart
  Future<ApiResponse<void>> clearCart() async {
    await Future.delayed(_networkDelay);

    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      _userCarts[_currentUserId!] = [];
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Failed to clear cart: $e');
    }
  }

  /// GET /api/cart/summary
  /// Get cart summary (total items, total price)
  Future<ApiResponse<CartSummary>> getCartSummary() async {
    await Future.delayed(_networkDelay);

    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final cartItems = _userCarts[_currentUserId!] ?? [];
      
      final totalItems = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
      final totalPrice = cartItems.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));

      final summary = CartSummary(
        totalItems: totalItems,
        totalPrice: totalPrice,
        itemCount: cartItems.length,
      );

      return ApiResponse.success(summary);
    } catch (e) {
      return ApiResponse.error('Failed to get cart summary: $e');
    }
  }

  /// Set current user (for testing)
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
  }
}

/// Cart summary model
class CartSummary {
  final int totalItems;
  final double totalPrice;
  final int itemCount;

  CartSummary({
    required this.totalItems,
    required this.totalPrice,
    required this.itemCount,
  });
}