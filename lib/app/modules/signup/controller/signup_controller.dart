import 'dart:io';

import 'package:chys/app/routes/app_routes.dart';
import 'package:chys/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/const/app_colors.dart';
import '../../map/bindings/map_binding.dart';

class SignupController extends GetxController {
  final _imagePicker = ImagePicker();
  final _apiService = ApiService();

  // Loading states
  final isLoading = false.obs;
  final isFormValid = false.obs;
  final showPassword = false.obs;

  // Step tracking
  final currentStep = 0.obs;

  // Signup form controllers
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
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

  // Pet Profile
  final petPhoto = Rxn<File>();
  final petName = ''.obs;
  final breed = ''.obs;
  final bio = ''.obs;

  final weightController = TextEditingController();
  final marksController = TextEditingController();

  // Identification & Safety fields
  final microchipController = TextEditingController();
  final tagIdController = TextEditingController();
  final vetNameController = TextEditingController();
  final vetContactController = TextEditingController();

  // Behavioral Care Controllers
  final personalityController = TextEditingController();
  final allergiesController = TextEditingController();
  final specialNeedsController = TextEditingController();
  final feedingController = TextEditingController();
  final routineController = TextEditingController();

  // Owner Info Controllers
  final ownerContactController = TextEditingController();
  final streetController = TextEditingController();
  final zipCodeController = TextEditingController();
  final isAddressPrivate = false.obs;
  final selectedCity = ''.obs;
  final selectedState = ''.obs;
  final selectedCountry = ''.obs;

  // Map Related
  GoogleMapController? mapController;
  final currentLocation = const LatLng(0, 0).obs;
  final markers = <Marker>{}.obs;

  // Dropdown Options
  final cities =
      ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'].obs;
  final states = ['New York', 'California', 'Illinois', 'Texas', 'Arizona'].obs;
  final countries = ['United States', 'Canada', 'Mexico'].obs;

  // Dog Breeds Selection
  final selectedBreeds = <String>[].obs;

  void toggleBreedSelection(String breed) {
    if (selectedBreeds.contains(breed)) {
      selectedBreeds.remove(breed);
    } else {
      selectedBreeds.add(breed);
    }
  }

