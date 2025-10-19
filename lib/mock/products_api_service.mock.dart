import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';

/// Mock API service for products management
class MockProductsApiService {
  static final MockProductsApiService _instance = MockProductsApiService._internal();
  factory MockProductsApiService() => _instance;
  MockProductsApiService._internal();

  // Simulate network delay
  static const Duration _networkDelay = Duration(milliseconds: 400);

  // Mock products database
  final List<OrderItem> _products = [
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
    OrderItem(
      id: 'burner_single',
      name: 'Single Burner Stove',
      description: 'Portable single burner gas stove',
      price: 35.99,
      image: Icons.local_fire_department,
      category: 'Stoves & Burners',
    ),
    OrderItem(
      id: 'burner_double',
      name: 'Double Burner Stove',
      description: 'Heavy-duty double burner gas stove',
      price: 65.99,
      image: Icons.local_fire_department,
      category: 'Stoves & Burners',
    ),
  ];

  /// GET /api/products
  /// Returns all products with optional category filtering
  Future<ApiResponse<List<OrderItem>>> getProducts({
    String? category,
    String? search,
  }) async {
    await Future.delayed(_networkDelay);

    try {
      List<OrderItem> result = List.from(_products);

      // Apply category filter
      if (category != null && category != 'All') {
        result = result.where((product) => product.category == category).toList();
      }

      // Apply search filter
      if (search != null && search.isNotEmpty) {
        result = result.where((product) =>
          product.name.toLowerCase().contains(search.toLowerCase()) ||
          product.description.toLowerCase().contains(search.toLowerCase())
        ).toList();
      }

      return ApiResponse.success(result);
    } catch (e) {
      return ApiResponse.error('Failed to fetch products: $e');
    }
  }

  /// GET /api/products/:id
  /// Returns a specific product by ID
  Future<ApiResponse<OrderItem>> getProduct(String id) async {
    await Future.delayed(_networkDelay);

    try {
      final product = _products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );

      return ApiResponse.success(product);
    } catch (e) {
      return ApiResponse.error('Product not found');
    }
  }

  /// GET /api/products/categories
  /// Returns all product categories
  Future<ApiResponse<List<String>>> getCategories() async {
    await Future.delayed(_networkDelay);

    try {
      final categories = _products.map((p) => p.category).toSet().toList();
      categories.sort();
      return ApiResponse.success(['All', ...categories]);
    } catch (e) {
      return ApiResponse.error('Failed to fetch categories: $e');
    }
  }

  /// GET /api/products/featured
  /// Returns featured products
  Future<ApiResponse<List<OrderItem>>> getFeaturedProducts() async {
    await Future.delayed(_networkDelay);

    try {
      // Return first 4 products as featured
      final featured = _products.take(4).toList();
      return ApiResponse.success(featured);
    } catch (e) {
      return ApiResponse.error('Failed to fetch featured products: $e');
    }
  }
}