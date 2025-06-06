import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/core/widget/app_button.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/const/app_colors.dart';
import '../../core/const/app_text.dart';

class InvitePodcast extends StatelessWidget {
  const InvitePodcast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
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
              SizedBox(
                height: AppSize.h2,
              ),
              // Title
              CustomTextField(
                label: "Search",
                controller: TextEditingController(),
                suffixIcon: const Icon(Icons.search),
                fillColor: Colors.white.withValues(alpha: 0.5),
              ),
              const AppText(
                text: 'Invite Podcost',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              const AppText(
                text: 'Invite one of your followers to podcast',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: 14,
                shrinkWrap: true,
                itemBuilder: (itemBuilder, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=3'),
                    ),
                    title: const AppText(
                      text: 'John Doe',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    subtitle: const AppText(
                      text: 'Swaziland',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    trailing: Appbutton(
                      height: 50,
                      width: 90,
                      borderRadius: 16,
                      textColor: AppColors.secondary,
                      backgroundColor: AppColors.blue,
                      label: "invite",
                      borderColor: Colors.transparent,
                      // onPressed: () => controller.submitPost(),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: AppSize.h2,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
