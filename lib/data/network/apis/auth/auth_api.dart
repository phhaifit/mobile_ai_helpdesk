import 'package:ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/data/models/auth/register_request.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';

/// Mock Auth API for offline testing
/// In production, replace with real Dio HTTP calls
class AuthApi {
  // Mock user database
  static final Map<String, Map<String, dynamic>> _mockUsers = {
    'test@example.com': {
      'id': 'user_1',
      'email': 'test@example.com',
      'username': 'testuser',
      'password':
          'Test@123456', // Mock password - NEVER store plain in real app
      'avatar': null,
      'phone': null,
      'fullName': 'Test User',
      'createdAt': DateTime(2024, 1, 1),
      'updatedAt': DateTime(2024, 1, 1),
    },
  };

  /// Mock login API call
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final user = _mockUsers[request.email];

    if (user == null) {
      throw Exception('Email not found');
    }

    if (user['password'] != request.password) {
      throw Exception('Invalid password');
    }

    return {
      'token': 'mock_jwt_token_${DateTime.now().millisecond}',
      'refreshToken': 'mock_refresh_token_${DateTime.now().millisecond}',
      'user': {
        'id': user['id'],
        'email': user['email'],
        'username': user['username'],
        'avatar': user['avatar'],
        'phone': user['phone'],
        'fullName': user['fullName'],
        'createdAt': (user['createdAt'] as DateTime).toIso8601String(),
        'updatedAt': (user['updatedAt'] as DateTime).toIso8601String(),
      },
    };
  }

  /// Mock register API call
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if email already exists
    if (_mockUsers.containsKey(request.email)) {
      throw Exception('Email already registered');
    }

    // Mock register success - add user to mock database
    final newUser = {
      'id': 'user_${DateTime.now().millisecond}',
      'email': request.email,
      'username': request.username,
      'password': request.password,
      'avatar': null,
      'phone': null,
      'fullName': request.username,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    _mockUsers[request.email] = newUser;

    return {
      'token': 'mock_jwt_token_${DateTime.now().millisecond}',
      'refreshToken': 'mock_refresh_token_${DateTime.now().millisecond}',
      'user': {
        'id': newUser['id'],
        'email': newUser['email'],
        'username': newUser['username'],
        'avatar': newUser['avatar'],
        'phone': newUser['phone'],
        'fullName': newUser['fullName'],
        'createdAt': (newUser['createdAt'] as DateTime).toIso8601String(),
        'updatedAt': (newUser['updatedAt'] as DateTime).toIso8601String(),
      },
    };
  }

  /// Mock get current user API call
  Future<Map<String, dynamic>> getCurrentUser(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock validate token and return first user
    if (token.isEmpty) {
      throw Exception('Invalid token');
    }

    final user = _mockUsers.values.first;

    return {
      'id': user['id'],
      'email': user['email'],
      'username': user['username'],
      'avatar': user['avatar'],
      'phone': user['phone'],
      'fullName': user['fullName'],
      'createdAt': user['createdAt'].toIso8601String(),
      'updatedAt': user['updatedAt'].toIso8601String(),
    };
  }

  /// Mock logout API call
  Future<void> logout(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // In mock, just simulate success
  }

  /// Mock change password API call
  Future<void> changePassword(
    ChangePasswordRequest request,
    String token,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validate token
    if (token.isEmpty) {
      throw Exception('Invalid token');
    }

    // For mock, we assume current user is the first in the list
    final user = _mockUsers.values.first;

    if (user['password'] != request.currentPassword) {
      throw Exception('Current password is incorrect');
    }

    // Update password in mock database
    user['password'] = request.newPassword;
  }

  /// Mock request password reset API call
  Future<void> requestPasswordReset(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!_mockUsers.containsKey(email)) {
      // For security, don't reveal if email exists
      return;
    }

    // Mock: send reset email (in real app, backend sends email)
  }

  /// Mock reset password API call
  Future<void> resetPassword(ResetPasswordRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final user = _mockUsers[request.email];
    if (user == null) {
      throw Exception('User not found');
    }

    // Mock validate reset token (in real app, validate against DB)
    if (request.token != 'mock_reset_token_${request.email}') {
      throw Exception('Invalid reset token');
    }

    // Update password
    user['password'] = request.newPassword;
  }

  /// Mock refresh token API call
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (refreshToken.isEmpty) {
      throw Exception('Invalid refresh token');
    }

    final user = _mockUsers.values.first;

    return {
      'token': 'mock_jwt_token_${DateTime.now().millisecond}',
      'refreshToken': 'mock_refresh_token_${DateTime.now().millisecond}',
      'user': {
        'id': user['id'],
        'email': user['email'],
        'username': user['username'],
        'avatar': user['avatar'],
        'phone': user['phone'],
        'fullName': user['fullName'],
        'createdAt': user['createdAt'].toIso8601String(),
        'updatedAt': user['updatedAt'].toIso8601String(),
      },
    };
  }
}
