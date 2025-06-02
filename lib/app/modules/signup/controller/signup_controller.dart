import 'dart:io';

import 'package:chys/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Loading states
  final isLoading = false.obs;
  final isFormValid = false.obs;

  // Step tracking
  final currentStep = 0.obs;

  // Signup form controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final bioController = TextEditingController();
  final dobController = TextEditingController();
  var selectedColor = 'Red'.obs;
  var selectedSize = 'Medium'.obs;
  var weight = ''.obs;
  var marks = ''.obs;
  var photos = <File>[].obs;
  var microchipNumber = ''.obs;
  var tagId = ''.obs;
  var lostStatus = 'Medium'.obs;
  var vaccinationStatus = 'Yes'.obs;
  var vetName = ''.obs;
  var vetContactNumber = ''.obs;

  final lostStatusOptions = ['Low', 'Medium', 'High'];
  final vaccinationStatusOptions = ['Yes', 'No'];
  final colorOptions = ['Red', 'Black', 'White', 'Brown', 'Golden'];
  final sizeOptions = ['Small', 'Medium', 'Large'];

  var selectedSex = 'Male'.obs;
  var isNeutered = false.obs;
  var selectedDate = Rxn<DateTime>();

  // Policy agreements
  final agreePolicy1 = false.obs;
  final agreePolicy2 = false.obs;
  final agreePolicy3 = false.obs;

  // Pet ownership step
  final hasPet = false.obs;
  final hasSelectedPetOwnership = false.obs;

  // Pet selection step
  final selectedPetType = ''.obs;

  final showPassword = false.obs;

  // Pet Profile
  final petPhoto = Rxn<File>();
  final petName = ''.obs;
  final breed = ''.obs;
  final bio = ''.obs;

  final weightController = TextEditingController();
  final marksController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _setupValidation();
  }

  void _setupValidation() {
    usernameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
    agreePolicy1.listen((_) => _validateForm());
    agreePolicy2.listen((_) => _validateForm());
    agreePolicy3.listen((_) => _validateForm());
  }

  void _validateForm() {
    isFormValid.value =
        formKey.currentState?.validate() ??
        false && agreePolicy1.value && agreePolicy2.value && agreePolicy3.value;
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  Future<void> pickPhotos() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();

      if (images.isNotEmpty) {
        // Limit to 5 photos
        final remainingSlots = 5 - photos.length;
        if (remainingSlots > 0) {
          final newPhotos =
              images.take(remainingSlots).map((e) => File(e.path)).toList();
          photos.addAll(newPhotos);

          if (images.length > remainingSlots) {
            EasyLoading.showInfo('Maximum 5 photos allowed');
          }
        } else {
          EasyLoading.showInfo('Maximum 5 photos already selected');
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick images');
    }
  }

  void updateColor(String value) => selectedColor.value = value;
  void updateSize(String value) => selectedSize.value = value;
  void updateWeight(String value) => weight.value = value;
  void updateMarks(String value) => marks.value = value;

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      dobController.text = DateFormat('dd / MM / yyyy').format(picked);
    }
  }

  void selectPetOwnership(bool value) {
    print('DEBUG: selectPetOwnership called with value: $value');
    hasPet.value = value;
    hasSelectedPetOwnership.value = true;
    print('DEBUG: Updated hasPet = ${hasPet.value}');
    print(
      'DEBUG: Updated hasSelectedPetOwnership = ${hasSelectedPetOwnership.value}',
    );

    EasyLoading.showToast(
      value ? 'You have a pet' : 'You don\'t have a pet',
      duration: const Duration(milliseconds: 1000),
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  void selectPetType(String type) {
    selectedPetType.value = type;
    EasyLoading.showToast(
      'Selected ${type.capitalizeFirst}',
      duration: const Duration(milliseconds: 1000),
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  Future<void> submitSignup() async {
    if (!isFormValid.value) {
      EasyLoading.showError('Please fill all required fields');
      return;
    }

    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Creating account...',
        maskType: EasyLoadingMaskType.black,
      );

      await Future.delayed(const Duration(seconds: 1));
      await EasyLoading.showSuccess('Account created!');

      final nextRoute = AppRoutes.getNextSignupRoute(AppRoutes.signup);
      if (nextRoute != null) {
        Get.toNamed(nextRoute);
      }
    } catch (e) {
      EasyLoading.showError('Failed to create account');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> proceedFromPetOwnership() async {
    print('DEBUG: Starting proceedFromPetOwnership');
    print('DEBUG: hasSelectedPetOwnership = ${hasSelectedPetOwnership.value}');

    if (!hasSelectedPetOwnership.value) {
      print('DEBUG: No pet ownership selected, returning');
      return;
    }

    try {
      print('DEBUG: Setting loading state to true');
      isLoading.value = true;

      print('DEBUG: Showing loading indicator');
      EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );

      // Force a small delay to ensure loading is shown
      await Future.delayed(const Duration(milliseconds: 100));

      print('DEBUG: Before navigation attempt');
      Get.toNamed(AppRoutes.petSelection);
      print('DEBUG: After navigation attempt');

      // Delay success message until after navigation
      await Future.delayed(const Duration(milliseconds: 300));
      EasyLoading.showSuccess('Great choice!');
    } catch (e) {
      print('DEBUG: Error occurred: $e');
      EasyLoading.showError('Something went wrong');
    } finally {
      print('DEBUG: Cleaning up - setting loading to false');
      isLoading.value = false;
      print('DEBUG: Dismissing loading indicator');
      await Future.delayed(const Duration(milliseconds: 100));
      EasyLoading.dismiss();
    }
  }

  Future<void> proceedFromPetSelection() async {
    print('DEBUG: Starting proceedFromPetSelection');
    print('DEBUG: Selected pet type: ${selectedPetType.value}');

    try {
      print('DEBUG: Setting loading state');
      isLoading.value = true;

      print('DEBUG: Showing loading indicator');
      EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );

      // Add a small delay to show loading
      await Future.delayed(const Duration(milliseconds: 500));

      print('DEBUG: Dismissing loading');
      EasyLoading.dismiss();

      print('DEBUG: Attempting navigation to pet profile');
      Get.toNamed(AppRoutes.petProfile);
      print('DEBUG: Navigation command sent');
    } catch (e) {
      print('DEBUG: Error in proceedFromPetSelection: $e');
      print('DEBUG: Error stack trace: ${e is Error ? e.stackTrace : ''}');
      EasyLoading.showError('Something went wrong');
    } finally {
      print('DEBUG: Cleaning up');
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    breedController.dispose();
    bioController.dispose();
    dobController.dispose();
    weightController.dispose();
    marksController.dispose();
    EasyLoading.dismiss();
    super.onClose();
  }

  // Step 1 variables
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;

  // Step 2 variables
  final language = 'en'.obs;
  final theme = 'system'.obs;
  final pushNotifications = true.obs;
  final emailNotifications = true.obs;

  // Step 1 methods
  void updateName(String value) => name.value = value;
  void updateEmail(String value) => email.value = value;
  void updatePhone(String value) => phone.value = value;
  void updateAddress(String value) => address.value = value;

  // Step 2 methods
  void updateLanguage(String? value) => language.value = value ?? 'en';
  void updateTheme(String? value) => theme.value = value ?? 'system';
  void togglePushNotifications(bool? value) =>
      pushNotifications.value = value ?? true;
  void toggleEmailNotifications(bool? value) =>
      emailNotifications.value = value ?? true;

  // Validation methods
  bool get isStep1Valid {
    return name.value.isNotEmpty &&
        email.value.isNotEmpty &&
        phone.value.isNotEmpty &&
        address.value.isNotEmpty;
  }

  bool get isStep2Valid {
    return language.value.isNotEmpty && theme.value.isNotEmpty;
  }

  // Navigation methods
  void goToStep2() {
    if (isStep1Valid) {
      Get.toNamed(AppRoutes.step2);
    }
  }

  void goToStep3() {
    if (isStep2Valid) {
      Get.toNamed(AppRoutes.petProfile);
    }
  }

  void goBack() {
    final currentRoute = Get.currentRoute;
    final previousRoute = AppRoutes.getPreviousSignupRoute(currentRoute);

    if (previousRoute != null) {
      Get.toNamed(previousRoute);
    } else {
      Get.back();
    }
  }

  Future<void> pickPetPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        print('DEBUG: Image picked: ${image.path}');
        petPhoto.value = File(image.path);
        EasyLoading.showSuccess('Photo updated!');
      }
    } catch (e) {
      print('DEBUG: Error picking image: $e');
      EasyLoading.showError('Failed to pick image');
    }
  }
  Future<void> savePetProfile() async {
    print('DEBUG: Starting savePetProfile');

    if (nameController.text.isEmpty) {
      print('DEBUG: Name is empty');
      EasyLoading.showError('Please enter pet name');
      return;
    }

    try {
      print('DEBUG: Setting loading state to true');
      isLoading.value = true;

      print('DEBUG: Showing loading dialog');


      // Simulate saving logic
      print('DEBUG: Saving pet profile data');
      petName.value = nameController.text;
      breed.value = breedController.text;
      bio.value = bioController.text;

      await Future.delayed(const Duration(milliseconds: 800));

      print('DEBUG: Showing success message');
      await EasyLoading.showSuccess('Profile saved successfully!');
      await EasyLoading.dismiss();

      // Determine next screen
      final currentRoute = Get.currentRoute;
      print('DEBUG: Current route is: $currentRoute');

      final nextRoute = AppRoutes.getNextSignupRoute(currentRoute);
      print('DEBUG: Next route is: $nextRoute');

      if (nextRoute != null) {
        print('DEBUG: Navigating to $nextRoute');
        await Get.offNamed(nextRoute);
      } else {
        print('DEBUG: Fallback to appearance route');
        await Get.offNamed(AppRoutes.appearance);
      }
    } catch (e, stackTrace) {
      print('ERROR: $e');
      print('STACK TRACE: $stackTrace');
      await EasyLoading.showError('Failed to save profile');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
      print('DEBUG: Cleanup complete');
    }
  }


  void removePhoto(int index) {
    if (index >= 0 && index < photos.length) {
      photos.removeAt(index);
    }
  }

  Future<void> saveAppearance() async {
    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Saving appearance...',
        maskType: EasyLoadingMaskType.black,
      );

      // Validate required fields
      if (photos.isEmpty) {
        EasyLoading.showError('Please add at least one photo');
        return;
      }

      if (weightController.text.isEmpty) {
        EasyLoading.showError('Please enter pet weight');
        return;
      }

      // Save the appearance data
      weight.value = weightController.text;
      marks.value = marksController.text;

      await Future.delayed(const Duration(milliseconds: 800));
      await EasyLoading.showSuccess('Appearance saved!');

      // Navigate to the next screen in the signup flow
      Get.toNamed(AppRoutes.petProfile);
    } catch (e) {
      print('DEBUG: Error saving appearance: $e');
      EasyLoading.showError('Failed to save appearance');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
