import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData image;
  final String category;

  OrderItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });
}