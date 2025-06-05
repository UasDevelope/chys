import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://pet-app-phi.vercel.app/api';

  // Get auth headers
  Map<String, String> get _headers {
    final token = StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      final data = jsonDecode(response.body);
      print('here repsonse ${data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save token and user data
        if (data['token'] != null) {
          await StorageService.saveToken(data['token']);
        }
        if (data['user'] != null) {
          await StorageService.saveUser(data['user'] as Map<String, dynamic>);
        }

        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'An error occurred during registration',
      };
    }
  }

  // Method to check if user is authenticated
  bool isAuthenticated() {
    return StorageService.getToken() != null;
  }

  // Method to get current user
  Map<String, dynamic>? getCurrentUser() {
    return StorageService.getUser();
  }

  // Method to logout
  Future<void> logout() async {
    await StorageService.clearStorage();
  }

  // Add this method after the register method
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      print('Login response: $data');

      if (response.statusCode == 200) {
        // Save token and user data
        if (data['token'] != null) {
          await StorageService.saveToken(data['token']);
        }
        if (data['user'] != null) {
          await StorageService.saveUser(data['user'] as Map<String, dynamic>);
        }
        
        return {
          'success': true,
          'data': data,
        };
      } else {
        // Handle specific error messages
        String errorMessage = 'Login failed';
        if (data['message'] != null) {
          if (data['message'] == 'Invalid credentials') {
            errorMessage = 'Email or password is incorrect';
          } else {
            errorMessage = data['message'];
          }
        }
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
      };
    }
  }

  Future<Map<String, dynamic>> createPetProfile(Map<String, dynamic> petData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pet-profile'),
        headers: _headers,
        body: jsonEncode(petData),
      );

      final data = jsonDecode(response.body);
      print('Pet Profile Creation Response: $data');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create pet profile',
        };
      }
    } catch (e) {
      print('Pet Profile Creation error: $e');
      return {
        'success': false,
        'message': 'An error occurred while creating pet profile',
      };
    }
  }
}
