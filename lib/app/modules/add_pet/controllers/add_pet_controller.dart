import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddPetController extends GetxController {
  final _imagePicker = ImagePicker();
  final petPhoto = Rxn<File>();
  final selectedPetType = 'Dog'.obs;
  final selectedGender = 'Male'.obs;

  // Form controllers
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final colorController = TextEditingController();
  final weightController = TextEditingController();
  final bioController = TextEditingController();

  Future<void> pickPetPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        petPhoto.value = File(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
      EasyLoading.showError('Failed to pick image');
    }
  }

  Future<void> submitPet() async {
    if (!_validateForm()) return;

    try {
      EasyLoading.show(status: 'Adding pet...');

      // Create pet data
      final petData = {
        'photo': petPhoto.value?.path,
        'type': selectedPetType.value,
        'name': nameController.text,
        'breed': breedController.text,
        'gender': selectedGender.value,
        'age': ageController.text,
        'color': colorController.text,
        'weight': weightController.text,
        'bio': bioController.text,
      };

      // TODO: Send pet data to backend
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      EasyLoading.showSuccess('Pet added successfully!');
      Get.back(result: petData);
    } catch (e) {
      print('Error submitting pet: $e');
      EasyLoading.showError('Failed to add pet');
    }
  }

  bool _validateForm() {
    if (petPhoto.value == null) {
      EasyLoading.showInfo('Please add a photo of your pet');
      return false;
    }

    if (nameController.text.isEmpty) {
      EasyLoading.showInfo('Please enter pet name');
      return false;
    }

    if (breedController.text.isEmpty) {
      EasyLoading.showInfo('Please enter breed');
      return false;
    }

    if (ageController.text.isEmpty) {
      EasyLoading.showInfo('Please enter age');
      return false;
    }

    if (colorController.text.isEmpty) {
      EasyLoading.showInfo('Please enter color');
      return false;
    }

    if (weightController.text.isEmpty) {
      EasyLoading.showInfo('Please enter weight');
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    colorController.dispose();
    weightController.dispose();
    bioController.dispose();
    super.onClose();
  }
} 