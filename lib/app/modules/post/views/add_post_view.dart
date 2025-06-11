import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/post_controller.dart';

class AddPostView extends GetView<PostController> {
  const AddPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow
                  GestureDetector(

                    child: Image.asset(
                      'assets/images/ArrowLeft.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    onTap: (){
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 8),
                  // Title
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Add New Post',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Hellix',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.4, // 140%
                        letterSpacing: 0,
                        color: Color(0xFF22172A),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 24),
                  // Media label
                  const Text(
                    'Media',
                    style: TextStyle(
                      fontFamily: 'Hellix',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.4, // 140%
                      letterSpacing: 0,
                      color: Color(0xFFA8A2A2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Dashed container for media
                  Obx(() {
                    final photos = controller.selectedPhotos;
                    return GestureDetector(
                      onTap: () => controller.pickPhotos(),
                      child: DottedBorder(
                        color: AppColors.blue,
                        strokeWidth: 1.5,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(16),
                        dashPattern: [8, 4],
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.transparent,
                          ),
                          child: photos.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/cloud_upload.png',
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Upload Photo / Video',
                                        style: TextStyle(
                                          fontFamily: 'Hellix',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 1.4, // 140%
                                          letterSpacing: 0,
                                          color: Color(0xFF22172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: photos.length < 5
                                            ? photos.length + 1
                                            : 5,
                                        itemBuilder: (context, index) {
                                          if (index < photos.length) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  width: 90,
                                                  height: 120,
                                                  margin: const EdgeInsets.only(
                                                      right: 12,
                                                      top: 20,
                                                      bottom: 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    image: DecorationImage(
                                                      image: FileImage(File(
                                                          photos[index].path)),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 22,
                                                  right: 16,
                                                  child: GestureDetector(
                                                    onTap: () => controller
                                                        .removePhoto(index),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 3,
                                                          left: 3,
                                                          right: 3,
                                                          bottom: 3),
                                                      child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            // Add more button
                                            return GestureDetector(
                                              onTap: () =>
                                                  controller.pickPhotos(),
                                              child: Container(
                                                width: 90,
                                                height: 100,
                                                margin: const EdgeInsets.only(
                                                    right: 12,
                                                    top: 20,
                                                    bottom: 40),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: AppColors.blue
                                                          .withOpacity(0.5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add,
                                                        color: AppColors.blue,
                                                        size: 28),
                                                    const SizedBox(height: 4),
                                                    Text('Add',
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.blue,
                                                            fontSize: 13)),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  // Description label
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'Hellix',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.4, // 140%
                      letterSpacing: 0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Description field with char count
                  TextField(
                    controller: controller.descriptionController,
                    maxLines: 4,
                    maxLength: 100,
                    style: const TextStyle(
                      fontFamily: 'Hellix',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.4, // 140%
                      letterSpacing: 0,
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write something...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      counterStyle:
                          const TextStyle(fontSize: 13, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // For button spacing
                ],
              ),
            ),
            // Post button fixed at bottom
            Spacer(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 2,
              child: Container(
                width: 310,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.createPost(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          controller.isLoading.value ? 'Posting...' : 'Post',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
