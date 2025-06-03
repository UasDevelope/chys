import 'package:chys/app/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/signup_controller.dart';
import 'widgets/custom_checkbox_tile.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/primary_button.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const BackButton(),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Join CHYS!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Enter your details to create an account.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  fillColor: AppColors.Cultured,
                  borderColor: AppColors.Gunmetal,
                  controller: controller.emailController,
                  label: 'Email',
                  filled: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  borderColor: AppColors.Gunmetal,

                  fillColor: AppColors.Cultured,
                  filled: true,
                  obscureText: !controller.showPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.showPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  filled: true,
                  controller: controller.confirmPasswordController,
                  label: 'Confirm Password',
                  fillColor: AppColors.Cultured,
                  borderColor: AppColors.Gunmetal,
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                CustomCheckboxTile(
                  value: controller.agreePolicy1.value,
                  onChanged: (v) => controller.agreePolicy1.value = v!,
                  text: "I agree to the data processing policy of the service",
                ),
                CustomCheckboxTile(
                  value: controller.agreePolicy2.value,
                  onChanged: (v) => controller.agreePolicy2.value = v!,
                  text: "I accept the End-User License Agreement",
                ),
                CustomCheckboxTile(
                  value: controller.agreePolicy3.value,
                  onChanged: (v) => controller.agreePolicy3.value = v!,
                  text: "I agree with the Policy on Child Safety Standards",
                ),
                const SizedBox(height: 24),

                PrimaryButton(
                  backgroundColor: AppColors.blue,
                  label: "Sign Up",

                  onPressed: controller.submitSignup,
                ),
                 SizedBox(height: 20),
                Center(
                  child: RichText(

                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: AppColors.Gunmetal),
                      children: [
                        TextSpan(
                          text: "Log in!",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
