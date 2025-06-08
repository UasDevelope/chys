import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/core/widget/app_button.dart';
import 'package:chys/app/modules/post/widget/dashed_container.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../core/theme/app_colors.dart';
import '../../../services/api_service.dart';
import '../../posts/controller/post_controller.dart';
import '../controllers/post_controller.dart';

class AddPostView extends GetView<PostController> {
  const AddPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSize.h2),

            // Back Button
            InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back),
            ),

            // Title
            const AppText(
              text: 'Add New Post',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),

            SizedBox(height: AppSize.h2),

            // Media Section
            const Text(
              'Media',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: AppSize.h2),

            // Selected Media Preview
            Obx(() => controller.selectedPhotos.isNotEmpty
                ? Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.selectedPhotos.length,
                      itemBuilder: (context, index) {
                        final media = controller.selectedPhotos[index];
                        return Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(media.path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => controller.removePhoto(index),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : SizedBox()),

            SizedBox(height: AppSize.h2),

            // Upload Button
            GestureDetector(
              onTap: () => controller.pickPhotos(),
              child: DashedContainer(
                dashColor: AppColors.blue,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.h5,
                    horizontal: AppSize.getHeight(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: AppColors.blue,
                      ),
                      SizedBox(height: AppSize.h2),
                      const AppText(
                        text: "Upload Photos",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSize.h3),

            // Description
            const AppText(
              text: 'Description',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),

            SizedBox(height: AppSize.h2),

            CustomTextField(
              controller: controller.descriptionController,
              maxLines: 3,
              label: "Enter your description",
            ),

            const Spacer(),

            // Post Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: Appbutton(
                    borderRadius: 16,
                    textColor: AppColors.onPrimary,
                    backgroundColor: AppColors.blue,
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.createPost();
                          },
                    label: controller.isLoading.value ? 'Posting...' : 'Post',
                    borderColor: Colors.transparent,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
