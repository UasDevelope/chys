import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _storage = GetStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  // Get token
  static String? getToken() {
    return _storage.read(_tokenKey);
  }

  // Save user data
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(_userKey, userData);
  }

  // Get user data
  static Map<String, dynamic>? getUser() {
    return _storage.read(_userKey);
  }

  // Clear storage (for logout)
  static Future<void> clearStorage() async {
    await _storage.erase();
  }
} 