import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/app_image.dart';
import '../../../core/utils/app_size.dart';
import '../../map/controllers/map_controller.dart';

// Reusable button
class SvgActionButton extends StatelessWidget {
  final String icon;
  final bool selected;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const SvgActionButton({
    Key? key,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xff4B164C),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : backgroundColor,
          shape: BoxShape.circle,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: icon.toSvg(
          color: selected ? Colors.white : iconColor,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}

// First button group widget
class UserMapButtons extends StatelessWidget {
  final MapController controller;
  final double bottom;
  final double right;

  const UserMapButtons({
    Key? key,
    required this.controller,
    this.bottom = 10,
    this.right = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgActionButton(
            icon: AppImages.user,
            selected: controller.selectedFeature.value == 'user',
            onTap: () => controller.selectFeature('user'),
          ),
          SizedBox(height: AppSize.h2),
          SvgActionButton(
            icon: AppImages.map,
            selected: controller.selectedFeature.value == 'map',
            onTap: () => controller.selectFeature('map'),
          ),
          // You can add Podcast button here if needed
        ],
      ),
    );
  }
}

// Second button group widget
class CustomFloatingActionButton extends StatelessWidget {
  final MapController controller;
  final double bottom;
  final double right;

  const CustomFloatingActionButton({
    Key? key,
    required this.controller,
    this.bottom = 24,
    this.right = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgActionButton(
              icon: AppImages.add,
              selected: controller.selectedFeature.value == 'add',
              onTap: () => controller.selectFeature('add'),
            ),
            const SizedBox(height: 16),
            SvgActionButton(
              icon: AppImages.podcast,
              selected: controller.selectedFeature.value == 'podcast',
              onTap: () => controller.selectFeature('podcast'),
            ),
            const SizedBox(height: 16),
            SvgActionButton(
              icon: AppImages.chat,
              selected: controller.selectedFeature.value == 'chat',
              onTap: () => controller.selectFeature('chat'),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
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
    );
  }
}
