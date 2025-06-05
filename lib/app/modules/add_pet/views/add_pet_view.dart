import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/const/app_text.dart';
import '../controllers/add_pet_controller.dart';
import '../../../core/widget/app_button.dart';

class AddPetView extends GetView<AddPetController> {
  const AddPetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          text: 'Add Pet',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Photo
              Center(
                child: GestureDetector(
                  onTap: () => controller.pickPetPhoto(),
                  child: Obx(() {
                    final photo = controller.petPhoto.value;
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        image: photo != null
                            ? DecorationImage(
                                image: FileImage(photo),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: photo == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 32,
                                  color: AppColors.blue,
                                ),
                                const SizedBox(height: 4),
                                AppText(
                                  text: 'Add Photo',
                                  fontSize: 12,
                                  color: AppColors.blue,
                                ),
                              ],
                            )
                          : null,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),

              // Pet Type Selection
              AppText(
                text: 'Pet Type',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPetTypeOption('Dog', Icons.pets),
                  const SizedBox(width: 16),
                  _buildPetTypeOption('Cat', Icons.pets),
                ],
              ),
              const SizedBox(height: 32),

              // Pet Details Form
              AppText(
                text: 'Pet Details',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.nameController,
                label: 'Pet Name',
                hint: 'Enter pet name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.breedController,
                label: 'Breed',
                hint: 'Enter breed',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Gender',
                      value: controller.selectedGender.value,
                      items: const ['Male', 'Female'],
                      onChanged: (value) =>
                          controller.selectedGender.value = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.ageController,
                      label: 'Age',
                      hint: 'Years',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.colorController,
                label: 'Color',
                hint: 'Enter color',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.weightController,
                label: 'Weight (kg)',
                hint: 'Enter weight',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.bioController,
                label: 'Bio',
                hint: 'Tell us about your pet',
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Submit Button
              Appbutton(
                label: 'Add Pet',
                onPressed: () => controller.submitPet(),
                backgroundColor: AppColors.blue,
                borderColor: AppColors.blue,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetTypeOption(String type, IconData icon) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedPetType.value == type;
        return GestureDetector(
          onTap: () => controller.selectedPetType.value = type,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.blue : Colors.grey[300]!,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
                const SizedBox(height: 8),
                Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          fontSize: 14,
          color: Colors.grey[700]!,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          fontSize: 14,
          color: Colors.grey[700]!,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
} 