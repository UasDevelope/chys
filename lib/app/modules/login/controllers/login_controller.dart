import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_service.dart';

class LoginController extends GetxController {
  final _apiService = ApiService();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final showPassword = false.obs;
  final isLoading = false.obs;

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