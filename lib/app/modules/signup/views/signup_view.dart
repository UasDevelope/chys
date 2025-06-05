import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/validators/form_validators.dart';
import '../controller/signup_controller.dart';
import '../widgets/custom_checkbox_tile.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class SignupView extends GetView<SignupController> {
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isFormvalid = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(
          () => SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText(
                            text: "Join CHYS!",
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          IconButton(
                            icon: Icon(Icons.help_outline,
                                color: AppColors.gunmetal),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const AppText(
                        text: "Enter your details to create an account.",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.purple,
                      ),
                      // const SizedBox(height: 32),
                      // AppText(
                      //   text: "Email",
                      //   fontWeight: FontWeight.w400,
                      //   color: AppColors.purple,
                      //   fontSize: 14,
                      // ),
                      //  SizedBox(height: 10),
                      //
                      // CustomTextField(
                      //   controller: controller.usernameController,
                      //   label: 'Username',
                      //   fillColor: AppColors.cultured,
                      //   borderColor: AppColors.gunmetal,
                      //   filled: true,
                      //   keyboardType: TextInputType.text,
                      //   textInputAction: TextInputAction.next,
                      // ),
                      const SizedBox(height: 20),
                      const AppText(
                        text: "Full Name",
                        fontWeight: FontWeight.w400,
                        color: AppColors.purple,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: controller.nameController,
                        label: 'Full Name',
                        onChanged: (_) {
                          isFormvalid.value =
                              formKey.currentState?.validate() ?? false;
                        },
                        fillColor: AppColors.cultured,
                        borderColor: AppColors.gunmetal,
                        filled: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      const AppText(
                        text: "Email",
                        fontWeight: FontWeight.w400,
                        color: AppColors.purple,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: controller.emailController,
                        label: 'Email',
                        onChanged: (_) {
                          isFormvalid.value =
                              formKey.currentState?.validate() ?? false;
                        },
                        fillColor: AppColors.cultured,
                        borderColor: AppColors.gunmetal,
                        filled: true,
                        validator: FormValidators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      const AppText(
                        text: "Password",
                        fontWeight: FontWeight.w400,
                        color: AppColors.purple,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        validator: FormValidators.validatePassword,
                        controller: controller.passwordController,
                        label: 'Password',
                        fillColor: AppColors.cultured,
                        borderColor: AppColors.gunmetal,
                        filled: true,
                        onChanged: (_) {
                          isFormvalid.value =
                              formKey.currentState?.validate() ?? false;
                        },
                        obscureText: !controller.showPassword.value,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.showPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.purple,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const AppText(
                        text: "Confirm Password",
                        fontWeight: FontWeight.w400,
                        color: AppColors.purple,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        obscureText: !controller.showPassword.value,
                        validator: (value) =>
                            FormValidators.validateConfirmPassword(
                          value,
                          controller.passwordController.text,
                        ),
                        onChanged: (_) {
                          isFormvalid.value =
                              formKey.currentState?.validate() ?? false;
                        },
                        controller: controller.confirmPasswordController,
                        label: 'Confirm Password',
                        fillColor: AppColors.cultured,
                        borderColor: AppColors.gunmetal,
                        filled: true,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 32),

                      CustomCheckboxTile(
                        value: controller.agreePolicy1.value,
                        onChanged: (v) => controller.agreePolicy1.value = v!,
                        text:
                            "I agree to the data processing policy of the service",
                      ),
                      CustomCheckboxTile(
                        value: controller.agreePolicy2.value,
                        onChanged: (v) => controller.agreePolicy2.value = v!,
                        text: "I accept the End-User License Agreement",
                      ),
                      CustomCheckboxTile(
                        value: controller.agreePolicy3.value,
                        onChanged: (v) => controller.agreePolicy3.value = v!,
                        text:
                            "I agree with the Policy on Child Safety Standards",
                      ),
                      const SizedBox(height: 32),

                      ValueListenableBuilder<bool>(
                        valueListenable: isFormvalid,
                        builder: (context, valid, _) {
                          return PrimaryButton(
                            backgroundColor: AppColors.blue,
                            label: "Sign Up",
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                controller.handleSignup();
                              }
                            },
                            isEnabled: valid,
                            // isLoading: controller.isLoading.value,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                    color:
                                        AppColors.onBackground.withOpacity(0.7),
                                  ),
                              children: const [
                                TextSpan(
                                  text: "Log in!",
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
