import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/widget/image/image_extension.dart';
import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/const/app_text.dart';
import '../../core/utils/app_size.dart';

class HomeDetail extends StatelessWidget {
  const HomeDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Section with green background
          Container(
            color: const Color(0xFF4CAF50), // Green background

            height: AppSize.getHeight(50),
            child: Padding(
              padding: EdgeInsets.all(AppSize.h3),
              child: Column(
                children: [
                  SizedBox(height: AppSize.h2),
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.h4),
                  AppImages.post.toImage(height: AppSize.getHeight(30))
                  // Dog Image
                ],
              ),
            ),
          ),
          // Bottom Section with white background
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSize.w6),
                child: Column(
                  spacing: AppSize.h2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Details Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppText(
                                  text: "Itachi",
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                SizedBox(width: AppSize.w2),
                                AppImages.male.toSvg(color: Colors.black)
                              ],
                            ),
                            SizedBox(height: AppSize.h1),
                            AppText(
                              text: "French Bulldog • 1y 4m",
                              fontSize: 16,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E3A59),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: AppImages.message
                                    .toSvg(width: 28, height: 28))),
                      ],
                    ),

                    // About Itachi Section
                    Container(
                      padding: EdgeInsets.all(AppSize.w4),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: AppSize.h2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SvgPicture.string(
                                  '''<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <rect width="24" height="24" fill="#9E9E9E" rx="2"/>
                                    <circle cx="12" cy="9" r="3" fill="white"/>
                                    <path d="M6 20v-1a6 6 0 0 1 12 0v1" fill="white"/>
                                  </svg>''',
                                ),
                              ),
                              SizedBox(width: AppSize.w3),
                              const AppText(
                                text: "About Itachi",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          // Stats Row
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(AppSize.w3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      AppText(
                                        text: "Weight",
                                        fontSize: 12,
                                        color: Colors.grey[600]!,
                                      ),
                                      SizedBox(height: AppSize.h1),
                                      const AppText(
                                        text: "137 lbs",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      AppText(
                                        text: "(62 kg)",
                                        fontSize: 10,
                                        color: Colors.grey[500]!,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSize.w3),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(AppSize.w3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      AppText(
                                        text: "Size",
                                        fontSize: 12,
                                        color: Colors.grey[600]!,
                                      ),
                                      SizedBox(height: AppSize.h1),
                                      const AppText(
                                        text: "Medium",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSize.w3),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(AppSize.w3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      AppText(
                                        text: "Color",
                                        fontSize: 12,
                                        color: Colors.grey[600]!,
                                      ),
                                      SizedBox(height: AppSize.h1),
                                      const AppText(
                                        text: "Brown",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFD2691E),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Description
                          AppText(
                            text:
                                "My dog is incredibly and unconditionally loyal to me. He loves me as much as I love him or sometimes more.",
                            fontSize: 14,
                            color: Colors.grey[600]!,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),

                    // Personal Traits Section
                    Container(
                      padding: EdgeInsets.all(AppSize.w4),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: AppSize.h2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SvgPicture.string(
                                  '''<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <rect width="24" height="24" fill="#9E9E9E" rx="2"/>
                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" fill="white"/>
                                  </svg>''',
                                ),
                              ),
                              SizedBox(width: AppSize.w3),
                              const AppText(
                                text: "Personal Traits",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          AppText(
                            text:
                                "My dog is incredibly and unconditionally loyal to me. He loves me as much as I love him or sometimes more.",
                            fontSize: 14,
                            color: Colors.grey[600]!,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),

                    // Allergies Section
                    Container(
                      padding: EdgeInsets.all(AppSize.w4),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: AppSize.h2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SvgPicture.string(
                                  '''<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <rect width="24" height="24" fill="#9E9E9E" rx="2"/>
                                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" fill="white"/>
                                  </svg>''',
                                ),
                              ),
                              SizedBox(width: AppSize.w3),
                              const AppText(
                                text: "Allergies",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          AppText(
                            text:
                                "My dog is incredibly and unconditionally loyal to me. He loves me as much as I love him or sometimes more.",
                            fontSize: 14,
                            color: Colors.grey[600]!,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
