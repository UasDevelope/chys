import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

class LoginController extends GetxController {
  final _apiService = ApiService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final showPassword = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in
    if (StorageService.getToken() != null) {
      Get.offAllNamed(AppRoutes.map);
    }
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  Future<void> handleLogin() async {
    try {
      if (!_validateForm()) return;

      isLoading.value = true;
      await EasyLoading.show(
        status: 'Logging in...',
        maskType: EasyLoadingMaskType.black,
      );

      final result = await _apiService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      await EasyLoading.dismiss();

      if (result['success']) {
        // Clear any existing token and user data
        await StorageService.clearStorage();
        
        // Save new token and user data
        if (result['data']['token'] != null) {
          await StorageService.saveToken(result['data']['token']);
        }
        if (result['data']['user'] != null) {
          await StorageService.saveUser(result['data']['user']);
        }

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          isDismissible: true,
        );
        Get.offAllNamed(AppRoutes.map);
      } else {
        // Clear password field on error
        passwordController.clear();

        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          isDismissible: true,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        isDismissible: true,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        isDismissible: true,
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        isDismissible: true,
      );
      return false;
    }

    return true;
  }

  void navigateToSignup() {
    Get.toNamed(AppRoutes.signup);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
