import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/settings_controller.dart';
import '../../../core/const/app_text.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          text: 'Settings',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Account'),
              _buildSettingTile(
                'Profile',
                Icons.person_outline,
                onTap: () => controller.onProfileTap(),
              ),
              _buildSettingTile(
                'Privacy',
                Icons.lock_outline,
                onTap: () => controller.onPrivacyTap(),
              ),
              _buildSettingTile(
                'Security',
                Icons.security,
                onTap: () => controller.onSecurityTap(),
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Notifications'),
              Obx(() => _buildSwitchTile(
                'Push Notifications',
                Icons.notifications_none,
                controller.pushNotifications.value,
                (value) => controller.togglePushNotifications(value),
              )),
              Obx(() => _buildSwitchTile(
                'Email Notifications',
                Icons.email_outlined,
                controller.emailNotifications.value,
                (value) => controller.toggleEmailNotifications(value),
              )),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Appearance'),
              _buildSettingTile(
                'Dark Mode',
                Icons.dark_mode_outlined,
                trailing: Obx(() => Switch(
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleDarkMode,
                  activeColor: AppColors.blue,
                )),
              ),
              _buildSettingTile(
                'Language',
                Icons.language,
                subtitle: 'English',
                onTap: () => controller.onLanguageTap(),
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Support'),
              _buildSettingTile(
                'Help Center',
                Icons.help_outline,
                onTap: () => controller.onHelpCenterTap(),
              ),
              _buildSettingTile(
                'Contact Us',
                Icons.mail_outline,
                onTap: () => controller.onContactUsTap(),
              ),
              _buildSettingTile(
                'Terms of Service',
                Icons.description_outlined,
                onTap: () => controller.onTermsTap(),
              ),
              _buildSettingTile(
                'Privacy Policy',
                Icons.privacy_tip_outlined,
                onTap: () => controller.onPrivacyPolicyTap(),
              ),
              
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => controller.onLogoutTap(),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppText(
        text: title,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    IconData icon, {
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return _buildSettingTile(
      title,
      icon,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.blue,
      ),
    );
  }
} 