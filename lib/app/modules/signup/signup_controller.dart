import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool showPassword = false.obs;

  RxBool agreePolicy1 = true.obs;
  RxBool agreePolicy2 = true.obs;
  RxBool agreePolicy3 = true.obs;

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void submitSignup() {
    if (formKey.currentState?.validate() ?? false) {
      // Proceed with signup logic
      print("Sign Up Successful");
    }
  }
}
