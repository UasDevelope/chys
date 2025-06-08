import 'dart:io';
import 'package:chys/app/services/custom_Api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../../services/api_service.dart';

class PostController extends GetxController {
  final CustomApiService _apiService = Get.put(CustomApiService());
  final descriptionController = TextEditingController();
  final selectedPhotos = <File>[].obs;
  final isLoading = false.obs;
  final descLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(() {
      descLength.value = descriptionController.text.length;
    });
  }

  Future<File> _compressImage(File file) async {
    try {
      // Read the image file
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return file;

      // Calculate new dimensions while maintaining aspect ratio
      int width = image.width;
      int height = image.height;

      // Set maximum dimensions
      const maxWidth = 1200;
      const maxHeight = 1200;

      if (width > maxWidth || height > maxHeight) {
        if (width > height) {
          height = (height * maxWidth / width).round();
          width = maxWidth;
        } else {
          width = (width * maxHeight / height).round();
          height = maxHeight;
        }
      }

      // Resize the image
      final resizedImage = img.copyResize(
        image,
        width: width,
        height: height,
      );

      // Compress the image
      final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      print('Error compressing image: $e');
      return file;
    }
  }

  Future<void> pickPhotos() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        // Limit to 5 photos
        final remainingSlots = 5 - selectedPhotos.length;
        if (remainingSlots > 0) {
          final newPhotos =
              images.take(remainingSlots).map((e) => File(e.path)).toList();

          // Compress each photo before adding
          for (var photo in newPhotos) {
            final compressedPhoto = await _compressImage(photo);
            selectedPhotos.add(compressedPhoto);
          }

          if (images.length > remainingSlots) {
            EasyLoading.showInfo('Maximum 5 photos allowed');
          }
        } else {
          EasyLoading.showInfo('Maximum 5 photos already selected');
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick images');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < selectedPhotos.length) {
      selectedPhotos.removeAt(index);
    }
  }

  Future<void> createPost() async {
    if (descriptionController.text.isEmpty && selectedPhotos.isEmpty) {
      EasyLoading.showError('Please add a description or photos');
      return;
    }

    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Creating post...',
        maskType: EasyLoadingMaskType.black,
      );

      final result = await _apiService.uploadImage(
        endpoint: "posts",
        imageFiles: selectedPhotos,
        fields: {
          'description': descriptionController.text,
        },
        imageField: 'media',
      );

      final bool success = result['success'] ?? false;
      final dynamic data = result['data'];

      if (success) {
        await EasyLoading.showSuccess('Post created successfully!');

        // Clear the form
        descriptionController.clear();
        selectedPhotos.clear();

        Get.back();
      } else {
        final errorMessage = data['message'] ?? 'Failed to create post';
        await EasyLoading.showError(errorMessage);
      }
    } catch (e) {
      print('❌ Error creating post: $e');
      await EasyLoading.showError('Failed to create post');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
