import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/const/app_text.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Get.back(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => controller.onEditProfile(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() => CircleAvatar(
                          radius: 50,
                          backgroundImage: controller.profilePhoto.value != null
                              ? FileImage(controller.profilePhoto.value!)
                              : null,
                          child: controller.profilePhoto.value == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        )),
                    const SizedBox(height: 16),
                    Obx(() => AppText(
                          text: controller.userName.value,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 8),
                    Obx(() => AppText(
                          text: controller.userLocation.value,
                          fontSize: 16,
                          color: Colors.grey[600]!,
                        )),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat('Pets', '${controller.petCount}'),
                        _buildStat('Following', '${controller.followingCount}'),
                        _buildStat('Followers', '${controller.followerCount}'),
                      ],
                    ),
                  ],
                ),
              ),

              // Pet List
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'My Pets',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        TextButton(
                          onPressed: () => controller.onAddPet(),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: AppColors.blue, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                'Add Pet',
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.pets.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 32),
                              Icon(
                                Icons.pets,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              AppText(
                                text: 'No pets added yet',
                                fontSize: 16,
                                color: Colors.grey[600]!,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.pets.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final pet = controller.pets[index];
                          return _buildPetCard(pet);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        AppText(
          text: value,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        const SizedBox(height: 4),
        AppText(
          text: label,
          fontSize: 14,
          color: Colors.grey[600]!,
        ),
      ],
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.onPetTap(pet),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(pet['photo'])),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet['breed']} • ${pet['age']} years',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 