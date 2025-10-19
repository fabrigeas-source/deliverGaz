import 'dart:async';
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';

/// Mock API service for user management and authentication
class MockUserApiService {
  static final MockUserApiService _instance = MockUserApiService._internal();
  factory MockUserApiService() => _instance;
  MockUserApiService._internal();

  // Simulate network delay
  static const Duration _networkDelay = Duration(milliseconds: 600);

  // Mock user database
  final List<User> _users = [
    User(
      id: 'user_001',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+1234567890',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    User(
      id: 'user_002',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane.smith@example.com',
      phoneNumber: '+1234567891',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Mock addresses database
  final Map<String, List<Address>> _userAddresses = {
    'user_001': [
      Address(
        id: 'addr_001',
        street: '123 Main Street',
        city: 'New York',
        state: 'NY',
        postalCode: '10001',
        country: 'USA',
        isDefault: true,
        label: 'Home',
      ),
      Address(
        id: 'addr_002',
        street: '456 Business Ave',
        city: 'New York',
        state: 'NY',
        postalCode: '10002',
        country: 'USA',
        isDefault: false,
        label: 'Work',
      ),
    ],
  };

  User? _currentUser;
  String? _authToken;

  /// POST /api/auth/login
  /// Authenticate user with email and password
  Future<ApiResponse<AuthResult>> login(String email, String password) async {
    await Future.delayed(_networkDelay);

    try {
      // Simple mock authentication
      final user = _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('Invalid credentials'),
      );

      // Mock password validation (in real app, this would be secure)
      if (password.length < 6) {
        throw Exception('Invalid credentials');
      }

      _currentUser = user;
      _authToken = 'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

      final authResult = AuthResult(
        user: user,
        token: _authToken!,
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      return ApiResponse.success(authResult);
    } catch (e) {
      return ApiResponse.error('Login failed: $e');
    }
  }

  /// POST /api/auth/register
  /// Register a new user
  Future<ApiResponse<AuthResult>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    await Future.delayed(_networkDelay);

    try {
      // Check if user already exists
      final existingUser = _users.where((u) => u.email.toLowerCase() == email.toLowerCase());
      if (existingUser.isNotEmpty) {
        throw Exception('User with this email already exists');
      }

      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      _users.add(newUser);
      _currentUser = newUser;
      _authToken = 'mock_token_${newUser.id}_${DateTime.now().millisecondsSinceEpoch}';

      final authResult = AuthResult(
        user: newUser,
        token: _authToken!,
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      return ApiResponse.success(authResult);
    } catch (e) {
      return ApiResponse.error('Registration failed: $e');
    }
  }

  /// POST /api/auth/logout
  /// Logout current user
  Future<ApiResponse<void>> logout() async {
    await Future.delayed(_networkDelay);

    _currentUser = null;
    _authToken = null;

    return ApiResponse.success(null);
  }

  /// GET /api/user/profile
  /// Get current user profile
  Future<ApiResponse<User>> getProfile() async {
    await Future.delayed(_networkDelay);

    if (_currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }

    return ApiResponse.success(_currentUser!);
  }

  /// PUT /api/user/profile
  /// Update user profile
  Future<ApiResponse<User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    await Future.delayed(_networkDelay);

    if (_currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }

    try {
      final updatedUser = User(
        id: _currentUser!.id,
        firstName: firstName ?? _currentUser!.firstName,
        lastName: lastName ?? _currentUser!.lastName,
        email: _currentUser!.email,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        createdAt: _currentUser!.createdAt,
        lastLoginAt: _currentUser!.lastLoginAt,
        isActive: _currentUser!.isActive,
      );

      // Update in mock database
      final index = _users.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _users[index] = updatedUser;
      }

      _currentUser = updatedUser;
      return ApiResponse.success(updatedUser);
    } catch (e) {
      return ApiResponse.error('Failed to update profile: $e');
    }
  }

  /// GET /api/user/addresses
  /// Get user addresses
  Future<ApiResponse<List<Address>>> getAddresses() async {
    await Future.delayed(_networkDelay);

    if (_currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }

    try {
      final addresses = _userAddresses[_currentUser!.id] ?? [];
      return ApiResponse.success(addresses);
    } catch (e) {
      return ApiResponse.error('Failed to fetch addresses: $e');
    }
  }

  /// POST /api/user/addresses
  /// Add new address
  Future<ApiResponse<Address>> addAddress({
    required String street,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    bool isDefault = false,
    String? label,
  }) async {
    await Future.delayed(_networkDelay);

    if (_currentUser == null) {
      return ApiResponse.error('User not authenticated');
    }

    try {
      final newAddress = Address(
        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
        street: street,
        city: city,
        state: state,
        postalCode: postalCode,
        country: country,
        isDefault: isDefault,
        label: label,
      );

      if (_userAddresses[_currentUser!.id] == null) {
        _userAddresses[_currentUser!.id] = [];
      }

      // If this is set as default, remove default from others
      if (isDefault) {
        for (var _ in _userAddresses[_currentUser!.id]!) {
          // This would update the address in a real database
          // For now, we just mark it in memory
        }
      }

      _userAddresses[_currentUser!.id]!.add(newAddress);
      return ApiResponse.success(newAddress);
    } catch (e) {
      return ApiResponse.error('Failed to add address: $e');
    }
  }

  /// GET /api/auth/check
  /// Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null && _authToken != null;
  }

  /// Get current user (local only)
  User? getCurrentUser() {
    return _currentUser;
  }
}

/// Authentication result model
class AuthResult {
  final User user;
  final String token;
  final DateTime expiresAt;

  AuthResult({
    required this.user,
    required this.token,
    required this.expiresAt,
  });
}