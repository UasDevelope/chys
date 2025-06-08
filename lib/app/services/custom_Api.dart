import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chys/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CustomApiService extends GetxService {
  final String baseUrl = 'https://pet-app-phi.vercel.app/api'; // Replace this

  // You can store token here if using Auth
  String? token;

  Map<String, String> getHeaders({bool isJson = true}) {
    final token = StorageService.getToken();

    final headers = <String, String>{
      if (isJson) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return headers;
  }

  /// GET request
  Future<dynamic> getRequest(String endpoint) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(uri, headers: getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('GET failed: ${response.statusCode} → ${response.body}');
    }
  }

  /// POST request with JSON body
  Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      uri,
      headers: getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('POST failed: ${response.statusCode} → ${response.body}');
    }
  }

  /// DELETE request
  Future<dynamic> deleteRequest(String endpoint) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(uri, headers: getHeaders());

    if (response.statusCode == 200 || response.statusCode == 204) {
      return {'status': 'deleted'};
    } else {
      throw Exception(
          'DELETE failed: ${response.statusCode} → ${response.body}');
    }
  }

  Future<Map<String, dynamic>> uploadImage({
    required String endpoint,
    required List<File> imageFiles,
    Map<String, String>? fields,
    String imageField = 'media', // name of the image field as accepted by API
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    log("📤 [UPLOAD] Request URI: $uri");

    final request = http.MultipartRequest('POST', uri);

    // Get token from storage and add headers
    final token = StorageService.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      log("🔐 [UPLOAD] Using token: Bearer $token");
    }

    // Attach image files
    for (File file in imageFiles) {
      final mimeType = lookupMimeType(file.path);
      if (mimeType == null || !mimeType.contains('/')) {
        throw Exception("❌ Invalid MIME type for file: ${file.path}");
      }

      final mediaType = mimeType.split('/');

      log("📎 [UPLOAD] Adding file: ${file.path} with MIME: $mimeType");

      request.files.add(
        await http.MultipartFile.fromPath(
          imageField,
          file.path,
          contentType: MediaType(mediaType[0], mediaType[1]),
        ),
      );
    }

    // Add additional fields if available
    if (fields != null && fields.isNotEmpty) {
      request.fields.addAll(fields);
      log("📝 [UPLOAD] Fields: ${jsonEncode(fields)}");
    }

    try {
      log("🚀 [UPLOAD] Sending request...");
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      final statusCode = streamedResponse.statusCode;

      log("📩 [UPLOAD] Response Code: $statusCode");
      log("📨 [UPLOAD] Response Body: $responseBody");

      final decoded = jsonDecode(responseBody);

      return {
        'success': statusCode == 200 || statusCode == 201,
        'code': statusCode,
        'data': decoded,
      };
    } catch (e) {
      log("❌ [UPLOAD] Error: $e");
      return {
        'success': false,
        'code': 500,
        'data': {'message': e.toString()},
      };
    }
  }

}
