import 'dart:io';

import 'package:chys/app/routes/app_routes.dart';
import 'package:chys/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/const/app_colors.dart';

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
            colorScheme: ColorScheme.light(
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

  Future<void> selectPetOwnership(bool value) async {
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
      if (hasPet == true) {
        await Get.offAndToNamed(AppRoutes.petSelection);
      } else {
        await Get.offAndToNamed(AppRoutes.cityView);
      }
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

  Future<void> savePetProfile1() async {
    if (nameController.text.isEmpty) {
      print('DEBUG: Name is empty');
      EasyLoading.showError('Please enter pet name');
      return;
    }

    try {
      isLoading.value = true;

      petName.value = nameController.text;
      breed.value = breedController.text;
      bio.value = bioController.text;

      await Future.delayed(const Duration(milliseconds: 800));

      await EasyLoading.showSuccess('Profile saved successfully!');
      await EasyLoading.dismiss();

      // Determine next screen
      final currentRoute = Get.currentRoute;

      isLoading.value = false;
      final nextRoute = AppRoutes.getNextSignupRoute(currentRoute);

      if (nextRoute != null) {
        await Get.offNamed(nextRoute);
      } else {
        isLoading.value = false;
        await Get.offNamed(AppRoutes.appearance);
      }
    } catch (e, stackTrace) {
      await EasyLoading.showError('Failed to save profile');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  Future<void> savePetProfile() async {
    print('DEBUG: Starting savePetProfile');

    if (!_validatePetProfile()) return;

    try {
      print('DEBUG: Setting loading state to true');
      isLoading.value = true;
      await EasyLoading.show(
        status: 'Creating pet profile...',
        maskType: EasyLoadingMaskType.black,
      );

      // Prepare the pet profile data according to the API specification
      print(weightController.text);
      print(selectedPetType.value);
      print(dobController.text);
      final petData = {
        'isHavePet': hasPet.value,
        'petType':
            selectedPetType.value.isNotEmpty ? selectedPetType.value : null,
        'profilePic': petPhoto.value?.path ?? '',
        'name': nameController.text.trim().isNotEmpty
            ? nameController.text.trim()
            : null,
        'breed': breedController.text.trim().isNotEmpty
            ? breedController.text.trim()
            : null,
        'sex': selectedSex.value.isNotEmpty
            ? selectedSex.value.toLowerCase()
            : null,
        'dateOfBirth': dobController.text.trim().isNotEmpty
            ? dobController.text.trim()
            : null,
        'bio': bioController.text,
        'photos': photos.map((file) => file.path).toList(),
        'color': selectedColor.value.isNotEmpty ? selectedColor.value : null,
        'size': selectedSize.value.isNotEmpty
            ? selectedSize.value.toLowerCase()
            : null,
        'weight': double.tryParse(weightController.text.trim()) != null
            ? double.parse(weightController.text.trim())
            : null,
        'marks': marksController.text,
        'microchipNumber': microchipController.text,
        'tagId': tagIdController.text,
        'lostStatus': false,
        'vaccinationStatus': vaccinationStatus.value == 'Yes',
        'vetName': vetNameController.text,
        'vetContactNumber': vetContactController.text,
        'personalityTraits': personalityController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'allergies': allergiesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'specialNeeds': specialNeedsController.text,
        'feedingInstructions': feedingController.text,
        'dailyRoutine': routineController.text,
      };

      final result = await _apiService.createPetProfile(petData);
      print('results heere: ${result} ');
      if (result['success']) {
        await EasyLoading.showSuccess('Pet profile created successfully!');

        // Get next route in signup flow
        final currentRoute = Get.currentRoute;
        final nextRoute = AppRoutes.getNextSignupRoute(currentRoute);

        await Get.offNamed(AppRoutes.cityView);
      } else {
        await EasyLoading.showError(
            result['message'] ?? 'Failed to create pet profile');
      }
    } catch (e, stackTrace) {
      print('ERROR: $e');
      print('STACK TRACE: $stackTrace');
      await EasyLoading.showError('Failed to create pet profile');
    } finally {
      isLoading.value = false;
      await EasyLoading.dismiss();
    }
  }

  bool _validatePetProfile() {
    if (nameController.text.isEmpty) {
      EasyLoading.showError('Please enter pet name');
      return false;
    }

    if (breedController.text.isEmpty) {
      EasyLoading.showError('Please enter pet breed');
      return false;
    }

    if (dobController.text.isEmpty) {
      EasyLoading.showError('Please select date of birth');
      return false;
    }

    if (selectedColor.value.isEmpty) {
      EasyLoading.showError('Please select pet color');
      return false;
    }

    if (selectedSize.value.isEmpty) {
      EasyLoading.showError('Please select pet size');
      return false;
    }

    if (weightController.text.isEmpty) {
      EasyLoading.showError('Please enter pet weight');
      return false;
    }

    if (vetNameController.text.isEmpty) {
      EasyLoading.showError('Please enter vet name');
      return false;
    }

    if (vetContactController.text.isEmpty) {
      EasyLoading.showError('Please enter vet contact number');
      return false;
    }

    return true;
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
        if (errorMessage.contains('duplicate key error') &&
            errorMessage.contains('username')) {
          // Generate a unique username by adding a timestamp
          final uniqueName =
              '${nameController.text.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';

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
