import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final IconData icon;
  final String? imageUrl;
  final bool isAvailable;
  final int stockQuantity;
  final double? weight; // For gas cylinders
  final String? unit; // e.g., "kg", "pieces"

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.icon,
    this.imageUrl,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.weight,
    this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'weight': weight,
      'unit': unit,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      icon: Icons.propane_tank, // Default icon, would need mapping
      imageUrl: json['imageUrl'],
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 0,
      weight: json['weight']?.toDouble(),
      unit: json['unit'],
    );
  }
}