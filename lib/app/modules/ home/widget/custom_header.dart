import 'package:chys/app/modules/map/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';

Widget buildCustomHeader() {
  final mapController = Get.find<MapController>();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Logo Avatar Button
      InkWell(
        onTap: () => Get.toNamed(AppRoutes.profile),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

      // Action Buttons
      Row(
        children: [
          _buildCircularButton(
            icon: Icons.settings,
            onTap: mapController.onSettingsTap,
          ),
          const SizedBox(width: 12),
          _buildCircularButton(
            icon: Icons.notifications_none_rounded,
            onTap: mapController.onNotificationsTap,
          ),
        ],
      ),
    ],
  );
}

Widget _buildCircularButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Container(
    height: 48,
    width: 48,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: AppColors.purple),
      onPressed: onTap,
    ),
  );
}