  Future<void> saveDogBreedsAndNavigate() async {
    try {
      if (selectedBreeds.isEmpty) {
        EasyLoading.showError('Please select at least one breed');
        return;
      }

      isLoading.value = true;
      await EasyLoading.show(
        status: 'Saving...',
        maskType: EasyLoadingMaskType.black,
      );

      // Save breeds data
      print('DEBUG: Selected breeds: $selectedBreeds');

      await Future.delayed(const Duration(milliseconds: 800));
      await EasyLoading.showSuccess('Breeds saved!');

      // Navigate to city view and remove previous routes from stack
      await Get.offAllNamed(AppRoutes.cityView);
    } catch (e) {
      print('DEBUG: Error saving breeds: $e');
      await EasyLoading.showError('Failed to save breeds');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  Future<void> finishSignup() async {
    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Finishing setup...',
        maskType: EasyLoadingMaskType.black,
      );

      await Future.delayed(const Duration(milliseconds: 800));
      await EasyLoading.showSuccess('Welcome!');

      // Navigate to map page with binding and remove previous routes from stack
      await Get.offAllNamed(
        AppRoutes.map,

      );
    } catch (e) {
      print('DEBUG: Error finishing signup: $e');
      await EasyLoading.showError('Failed to complete setup');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _getCurrentLocation();
    isLoading.value = false;
  }

  void _initializeControllers() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void goBack() {
    final currentRoute = Get.currentRoute;
    final previousRoute = AppRoutes.getPreviousSignupRoute(currentRoute);

    if (previousRoute != null) {
      isLoading.value = false;
      EasyLoading.dismiss();
      Get.offAndToNamed(previousRoute);
    } else {
      isLoading.value = false;
      EasyLoading.dismiss();
      Get.back();
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
    microchipController.dispose();
    tagIdController.dispose();
    vetNameController.dispose();
    vetContactController.dispose();
    personalityController.dispose();
    allergiesController.dispose();
    specialNeedsController.dispose();
    feedingController.dispose();
    routineController.dispose();
    ownerContactController.dispose();
    streetController.dispose();
    zipCodeController.dispose();
    mapController?.dispose();
    EasyLoading.dismiss();
    super.onClose();
  }

  // Step 1 variables
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final address = ''.obs;

  // Pet Profile variables
  final isSpayedNeutered = false.obs;

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
  // void goToStep2() {
  //   if (isStep1Valid) {
  //     Get.toNamed(AppRoutes.step2);
  //   }
  // }

  void goToStep3() {
    if (isStep2Valid) {
      Get.toNamed(AppRoutes.petProfile);
    }
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:  ColorScheme.light(
              primary: AppColors.blue,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      dobController.text = '${picked.day.toString().padLeft(2, '0')} / '
          '${picked.month.toString().padLeft(2, '0')} / '
          '${picked.year}';
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
    isLoading.value = false;
  }

  void selectPetType(String type) {
    selectedPetType.value = type;
    EasyLoading.showToast(
      'Selected ${type.capitalizeFirst}',
      duration: const Duration(milliseconds: 1000),
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  Future<void> proceedFromPetOwnership() async {
    if (!hasSelectedPetOwnership.value) {
      EasyLoading.showError('Please select an option');
      return;
    }

    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );

      await Future.delayed(const Duration(milliseconds: 300));
      await EasyLoading.dismiss();
      isLoading.value = false;

      // Navigate directly to pet selection
      await Get.offAndToNamed(AppRoutes.petSelection);
    } catch (e) {
      print('DEBUG: Error in proceedFromPetOwnership: $e');
      await EasyLoading.showError('Something went wrong');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  Future<void> proceedFromPetSelection() async {
    if (selectedPetType.value.isEmpty) {
      EasyLoading.showError('Please select a pet type');
      return;
    }

    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );

      await Future.delayed(const Duration(milliseconds: 300));
      await EasyLoading.dismiss();
      isLoading.value = false;

      // Navigate directly to pet profile
      await Get.offAndToNamed(AppRoutes.petProfile);
    } catch (e) {
      print('DEBUG: Error in proceedFromPetSelection: $e');
      await EasyLoading.showError('Something went wrong');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
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
      isLoading.value = false;
      final nextRoute = AppRoutes.getNextSignupRoute(currentRoute);
      print('DEBUG: Next route is: $nextRoute');

      if (nextRoute != null) {
        print('DEBUG: Navigating to $nextRoute');
        await Get.offNamed(nextRoute);
      } else {
        print('DEBUG: Fallback to appearance route');
        isLoading.value = false;
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
      Get.toNamed(AppRoutes.identification);
    } catch (e) {
      print('DEBUG: Error saving appearance: $e');
      EasyLoading.showError('Failed to save appearance');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void updateLostStatus(String value) => lostStatus.value = value;
  void updateVaccinationStatus(String value) => vaccinationStatus.value = value;

  Future<void> saveIdentification() async {
    try {
      isLoading.value = true;

      // Save identification data
      microchipNumber.value = microchipController.text;
      tagId.value = tagIdController.text;
      vetName.value = vetNameController.text;
      vetContactNumber.value = vetContactController.text;

      await Future.delayed(const Duration(milliseconds: 800));
      await EasyLoading.showSuccess('Information saved successfully!');
      isLoading.value = false;
      // Navigate to behavioral page
      await Get.offNamed(AppRoutes.behavioral);
    } catch (e, stackTrace) {
      print('ERROR: $e');
      print('STACK TRACE: $stackTrace');
      await EasyLoading.showError('Failed to save information');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  Future<void> saveBehavioralAndNavigate() async {
    try {
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Saving...',
        maskType: EasyLoadingMaskType.black,
      );

      // Save behavioral data
      final behavioralData = {
        'personality': personalityController.text,
        'allergies': allergiesController.text,
        'specialNeeds': specialNeedsController.text,
        'feeding': feedingController.text,
        'routine': routineController.text,
      };

      print('DEBUG: Saving behavioral data: $behavioralData');

      await Future.delayed(const Duration(milliseconds: 800));
      await EasyLoading.showSuccess('Information saved!');

      // Complete the signup flow
      isLoading.value = false;
      await Get.offAllNamed(AppRoutes.ownerInfo);
    } catch (e) {
      print('DEBUG: Error saving behavioral data: $e');
      await EasyLoading.showError('Failed to save information');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      currentLocation.value = LatLng(position.latitude, position.longitude);

      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation.value,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );

      mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLocation.value),
      );
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> saveOwnerInfoAndNavigate() async {
    await Get.offNamed(AppRoutes.dogBreeds);

    try {
      if (!_validateOwnerInfo()) {
        return;
      }

      isLoading.value = true;
      await EasyLoading.show(
        status: 'Saving...',
        maskType: EasyLoadingMaskType.black,
      );

      // Save owner info data
      final ownerData = {
        'contact': ownerContactController.text,
        'street': streetController.text,
        'zipCode': zipCodeController.text,
        'city': selectedCity.value,
        'state': selectedState.value,
        'country': selectedCountry.value,
        'isPrivate': isAddressPrivate.value,
        'location': {
          'lat': currentLocation.value.latitude,
          'lng': currentLocation.value.longitude,
        },
      };

      print('DEBUG: Saving owner info: $ownerData');

      await Future.delayed(const Duration(milliseconds: 800));
      await EasyLoading.showSuccess('Information saved!');
      isLoading.value = false;
      // Navigate to next page
      await Get.offNamed(AppRoutes.dogBreeds);
    } catch (e) {
      print('DEBUG: Error saving owner info: $e');
      await EasyLoading.showError('Failed to save information');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  bool _validateOwnerInfo() {
    if (ownerContactController.text.isEmpty) {
      EasyLoading.showError('Please enter contact number');
      return false;
    }
    if (streetController.text.isEmpty) {
      EasyLoading.showError('Please enter street address');
      return false;
    }
    if (zipCodeController.text.isEmpty) {
      EasyLoading.showError('Please enter zip code');
      return false;
    }
    if (selectedCity.value.isEmpty) {
      EasyLoading.showError('Please select city');
      return false;
    }
    if (selectedState.value.isEmpty) {
      EasyLoading.showError('Please select state');
      return false;
    }
    if (selectedCountry.value.isEmpty) {
      EasyLoading.showError('Please select country');
      return false;
    }
    return true;
  }

  Future<void> handleSignup() async {
    try {
      if (!_validateSignupForm()) return;

      isLoading.value = true;
      await EasyLoading.show(
        status: 'Creating account...',
        maskType: EasyLoadingMaskType.black,
      );

      final result = await _apiService.register(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );

      if (result['success']) {
        await EasyLoading.showSuccess('Account created successfully!');
        Get.toNamed(AppRoutes.petOwnership);
      } else {
        String errorMessage = result['message'];
        if (errorMessage.contains('duplicate key error') && errorMessage.contains('username')) {
          // Generate a unique username by adding a timestamp
          final uniqueName = '${nameController.text.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
          
          // Try again with the unique username
          final retryResult = await _apiService.register(
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
            username: uniqueName,
          );

          if (retryResult['success']) {
            await EasyLoading.showSuccess('Account created successfully!');
            Get.toNamed(AppRoutes.petOwnership);
            return;
          }
          errorMessage = retryResult['message'];
        }
        await EasyLoading.showError(errorMessage);
      }
    } catch (e) {
      print('Error during signup: $e');
      await EasyLoading.showError('Failed to create account');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  bool _validateSignupForm() {
    if (nameController.text.isEmpty) {
      EasyLoading.showInfo('Please enter your name');
      return false;
    }

    if (emailController.text.isEmpty) {
      EasyLoading.showInfo('Please enter your email');
      return false;
    }

    if (passwordController.text.isEmpty) {
      EasyLoading.showInfo('Please enter your password');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      EasyLoading.showInfo('Passwords do not match');
      return false;
    }

    if (!agreePolicy1.value || !agreePolicy2.value || !agreePolicy3.value) {
      EasyLoading.showInfo('Please agree to all policies');
      return false;
    }

    return true;
  }
}
