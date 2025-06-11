import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/routes/app_routes.dart';
import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchNearbyPet();
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.currentLocation.value,
                  zoom: 13,
                ),
                onMapCreated: controller.onMapCreated,
                markers: controller.markers.toSet(),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
              )),
          // Top Bar with Logo and Settings
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App Logo
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.profile);
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),

                // Settings and Notifications
                Row(
                  children: [
                    _buildCircularButton(
                      icon: Icons.settings,
                      onTap: () => controller.onSettingsTap(),
                    ),
                    const SizedBox(width: 12),
                    _buildCircularButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: () => controller.onNotificationsTap(),
                    ),
                  ],
                ),
              ],
            ),
          ),
// ahmad
          // Bottom Action Buttons
          Positioned(
            bottom: AppSize.getHeight(10),
            right: AppSize.getHeight(14),
            child: Column(
              spacing: AppSize.h2,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSvgActionButton(
                  icon: AppImages.user,
                  selected: controller.selectedFeature.value == 'user',
                  onTap: () => controller.selectFeature('user'),
                ),
                _buildSvgActionButton(
                  icon: AppImages.map,
                  selected: controller.selectedFeature.value == 'map',
                  onTap: () => controller.selectFeature('map'),
                ),
                // Podcast
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Obx(() {
              return Column(
                spacing: AppSize.h2,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Map Button in center (base button)

                  // Add
                  _buildSvgActionButton(
                    icon: AppImages.add,
                    selected: controller.selectedFeature.value == 'add',
                    onTap: () => controller.selectFeature('add'),
                  ),
                  // User
                  _buildSvgActionButton(
                    icon: AppImages.podcast,
                    selected: controller.selectedFeature.value == 'podcast',
                    onTap: () => controller.selectFeature('podcast'),
                  ),
                  // Chat
                  _buildSvgActionButton(
                    icon: AppImages.chat,
                    selected: controller.selectedFeature.value == 'chat',
                    onTap: () => controller.selectFeature('chat'),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "19.14 ▮ 19.14",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
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

  Widget _buildActionButton({
    required IconData icon,
    required Color backgroundColor,
    Color iconColor = AppColors.purple,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
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
        icon: Icon(icon, color: iconColor),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildSvgActionButton({
    required String icon,
    required VoidCallback onTap,
    Color backgroundColor = Colors.white,
    Color iconColor = const Color(0xff4B164C),
    bool selected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: icon.toSvg(
          color: iconColor,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
