import 'package:get/get.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/pet_ownership/views/pet_ownership_view.dart';
import '../modules/pet_selection/views/pet_selection_view.dart';
import '../modules/pet_profile/views/pet_profile_view.dart';
import '../modules/pet_appearance/views/appearance_view.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.signup;

  static final routes = [
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.petOwnership,
      page: () => const PetOwnershipView(),
      binding: SignupBinding(),
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
