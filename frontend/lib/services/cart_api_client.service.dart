import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/mock.dart';
import 'api_base.service.dart';

/// API client for shopping cart management
class CartApiClient {
  static final CartApiClient _instance = CartApiClient._internal();
  factory CartApiClient() => _instance;
  CartApiClient._internal();

  final MockCartApiService _mockApi = MockCartApiService();

  /// Get user's cart items
  Future<List<CartItem>> getCartItems() async {
    final response = await _mockApi.getCartItems();

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Add item to cart
  Future<CartItem> addToCart({
    required String productId,
    required String name,
    required double price,
    required IconData image,
    int quantity = 1,
  }) async {
    final response = await _mockApi.addToCart(
      productId: productId,
      name: name,
      price: price,
      image: image,
      quantity: quantity,
    );

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Update cart item quantity
  Future<CartItem> updateCartItem(String productId, int quantity) async {
    final response = await _mockApi.updateCartItem(productId, quantity);

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String productId) async {
    final response = await _mockApi.removeFromCart(productId);

    if (!response.isSuccess) {
      throw ApiException(response.error!);
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    final response = await _mockApi.clearCart();

    if (!response.isSuccess) {
      throw ApiException(response.error!);
    }
  }

  /// Get cart summary
  Future<CartSummary> getCartSummary() async {
    final response = await _mockApi.getCartSummary();

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Set current user (for testing)
  void setCurrentUser(String? userId) {
    _mockApi.setCurrentUser(userId);
  }
}

