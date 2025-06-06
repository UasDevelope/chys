import 'package:chys/app/core/const/app_colors.dart';
import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/modules/map/controllers/map_controller.dart';
import 'package:chys/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/widget/app_button.dart';

class ProfileView extends StatelessWidget {
  final mapController = Get.find<MapController>();
  final profileController = Get.find<ProfileController>();
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSize.h2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSize.h6,
              ),
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back)),
              const AppText(
                text: "Profile",
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              const ListTile(
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage("https://i.pravatar.cc/150?img=6"),
                ),
                title: AppText(
                  text: "John Smith",
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                subtitle: AppText(text: "Hamburg, Germany"),
              ),
              const AppText(
                text: "Bio",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text: "I care about pets because ...",
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              Appbutton(
                width: Get.width,
                borderColor: AppColors.blue,
                backgroundColor: AppColors.blue,
                borderWidth: 0,
                label: "Edit Profile",
                textColor: AppColors.secondary,
                onPressed: profileController.onEditProfile,
              ),
              Obx(() => SizedBox(
                    height: AppSize.getHeight(60),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: mapController.currentLocation.value,
                        zoom: 13,
                      ),
                      onMapCreated: mapController.onMapCreated,
                      markers: mapController.markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
