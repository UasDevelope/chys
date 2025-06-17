    import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/custom_Api.dart';

class HomeController extends GetxController {
  // Add logic later
  final CustomApiService _apiService = Get.put(CustomApiService());
  final captionController = TextEditingController();
  final selectedMedia = Rxn<File>();
  final isLoading = false.obs;

  Future<void> pickMedia() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? media = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (media != null) {
        selectedMedia.value = File(media.path);
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick media');
    }
  }

  Future<void> uploadStory() async {
    if (selectedMedia.value == null) {
      EasyLoading.showError('Please select a media file');
      return;
    }

    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Uploading story...',
        maskType: EasyLoadingMaskType.black,
      );

      final result = await _apiService.uploadStory(
        mediaFile: selectedMedia.value!,
        caption: captionController.text.trim(),
      );

      if (result['success'] == true) {
        await EasyLoading.showSuccess('Story uploaded successfully!');
        // Clear the form
        captionController.clear();
        selectedMedia.value = null;
        Get.back(); // Go back to previous screen
      } else {
        await EasyLoading.showError(
            result['message'] ?? 'Failed to upload story');
      }
    } catch (e) {
      await EasyLoading.showError('Failed to upload story');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    captionController.dispose();
    super.onClose();
  }
}
