import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/core/widget/app_button.dart';
import 'package:chys/app/modules/post/widget/dashed_container.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
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
          spacing: AppSize.h2,
          children: [
            SizedBox(
              height: AppSize.h2,
            ),
            // Back Button
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back),
            ),

            // Title
            const AppText(
              text: 'Add New Post',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            // Media Section
            const Text(
              'Media',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),

            GestureDetector(
              onTap: () => controller.pickMedia(),
              child: DashedContainer(
                  dashColor: AppColors.blue,
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSize.h5,
                        horizontal: AppSize.getHeight(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: AppSize.h2,
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: AppColors.blue,
                        ),
                        const AppText(
                          text: "Upload Photo / Video",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  )),
            ),

            const AppText(
              text: 'Description',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            CustomTextField(
              controller: controller.descriptionController,
              maxLines: 3,
              label: "Enter your description",
            ),

            // Post Button
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: Appbutton(
                borderRadius: 16,
                textColor: AppColors.onPrimary,
                backgroundColor: AppColors.blue,
                onPressed: () => controller.submitPost(),
                label: 'Post',
                borderColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
