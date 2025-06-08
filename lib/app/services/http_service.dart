import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chys/app/services/storage_service.dart';
import 'package:http/http.dart' as http;

class ApiEndPoints {
  static const String petProfile = "/pet-profile";
}

class ApiClient {
  static const String _defaultBaseUrl = "https://pet-app-phi.vercel.app/api";
  final String baseUrl;

  ApiClient({this.baseUrl = _defaultBaseUrl});

  Map<String, String> _getHeaders() {
    final token = StorageService.getToken();
    print('token here : $token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> _processResponse(http.Response response) async {
    log("Response: ${response.body}, Status Code: ${response.statusCode}");
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        log("Error: Status Code: ${response.statusCode}, Body: $errorResponse");
        throw Exception(errorResponse['message'] ??
            errorResponse["msg"] ??
            "An unknown error occurred");
      }
    } on FormatException {
      throw Exception("Invalid response format");
    }
  }

  Future<dynamic> _handleRequest(Future<http.Response> request) async {
    try {
      final response = await request;
      return await _processResponse(response);
    } on SocketException {
      throw Exception("No internet connection");
    } on HttpException {
      throw Exception("Server error");
    } on FormatException {
      throw Exception("Invalid response format");
    } catch (e, stacktrace) {
      log("Error $e,$stacktrace");
      throw Exception("$e");
    }
  }

  Future<dynamic> get(String endpoint) async {
    final url = '$baseUrl$endpoint';
    log("GET Request: $url");
    return _handleRequest(http.get(Uri.parse(url), headers: _getHeaders()));
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl$endpoint';
    log("POST Request: $url, Data: $data and data type of data ${data.runtimeType}");
    return _handleRequest(http.post(
      Uri.parse(url),
      headers: _getHeaders(),
      body: jsonEncode(data),
    ));
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = '$baseUrl$endpoint';
    log("PUT Request: $url, Data: $data");
    return _handleRequest(http.put(
      Uri.parse(url),
      headers: _getHeaders(),
      body: jsonEncode(data),
    ));
  }

  Future<dynamic> delete(String endpoint) async {
    final url = '$baseUrl$endpoint';
    log("DELETE Request: $url");
    return _handleRequest(http.delete(
      Uri.parse(url),
      headers: _getHeaders(),
    ));
  }
}
