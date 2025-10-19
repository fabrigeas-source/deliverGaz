import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/mock.dart';
import 'api_base.service.dart';

/// API client for user management and authentication
class UserApiClient {
  static final UserApiClient _instance = UserApiClient._internal();
  factory UserApiClient() => _instance;
  UserApiClient._internal();

  final MockUserApiService _mockApi = MockUserApiService();

  /// Login with email and password
  Future<AuthResult> login(String email, String password) async {
    final response = await _mockApi.login(email, password);

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Register a new user
  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final response = await _mockApi.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Logout current user
  Future<void> logout() async {
    final response = await _mockApi.logout();

    if (!response.isSuccess) {
      throw ApiException(response.error!);
    }
  }

  /// Get current user profile
  Future<User> getProfile() async {
    final response = await _mockApi.getProfile();

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Update user profile
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    final response = await _mockApi.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
    );

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Get user addresses
  Future<List<Address>> getAddresses() async {
    final response = await _mockApi.getAddresses();

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Add new address
  Future<Address> addAddress({
    required String street,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    bool isDefault = false,
    String? label,
  }) async {
    final response = await _mockApi.addAddress(
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      label: label,
    );

    if (response.isSuccess) {
      return response.data!;
    } else {
      throw ApiException(response.error!);
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _mockApi.isAuthenticated();
  }

  /// Get current user (local only)
  User? getCurrentUser() {
    return _mockApi.getCurrentUser();
  }
}

