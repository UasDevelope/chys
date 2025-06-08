import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/routes/app_routes.dart';
import 'package:chys/app/widget/image/image_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widget/app_button.dart';

class DonateDetail extends StatelessWidget {
  const DonateDetail({super.key});

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
        title: const AppText(
          text: 'Donate',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          spacing: AppSize.h2,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImages.discount.toImage(height: AppSize.getHeight(35)),
            const AppText(
              text: "Lorem ipsum facilisis porttitor",
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.5,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.blue),
              ),
            ),
            Row(
              spacing: AppSize.h2,
              children: [
                const Text(
                  'Collected ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  "\$500",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.primary),
                ),
                const Spacer(),
                const Text(
                  '20 days to go',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const AppText(
              text:
                  "Lorem ipsum dolor sit amet consectetur. Ultricies ut augue amet vel hac. Ut orci adipiscing fusce lacus lectus rhoncus.",
              fontSize: 13,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Appbutton(
                      borderRadius: 16,
                      textColor: AppColors.onPrimary,
                      backgroundColor: AppColors.blue,
                      label: "Donate Now",
                      borderColor: Colors.transparent,
                      onPressed: () {
                        Get.toNamed(AppRoutes.donateNow);
                      }),
                ),
              ],
            ),
            SizedBox(
              height: AppSize.h2,
            )
          ],
        ),
      ),
    );
  }
}
