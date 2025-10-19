import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/mock.dart';
import 'api_base.service.dart';

/// API client for orders management
/// This provides a clean interface to the mock API service
class OrdersApiClient {
  static final OrdersApiClient _instance = OrdersApiClient._internal();
  factory OrdersApiClient() => _instance;
  OrdersApiClient._internal();

  final MockApiService _mockApi = MockApiService();

  /// Fetch all orders with optional filtering and sorting
  Future<List<Order>> fetchOrders({
    String? status,
    String? sortBy,
    bool ascending = false,
  }) async {
    final response = await _mockApi.getOrders(
      status: status,
      sortBy: sortBy,
      ascending: ascending,
    );

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Fetch a specific order by ID
  Future<Order> fetchOrder(String id) async {
    final response = await _mockApi.getOrder(id);

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Create a new order
  Future<Order> createOrder({
    required double total,
    required List<String> items,
  }) async {
    final response = await _mockApi.createOrder(
      total: total,
      items: items,
    );

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Update order status
  Future<Order> updateOrderStatus(String id, String status) async {
    final response = await _mockApi.updateOrderStatus(id, status);

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Cancel an order
  Future<void> cancelOrder(String id) async {
    final response = await _mockApi.cancelOrder(id);

    if (!response.isSuccess) {
      throw ApiException(response.error!);
    }
  }

  /// Get order statistics
  Future<OrderStats> fetchOrderStats() async {
    final response = await _mockApi.getOrderStats();

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }
}

