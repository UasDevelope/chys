import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  final descriptionController = TextEditingController();
  final characterCount = 0.obs;
  final selectedMedia = Rxn<XFile>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(_updateCharacterCount);
  }

  void _updateCharacterCount() {
    characterCount.value = descriptionController.text.length;
  }

  Future<void> pickMedia() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? media = await picker.pickImage(source: ImageSource.gallery);
      
      if (media != null) {
        selectedMedia.value = media;
      }
    } catch (e) {
      print('Error picking media: $e');
      Get.snackbar(
        'Error',
        'Failed to pick media. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> submitPost() async {
    if (descriptionController.text.trim().isEmpty && selectedMedia.value == null) {
      Get.snackbar(
        'Error',
        'Please add a photo/video or write a description',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // TODO: Implement post submission logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Post created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error submitting post: $e');
      Get.snackbar(
        'Error',
        'Failed to create post. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
} 