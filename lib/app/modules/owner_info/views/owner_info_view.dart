import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widget/app_button.dart';
import '../../signup/controller/signup_controller.dart';
import '../../signup/widgets/primary_button.dart';

class OwnerInfoView extends GetView<SignupController> {
  const OwnerInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => controller.goBack(),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      const SizedBox(height: 24),

                      // Title
                      AppText(
                        text: 'Owner\'s Info',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      SizedBox(height: 32),

                      // Owner's Contact Number
                      AppText(
                        text: 'Owner\'s Contact Number',

                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        hint: "Owner\'s Contact Number",
                        controller: controller.ownerContactController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),

                      // Address Details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Address Details',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          Row(
                            children: [
                              AppText(
                                text: 'Private',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(width: 8),
                              Obx(
                                () => Switch(
                                  value: controller.isAddressPrivate.value,
                                  onChanged:
                                      (value) =>
                                          controller.isAddressPrivate.value =
                                              value,
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Street/Door/Apt Number
                      AppText(
                        text: 'Street/ Door/ Apt Number',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hint: "Street/ Door/ Apt Number",
                        controller: controller.streetController,
                      ),
                      const SizedBox(height: 16),

                      // Zip Code and City
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'Zip Code',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  hint: "Zip Code",
                                  controller: controller.zipCodeController,
                                  keyboardType: TextInputType.number,

                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text:
                                  'City',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  controller:TextEditingController(),
                                  selectedValue:
                                    controller
                                        .selectedCity
                                        .value
                                        .isEmpty
                                    ? null
                                        : controller.selectedCity.value,
                                  isDropdown:true,
                                  items:controller.cities,
                                  onDropdownChanged:(value){
                                    if (value != null)
                                      controller.selectedCity.value =
                                          value;
                                  } ,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // State and Country
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'State',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  isDropdown: true,
                                  controller: TextEditingController(),
                                  selectedValue: controller
                                      .selectedState
                                      .value
                                      .isEmpty
                                      ? null
                                      : controller
                                      .selectedState
                                      .value,
                                  items: controller.states,
                                  onDropdownChanged: (value) {
                                    if (value != null)
                                      controller.selectedState.value =
                                          value;                                  },
                                ),


                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const SizedBox(height: 8),

                                AppText(
                                  text: 'Country',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  isDropdown: true,
                                  controller: TextEditingController(),
                                  selectedValue: controller
                                      .selectedCountry
                                      .value
                                      .isEmpty
                                      ? null
                                      : controller
                                      .selectedCountry
                                      .value,
                                  items: controller.countries,
                                  onDropdownChanged: (value) {
                                    if (value != null)
                                      controller.selectedCountry.value =
                                          value;                             },
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: Appbutton(
                              onPressed: () => controller.goBack(),

                              label: 'Back',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Appbutton(
                              backgroundColor:AppColors.blue,
                              borderWidth:0,

                              label: 'Next',
                              onPressed:
                                  () => controller.saveOwnerInfoAndNavigate(),                              ),
                          ),
                        ],
                      ),
                      // Navigation Buttons

                    ],
                  ),
                ),
              ),
            ),
            // Map Section

          ],
        ),
      ),
    );
  }
}
