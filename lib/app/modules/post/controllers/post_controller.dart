// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../../../services/api_service.dart';
// import '../../../services/storage_service.dart';
//
// class PostController extends GetxController {
//   final _apiService = ApiService();
//   // final StorageService _storageService = Get.find<StorageService>();
//
//   final descriptionController = TextEditingController();
//   final characterCount = 0.obs;
//   final selectedMedia = <XFile>[].obs;
//   final isLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     descriptionController.addListener(_updateCharacterCount);
//   }
//
//   void _updateCharacterCount() {
//     characterCount.value = descriptionController.text.length;
//   }
//
//   Future<void> pickMedia() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final List<XFile> media = await picker.pickMultiImage();
//
//       if (media.isNotEmpty) {
//         selectedMedia.addAll(media);
//       }
//     } catch (e) {
//       print('Error picking media: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to pick media. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   void removeMedia(int index) {
//     if (index >= 0 && index < selectedMedia.length) {
//       selectedMedia.removeAt(index);
//     }
//   }
//
//
//
//   @override
//   void onClose() {
//     descriptionController.dispose();
//     super.onClose();
//   }
// }