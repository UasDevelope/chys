import 'package:get/get.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/pet_ownership/views/pet_ownership_view.dart';
import '../modules/pet_selection/views/pet_selection_view.dart';
import '../modules/pet_profile/views/pet_profile_view.dart';
import '../modules/pet_appearance/views/appearance_view.dart';
import '../modules/pet_identification/views/identification_view.dart';
import '../modules/pet_behavioral/views/behavioral_view.dart';
import '../modules/owner_info/views/owner_info_view.dart';
import '../modules/dog_breeds/views/dog_breeds_view.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.signup;

  static final routes = [
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.petOwnership,
      page: () => const PetOwnershipView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.petSelection,
      page: () => const PetSelectionView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.petProfile,
      page: () => const PetProfileView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.appearance,
      page: () => const AppearanceView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.identification,
      page: () => const IdentificationView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.ownerInfo,
      page: () => const OwnerInfoView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.dogBreeds,
      page: () => const DogBreedsView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.behavioral,
      page: () => const BehavioralView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeView(),
    //   binding: SignupBinding(),
    //   preventDuplicates: true,
    //   transition: Transition.fadeIn,
    // ),
  ];

  static String getRoute(String name) {
    print('DEBUG: Getting route for: $name');
    final route = routes.firstWhere(
      (route) => route.name == name,
      orElse: () => throw Exception('Route $name not found'),
    );
    print('DEBUG: Found route: ${route.name}');
    return route.name;
  }
}
