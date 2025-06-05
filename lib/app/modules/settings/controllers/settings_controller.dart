import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final pushNotifications = true.obs;
  final emailNotifications = true.obs;
  final isDarkMode = false.obs;

  void togglePushNotifications(bool value) => pushNotifications.value = value;
  void toggleEmailNotifications(bool value) => emailNotifications.value = value;
  void toggleDarkMode(bool value) => isDarkMode.value = value;

  void onProfileTap() => Get.toNamed(AppRoutes.profile);
  void onPrivacyTap() => Get.toNamed(AppRoutes.privacy);
  void onSecurityTap() => Get.toNamed(AppRoutes.security);
  void onLanguageTap() => Get.toNamed(AppRoutes.language);
  void onHelpCenterTap() => Get.toNamed(AppRoutes.helpCenter);
  void onContactUsTap() => Get.toNamed(AppRoutes.contactUs);
  void onTermsTap() => Get.toNamed(AppRoutes.terms);
  void onPrivacyPolicyTap() => Get.toNamed(AppRoutes.privacyPolicy);
  
  Future<void> onLogoutTap() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Get.back(result: false),
          ),
          TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement logout logic
      Get.offAllNamed(AppRoutes.login);
    }
  }
} 