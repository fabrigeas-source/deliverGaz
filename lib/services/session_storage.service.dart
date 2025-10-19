import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deliver_gaz/models.dart';

/// Service for managing user session storage using SharedPreferences
class SessionStorage {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _expiresAtKey = 'token_expires_at';
  static const String _rememberMeKey = 'remember_me';

  /// Save user session to storage
  static Future<void> saveSession({
    required User user,
    required String token,
    required DateTime expiresAt,
    bool rememberMe = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save user data as JSON
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    
    // Save authentication token
    await prefs.setString(_tokenKey, token);
    
    // Save expiration date as milliseconds since epoch
    await prefs.setInt(_expiresAtKey, expiresAt.millisecondsSinceEpoch);
    
    // Save remember me preference
    await prefs.setBool(_rememberMeKey, rememberMe);
  }

  /// Retrieve current user session from storage
  static Future<SessionData?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if user data exists
    final userJsonString = prefs.getString(_userKey);
    if (userJsonString == null) {
      return null;
    }

    try {
      // Parse user data
      final userJson = jsonDecode(userJsonString) as Map<String, dynamic>;
      final user = User.fromJson(userJson);
      
      // Get token and expiration
      final token = prefs.getString(_tokenKey);
      final expiresAtMs = prefs.getInt(_expiresAtKey);
      final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
      
      if (token == null || expiresAtMs == null) {
        return null;
      }
      
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtMs);
      
      // Check if token has expired
      if (DateTime.now().isAfter(expiresAt)) {
        // Token expired, clear session
        await clearSession();
        return null;
      }
      
      return SessionData(
        user: user,
        token: token,
        expiresAt: expiresAt,
        rememberMe: rememberMe,
      );
      
    } catch (e) {
      // Error parsing session data, clear it
      await clearSession();
      return null;
    }
  }

  /// Check if user is currently logged in with valid session
  static Future<bool> isLoggedIn() async {
    final session = await getSession();
    return session != null;
  }

  /// Clear current user session
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiresAtKey);
    await prefs.remove(_rememberMeKey);
  }

  /// Get current user if logged in
  static Future<User?> getCurrentUser() async {
    final session = await getSession();
    return session?.user;
  }

  /// Get current auth token if valid
  static Future<String?> getAuthToken() async {
    final session = await getSession();
    return session?.token;
  }

  /// Check if remember me was enabled
  static Future<bool> getRememberMe() async {
    final session = await getSession();
    return session?.rememberMe ?? false;
  }

  /// Update last login time for current user
  static Future<void> updateLastLogin() async {
    final session = await getSession();
    if (session != null) {
      final updatedUser = User(
        id: session.user.id,
        firstName: session.user.firstName,
        lastName: session.user.lastName,
        email: session.user.email,
        phoneNumber: session.user.phoneNumber,
        createdAt: session.user.createdAt,
        lastLoginAt: DateTime.now(),
      );
      
      await saveSession(
        user: updatedUser,
        token: session.token,
        expiresAt: session.expiresAt,
        rememberMe: session.rememberMe,
      );
    }
  }
}

/// Data class for session information
class SessionData {
  final User user;
  final String token;
  final DateTime expiresAt;
  final bool rememberMe;

  SessionData({
    required this.user,
    required this.token,
    required this.expiresAt,
    required this.rememberMe,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());
}