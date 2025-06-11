import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/const/app_text.dart';
import '../../../services/storage_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: AppText(
          text: 'Settings',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildSection([
            _settingTile('Account Status', AppImages.account),
            _settingTile('Adored Posts', AppImages.catPaw, onTap: () {
              Get.toNamed(AppRoutes.adoredPost);
            }),
          ]),
          const SizedBox(height: 12),
          _buildSection([
            _settingTile('Subscriptions', AppImages.subscription, onTap: () {
              Get.toNamed(AppRoutes.subscription);
            }),
            _settingTile('Donate', AppImages.donate, onTap: () {
              Get.toNamed(AppRoutes.donate);
            }),
          ]),
          const SizedBox(height: 12),
          _buildSection([
            _settingTile('Notifications', AppImages.notification),
            _settingTile('Help Center', AppImages.help),
            _settingTile('Privacy', AppImages.privacy),
            _settingTile('About Us', AppImages.about),
          ]),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
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
                await StorageService.clearStorage();
                Get.offAllNamed(AppRoutes.login);
              }
            },
            child: _logoutButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(List<Widget> tiles) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Color(0xffF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffF3F4F6))),
      child: Column(
        children: List.generate(
          tiles.length * 2 - 1,
          (index) => index.isEven
              ? tiles[index ~/ 2]
              : Divider(color: Colors.grey.shade300, height: 1),
        ),
      ),
    );
  }

  Widget _settingTile(String label, String iconPath, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: const Color(0x0927650D),      // your custom splash color
      highlightColor: const Color(0x0927650D),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          leading: SvgPicture.asset(iconPath, height: 24),
          title: AppText(
            text: label,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          trailing:
              const Icon(Icons.chevron_right, color: Colors.black, size: 20),
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFC7D1)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppImages.logout,
              height: 20, color: const Color(0xFFFF3B6C)),
          const SizedBox(width: 12),
          AppText(
            text: 'Log Out',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFF3B6C),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Color(0xFFFF3B6C), size: 20),
        ],
      ),
    );
  }
}
