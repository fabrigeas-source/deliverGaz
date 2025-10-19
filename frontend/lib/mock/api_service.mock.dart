import 'dart:async';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';

/// Mock API service that simulates a real REST API
/// This replaces Mirage.js functionality for Flutter apps
class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  // Simulate network delay
  static const Duration _networkDelay = Duration(milliseconds: 500);

  // Mock database
  final List<Order> _orders = [
    Order(
      id: '2024001',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Delivered',
      total: 79.99,
      items: ['13kg Gas Cylinder', 'Gas Regulator'],
    ),
    Order(
      id: '2024002',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'In Transit',
      total: 299.99,
      items: ['45kg Gas Cylinder', '5m Gas Hose'],
    ),
    Order(
      id: '2024003',
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: 'Delivered',
      total: 149.50,
      items: ['9kg Gas Cylinder', '2m Gas Hose', 'Gas Regulator'],
    ),
    Order(
      id: '2024004',
      date: DateTime.now().subtract(const Duration(days: 14)),
      status: 'Delivered',
      total: 89.99,
      items: ['13kg Gas Cylinder', 'Gas Regulator'],
    ),
    Order(
      id: '2024005',
      date: DateTime.now().subtract(const Duration(days: 21)),
      status: 'Cancelled',
      total: 199.99,
      items: ['45kg Gas Cylinder'],
    ),
    Order(
      id: '2024006',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'In Transit',
      total: 65.50,
      items: ['9kg Gas Cylinder'],
    ),
    Order(
      id: '2024007',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Delivered',
      total: 45.99,
      items: ['13kg Gas Cylinder'],
    ),
  ];

  /// GET /api/orders
  /// Returns all orders with optional filtering and sorting
  Future<ApiResponse<List<Order>>> getOrders({
    String? status,
    String? sortBy,
    bool ascending = false,
  }) async {
    await Future.delayed(_networkDelay);

    try {
      List<Order> result = List.from(_orders);

      // Apply status filter
      if (status != null && status != 'All') {
        result = result.where((order) => order.status == status).toList();
      }

      // Apply sorting
      if (sortBy != null) {
        result.sort((a, b) {
          int comparison;
          switch (sortBy) {
            case 'Date':
              comparison = a.date.compareTo(b.date);
              break;
            case 'Status':
              comparison = a.status.compareTo(b.status);
              break;
            case 'Total':
              comparison = a.total.compareTo(b.total);
              break;
            case 'ID':
              comparison = a.id.compareTo(b.id);
              break;
            default:
              comparison = a.date.compareTo(b.date);
          }
          return ascending ? comparison : -comparison;
        });
      }

      return ApiResponse.success(result);
    } catch (e) {
      return ApiResponse.error('Failed to fetch orders: $e');
    }
  }

  /// GET /api/orders/:id
  /// Returns a specific order by ID
  Future<ApiResponse<Order>> getOrder(String id) async {
    await Future.delayed(_networkDelay);

    try {
      final order = _orders.firstWhere(
        (order) => order.id == id,
        orElse: () => throw Exception('Order not found'),
      );

      return ApiResponse.success(order);
    } catch (e) {
      return ApiResponse.error('Order not found');
    }
  }

  /// POST /api/orders
  /// Creates a new order
  Future<ApiResponse<Order>> createOrder({
    required double total,
    required List<String> items,
  }) async {
    await Future.delayed(_networkDelay);

    try {
      final newOrder = Order(
        id: '2024${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        date: DateTime.now(),
        status: 'Processing',
        total: total,
        items: items,
      );

      _orders.insert(0, newOrder);
      return ApiResponse.success(newOrder);
    } catch (e) {
      return ApiResponse.error('Failed to create order: $e');
    }
  }

  /// PUT /api/orders/:id
  /// Updates an order status
  Future<ApiResponse<Order>> updateOrderStatus(String id, String status) async {
    await Future.delayed(_networkDelay);

    try {
      final index = _orders.indexWhere((order) => order.id == id);
      if (index == -1) {
        throw Exception('Order not found');
      }

      final updatedOrder = Order(
        id: _orders[index].id,
        date: _orders[index].date,
        status: status,
        total: _orders[index].total,
        items: _orders[index].items,
      );

      _orders[index] = updatedOrder;
      return ApiResponse.success(updatedOrder);
    } catch (e) {
      return ApiResponse.error('Failed to update order: $e');
    }
  }

  /// DELETE /api/orders/:id
  /// Cancels an order (sets status to Cancelled)
  Future<ApiResponse<void>> cancelOrder(String id) async {
    await Future.delayed(_networkDelay);

    try {
      final result = await updateOrderStatus(id, 'Cancelled');
      if (result.isSuccess) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error(result.error!);
      }
    } catch (e) {
      return ApiResponse.error('Failed to cancel order: $e');
    }
  }

  /// Simulate network errors for testing
  void simulateNetworkError() {
    // This could be used for testing error handling
  }

  /// Get order statistics
  Future<ApiResponse<OrderStats>> getOrderStats() async {
    await Future.delayed(_networkDelay);

    try {
      final stats = OrderStats(
        total: _orders.length,
        delivered: _orders.where((o) => o.status == 'Delivered').length,
        inTransit: _orders.where((o) => o.status == 'In Transit').length,
        cancelled: _orders.where((o) => o.status == 'Cancelled').length,
        processing: _orders.where((o) => o.status == 'Processing').length,
        totalRevenue: _orders
            .where((o) => o.status == 'Delivered')
            .fold(0.0, (sum, order) => sum + order.total),
      );

      return ApiResponse.success(stats);
    } catch (e) {
      return ApiResponse.error('Failed to get stats: $e');
    }
  }
}



/// Order statistics model
class OrderStats {
  final int total;
  final int delivered;
  final int inTransit;
  final int cancelled;
  final int processing;
  final double totalRevenue;

  OrderStats({
    required this.total,
    required this.delivered,
    required this.inTransit,
    required this.cancelled,
    required this.processing,
    required this.totalRevenue,
  });
}