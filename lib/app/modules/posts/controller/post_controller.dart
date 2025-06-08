import 'dart:io';
import 'package:chys/app/services/custom_Api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_service.dart';

class PostController extends GetxController {
  final CustomApiService _apiService = Get.put(CustomApiService());
  final descriptionController = TextEditingController();
  final selectedPhotos = <File>[].obs;
  final isLoading = false.obs;

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
          selectedPhotos.addAll(newPhotos);

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
        imageFiles: selectedPhotos, // ✅ Pass the File list directly
        fields: {
          'description':
              descriptionController.text, // ✅ Send text with the request
        },
        imageField: 'media', // ✅ Adjust to match backend expectation
      );

      if (result['success'] == true) {
        await EasyLoading.showSuccess('Post created successfully!');
        // Clear the form
        descriptionController.clear();
        selectedPhotos.clear();
        Get.back(); // Optionally go back
      } else {
        await EasyLoading.showError(
            result['message'] ?? 'Failed to create post');
      }
    } catch (e) {
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
