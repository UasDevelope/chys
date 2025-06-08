import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/widget/app_button.dart';

class DonateNow extends StatelessWidget {
  const DonateNow({super.key});

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: AppSize.h2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: "Lorem ipsum facilisis porttitor",
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            const AppText(
              text:
                  "Lorem ipsum dolor sit amet consectetur. Ultricies ut augue amet vel hac. Ut orci adipiscing fusce lacus lectus rhoncus.",
              fontSize: 13,
            ),
            const AppText(
              text: "Amount",
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
            CustomTextField(
              keyboardType: TextInputType.number,
              label: "Enter amount",
              controller: TextEditingController(),
            ),
            const AppText(
              text: "Payment Method",
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
            CustomTextField(
              keyboardType: TextInputType.number,
              label: "Enter payment Method",
              controller: TextEditingController(),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Appbutton(
                    borderRadius: 16,
                    textColor: AppColors.secondary,
                    backgroundColor: AppColors.blue,
                    label: "Donate Now",
                    borderColor: Colors.transparent,
                    // onPressed: () => controller.submitPost(),
                  ),
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
