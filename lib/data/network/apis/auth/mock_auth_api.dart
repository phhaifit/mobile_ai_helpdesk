import 'package:ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/data/models/auth/register_request.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';
import 'package:ai_helpdesk/data/network/apis/auth/auth_api.dart';

/// Fully in-memory [AuthApi] for offline testing and CI.
class MockAuthApi implements AuthApi {
  static final Map<String, Map<String, dynamic>> _users = {
    'test@example.com': {
      'id': 'user_mock_1',
      'email': 'test@example.com',
      'username': 'Test User',
      'password': 'Test@123456',
      'roles': ['user'],
    },
  };

  @override
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = _users[request.email];
    if (user == null || user['password'] != request.password) {
      throw Exception('Invalid email or password');
    }
    return {
      'access_token': 'mock_access_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token': 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': user['id'],
    };
  }

  @override
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_users.containsKey(request.email)) {
      throw Exception('Email already registered');
    }
    final id = 'user_mock_${DateTime.now().millisecondsSinceEpoch}';
    _users[request.email] = {
      'id': id,
      'email': request.email,
      'username': request.username,
      'password': request.password,
      'roles': ['user'],
    };
    return {
      'access_token': 'mock_access_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token': 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': id,
    };
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (accessToken.isEmpty) throw Exception('Invalid token');
    final user = _users.values.first;
    return {
      'id': user['id'],
      'email': user['email'],
      'username': user['username'],
      'roles': user['roles'],
    };
  }

  @override
  Future<void> logout(String accessToken, String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (refreshToken.isEmpty) throw Exception('Invalid refresh token');
    return {
      'access_token': 'mock_access_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  @override
  Future<void> changePassword(
    ChangePasswordRequest request,
    String accessToken,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = _users.values.first;
    if (user['password'] != request.currentPassword) {
      throw Exception('Current password is incorrect');
    }
    user['password'] = request.newPassword;
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = _users[request.email];
    if (user == null) throw Exception('User not found');
    user['password'] = request.newPassword;
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> fields,
    String accessToken,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return fields;
  }

  @override
  Future<Map<String, dynamic>> uploadAvatar(
    String filePath,
    String accessToken,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'avatar': 'https://via.placeholder.com/150'};
  }
}
