import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';
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
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Join CHYS!", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text("Enter your details to create an account.",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),

              CustomTextField(
                controller: controller.emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              Obx(() => CustomTextField(
                controller: controller.passwordController,
                label: 'Password',
                obscureText: !controller.showPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(controller.showPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),
              const SizedBox(height: 16),

              CustomTextField(
                controller: controller.confirmPasswordController,
                label: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 24),

              Obx(() => CustomCheckboxTile(
                value: controller.agreePolicy1.value,
                onChanged: (v) => controller.agreePolicy1.value = v!,
                text:
                "I agree to the data processing policy of the service",
              )),
              Obx(() => CustomCheckboxTile(
                value: controller.agreePolicy2.value,
                onChanged: (v) => controller.agreePolicy2.value = v!,
                text: "I accept the End-User License Agreement",
              )),
              Obx(() => CustomCheckboxTile(
                value: controller.agreePolicy3.value,
                onChanged: (v) => controller.agreePolicy3.value = v!,
                text:
                "I agree with the Policy on Child Safety Standards",
              )),
              const SizedBox(height: 24),

              PrimaryButton(
                label: "Sign Up",
                onPressed: controller.submitSignup,
              ),
              const SizedBox(height: 20),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: "Log in!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
