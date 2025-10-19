import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/mock.dart';
import 'api_base.service.dart';

/// API client for products management
class ProductsApiClient {
  static final ProductsApiClient _instance = ProductsApiClient._internal();
  factory ProductsApiClient() => _instance;
  ProductsApiClient._internal();

  final MockProductsApiService _mockApi = MockProductsApiService();

  /// Fetch all products with optional filtering
  Future<List<OrderItem>> fetchProducts({
    String? category,
    String? search,
  }) async {
    final response = await _mockApi.getProducts(
      category: category,
      search: search,
    );

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Fetch a specific product by ID
  Future<OrderItem> fetchProduct(String id) async {
    final response = await _mockApi.getProduct(id);

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Fetch all product categories
  Future<List<String>> fetchCategories() async {
    final response = await _mockApi.getCategories();

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Fetch featured products
  Future<List<OrderItem>> fetchFeaturedProducts() async {
    final response = await _mockApi.getFeaturedProducts();

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }
}

