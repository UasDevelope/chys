import 'dart:developer';

import 'package:chys/app/core/const/app_colors.dart';
import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/core/widget/app_button.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            spacing: AppSize.h1,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSize.h6,
              ),
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(
                height: AppSize.h1,
              ),
              const AppText(
                text: "Profile",
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: AppSize.h1,
              ),
              const AppText(
                text: "Enter your details to create profile.",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: AppSize.h1,
              ),
              const AppText(
                text: "Personal Info",
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: AppSize.h1,
              ),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage("https://i.pravatar.cc/150?img=6"),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.blue,
                        child: Center(
                          child: AppImages.edit.toSvg(
                              color: AppColors
                                  .secondary), // Make sure this SVG fits well
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const AppText(
                text: 'Full Name',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              CustomTextField(
                hint: "Enter full name",
                controller: TextEditingController(),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: AppSize.h1,
              ),
              const AppText(
                text: 'Bio',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              CustomTextField(
                hint: "Enter full name",
                controller: TextEditingController(
                    text: "I care about pets because ..."),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: AppSize.h1,
              ),
              const AppText(
                text: 'Address detail',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const AppText(
                text: 'Street/ Door/ Apt Number',
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              CustomTextField(
                hint: "Enter street",
                controller: TextEditingController(),
                keyboardType: TextInputType.text,
              ),
              Row(
                spacing: AppSize.h2,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSize.h1,
                    children: [
                      const AppText(
                        text: 'Zip Code',
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextField(
                        hint: "Enter zip code",
                        controller: TextEditingController(),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        text: 'City',
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextField(
                        hint: "Select city",
                        controller: TextEditingController(),
                        isDropdown: true,
                        items: const ["City 1", "city 2"],
                        onDropdownChanged: (value) {
                          log("Value is ${value}");
                        },
                      ),
                    ],
                  ))
                ],
              ),
              Row(
                spacing: AppSize.h2,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSize.h1,
                    children: [
                      const AppText(
                        text: 'State',
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextField(
                        hint: "Select State",
                        controller: TextEditingController(),
                        isDropdown: true,
                        items: const ["state 1", "state 2"],
                        readOnly: true,
                        onDropdownChanged: (value) {
                          log("Value is ${value}");
                        },
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        text: 'Country',
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomTextField(
                        hint: "Select country",
                        controller: TextEditingController(),
                        isDropdown: true,
                        items: const ["Country 1", "Country 2"],
                        onDropdownChanged: (value) {
                          log("Value is ${value}");
                        },
                        readOnly: true,
                      ),
                    ],
                  ))
                ],
              ),
              SizedBox(
                height: AppSize.h4,
              ),
              Appbutton(
                width: Get.width,
                borderColor: AppColors.blue,
                backgroundColor: AppColors.blue,
                borderWidth: 0,
                label: "Save Profile",
                textColor: AppColors.secondary,
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
