import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/map_controller.dart';
import '../../../core/theme/app_colors.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.currentLocation.value,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController mapController) {
              controller.mapController = mapController;
            },
            markers: controller.markers,
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
                Container(
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
            bottom: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  icon: Icons.add,
                  backgroundColor: Colors.white,
                  onTap: () => controller.onAddPetTap(),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.person_outline,
                  backgroundColor: Colors.white,
                  onTap: () => controller.onProfileTap(),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.pets,
                  backgroundColor: Colors.white,
                  onTap: () => controller.onPetsTap(),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  backgroundColor: Colors.white,
                  onTap: () => controller.onChatTap(),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.my_location,
                  backgroundColor: AppColors.blue,
                  iconColor: Colors.white,
                  onTap: () => controller.centerOnCurrentLocation(),
                ),
              ],
            ),
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
} 