import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';
import 'network_service.dart';
import 'package:http_parser/http_parser.dart'; // for MediaType

class ApiService {
  static const String baseUrl = 'https://pet-app-phi.vercel.app/api';
  final _networkService = Get.find<NetworkService>();
  final _client = http.Client();
  static const _maxRetries = 3;
  static const _retryDelay = Duration(seconds: 1);
  static const _maxImageSize = 1 * 1024 * 1024; // 1MB in bytes

  // Get auth headers with token
  Map<String, String> get _headers {
    final token = StorageService.getToken();
    print('token here : ${token}');
    return {
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Helper function to compress image
  Future<String> compressImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();
      
      // If image is already small enough, return original path
      if (bytes.length <= _maxImageSize) {
        return imagePath;
      }

      // Decode image
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) throw Exception('Could not decode image');

      // Calculate new dimensions while maintaining aspect ratio
      int targetWidth = image.width;
      int targetHeight = image.height;
      double scale = 1.0;

      // Reduce size until the image is small enough
      while ((targetWidth * targetHeight * 4) > _maxImageSize) {
        scale *= 0.8;
        targetWidth = (image.width * scale).round();
        targetHeight = (image.height * scale).round();
      }

      // Resize image
      final img.Image resizedImage = img.copyResize(
        image,
        width: targetWidth,
        height: targetHeight,
      );

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String targetPath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Encode and save compressed image
      final File compressedFile = File(targetPath);
      await compressedFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 85));

      print('Original size: ${bytes.length}, Compressed size: ${await compressedFile.length()}');
      return targetPath;
    } catch (e) {
      print('Error compressing image: $e');
      return imagePath; // Return original path if compression fails
    }
  }

  Future<Map<String, dynamic>> _handleMultipartRequest(
    Future<http.StreamedResponse> Function() request,
  ) async {
    if (!await _networkService.checkConnection()) {
      return {
        'success': false,
        'message': 'No internet connection',
      };
    }

    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final response = await request();
        
        if (response.statusCode == 413) {
          return {
            'success': false,
            'message': 'Files are too large. Please use smaller images.',
          };
        }

        final responseBody = await response.stream.bytesToString();
        print('Response status code: ${response.statusCode}');
        print('Response body: $responseBody');

        if (responseBody.trim().isEmpty) {
          return {
            'success': false,
            'message': 'Empty response from server',
          };
        }

        try {
          final data = jsonDecode(responseBody);
          if (response.statusCode == 200 || response.statusCode == 201) {
            return {
              'success': true,
              'data': data,
            };
          } else {
            return {
              'success': false,
              'message': data['message'] ?? 'Request failed',
            };
          }
        } on FormatException catch (e) {
          print('Response is not JSON: $responseBody');
          return {
            'success': false,
            'message': 'Invalid server response: $responseBody',
          };
        }
      } on SocketException catch (e) {
        print('Socket Exception: $e');
        if (retryCount == _maxRetries - 1) {
          return {
            'success': false,
            'message': 'Unable to connect to server',
          };
        }
      } catch (e) {
        print('Unexpected error: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred',
        };
      }

      retryCount++;
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay * retryCount);
      }
    }

    return {
      'success': false,
      'message': 'Request failed after multiple attempts',
    };
  }

  Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> Function() request,
  ) async {
    if (!await _networkService.checkConnection()) {
      return {
        'success': false,
        'message': 'No internet connection',
      };
    }

    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final response = await request();
        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
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
            'message': data['message'] ?? 'Request failed',
          };
        }
      } on SocketException catch (e) {
        print('Socket Exception: $e');
        if (retryCount == _maxRetries - 1) {
          return {
            'success': false,
            'message': 'Unable to connect to server',
          };
        }
      } on HttpException catch (e) {
        print('HTTP Exception: $e');
        return {
          'success': false,
          'message': 'Unable to complete request',
        };
      } on FormatException catch (e) {
        print('Format Exception: $e');
        return {
          'success': false,
          'message': 'Invalid response format',
        };
      } catch (e) {
        print('Unexpected error: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred',
        };
      }

      retryCount++;
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay * retryCount);
      }
    }

    return {
      'success': false,
      'message': 'Request failed after multiple attempts',
    };
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? username,
  }) async {
    final result = await _handleRequest(() => _client.post(
          Uri.parse('$baseUrl/users/register'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
            'name': name,
            if (username != null) 'username': username,
          }),
        ));

    // Print token for debugging
    if (result['success']) {
      final token = StorageService.getToken();
      print('DEBUG: Token after registration: $token');
    }

    return result;
  }

  // Method to check if user is authenticated
  bool isAuthenticated() {
    final token = StorageService.getToken();
    print('DEBUG: Current token: $token');
    return token != null;
  }

  // Method to get current user
  Map<String, dynamic>? getCurrentUser() {
    return StorageService.getUser();
  }

  // Method to logout
  Future<void> logout() async {
    await StorageService.clearStorage();
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _handleRequest(() => _client.post(
          Uri.parse('$baseUrl/users/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        ));

    // Print token for debugging
    if (result['success']) {
      final token = StorageService.getToken();
      print('DEBUG: Token after login: $token');
    }

    return result;
  }

  Future<Map<String, dynamic>> createPetProfile(Map<String, dynamic> petData) async {
    print('DEBUG: Using token for pet profile creation: ${StorageService.getToken()}');

    // Validate total number of files before proceeding
    int totalFiles = 0;
    if (petData['profilePic'] != null && petData['profilePic'].toString().isNotEmpty) {
      totalFiles++;
    }
    if (petData['photos'] != null) {
      totalFiles += (petData['photos'] as List).length;
    }

    if (totalFiles > 5) {
      return {
        'success': false,
        'message': 'Maximum 5 files allowed (including profile picture). Please select fewer images.',
      };
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/pet-profile'),
    );

    // Add headers
    request.headers.addAll(_headers);

    // Helper: convert List to JSON string
    String formatArrayAsJsonString(List items) => jsonEncode(items);

    // Prepare fields
    final fieldsToAdd = {
      'isHavePet': petData['isHavePet']?.toString() ?? 'true',
      'petType': petData['petType']?.toString() ?? '',
      'name': petData['name']?.toString() ?? '',
      'breed': petData['breed']?.toString() ?? '',
      'sex': petData['sex']?.toString()?.toLowerCase() ?? '',
      'dateOfBirth': petData['dateOfBirth']?.toString() ?? '',
      'bio': petData['bio']?.toString() ?? '',
      'color': petData['color']?.toString() ?? '',
      'size': petData['size']?.toString() ?? '',
      'weight': petData['weight']?.toString() ?? '',
      'marks': petData['marks']?.toString() ?? '',
      'microchipNumber': petData['microchipNumber']?.toString() ?? '',
      'tagId': petData['tagId']?.toString() ?? '',
      'lostStatus': petData['lostStatus']?.toString() ?? 'false',
      'vaccinationStatus': petData['vaccinationStatus']?.toString() ?? 'false',
      'vetName': petData['vetName']?.toString() ?? '',
      'vetContactNumber': petData['vetContactNumber']?.toString() ?? '',
      'personalityTraits': petData['personalityTraits'] != null
          ? formatArrayAsJsonString(petData['personalityTraits'] as List)
          : '[]',
      'allergies': petData['allergies'] != null
          ? formatArrayAsJsonString(petData['allergies'] as List)
          : '[]',
      'specialNeeds': petData['specialNeeds']?.toString() ?? '',
      'feedingInstructions': petData['feedingInstructions']?.toString() ?? '',
      'dailyRoutine': petData['dailyRoutine']?.toString() ?? '',
    };

    fieldsToAdd.forEach((key, value) {
      request.fields[key] = value;
    });

    // Helper: detect MIME type from file extension
    MediaType? getMimeType(String path) {
      final ext = path.toLowerCase();
      if (ext.endsWith('.jpg') || ext.endsWith('.jpeg')) return MediaType('image', 'jpeg');
      if (ext.endsWith('.png')) return MediaType('image', 'png');
      if (ext.endsWith('.mp4')) return MediaType('video', 'mp4');
      return null;
    }

    // Handle profilePic
    if (petData['profilePic'] != null && petData['profilePic'].toString().isNotEmpty) {
      try {
        final compressedPath = await compressImage(petData['profilePic']);
        final mimeType = getMimeType(compressedPath);
        if (mimeType != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'profilePic',
            compressedPath,
            contentType: mimeType,
          ));
        } else {
          print('Invalid profilePic file type');
        }
      } catch (e) {
        print('Error adding profile picture: $e');
      }
    }

    // Handle photos - limit to remaining slots after profile pic
    if (petData['photos'] != null && (petData['photos'] as List).isNotEmpty) {
      final remainingSlots = 5 - (request.files.length); // Calculate remaining slots
      final photos = (petData['photos'] as List).take(remainingSlots).toList(); // Take only what we can fit

      for (String photoPath in photos) {
        try {
          final compressedPath = await compressImage(photoPath);
          final mimeType = getMimeType(compressedPath);
          if (mimeType != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'photos',
              compressedPath,
              contentType: mimeType,
            ));
          } else {
            print('Invalid photo file type: $photoPath');
          }
        } catch (e) {
          print('Error adding photo: $e');
        }
      }
    }

    // Debug
    print('Request fields: ${request.fields}');
    print('Request files: ${request.files.map((f) => '${f.filename} (${f.contentType})').toList()}');
    print('Total files being sent: ${request.files.length}');

    // Send request
    return _handleMultipartRequest(() => request.send());
  }


  @override
  void onClose() {
    _client.close();
  }
}
 