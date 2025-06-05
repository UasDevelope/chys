import 'dart:io';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final profilePhoto = Rxn<File>();
  final userName = 'John Doe'.obs;
  final userLocation = 'New York, USA'.obs;
  final petCount = 2.obs;
  final followingCount = 150.obs;
  final followerCount = 230.obs;
  final pets = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock data
      pets.value = [
        {
          'id': '1',
          'name': 'Max',
          'breed': 'Golden Retriever',
          'age': '3',
          'photo': 'assets/images/pets/dog1.jpg',
          'type': 'dog',
        },
        {
          'id': '2',
          'name': 'Luna',
          'breed': 'Persian Cat',
          'age': '2',
          'photo': 'assets/images/pets/cat1.jpg',
          'type': 'cat',
        },
      ];
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onEditProfile() => Get.toNamed(AppRoutes.editProfile);

  Future<void> onAddPet() async {
    final result = await Get.toNamed(AppRoutes.addPet);
    if (result != null) {
      // Add new pet to list
      pets.add(result as Map<String, dynamic>);
      petCount.value++;
    }
  }

  void onPetTap(Map<String, dynamic> pet) {
    Get.toNamed(
      AppRoutes.petProfile,
      arguments: pet,
    );
  }
} 