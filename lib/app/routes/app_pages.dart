import 'package:get/get.dart';

import '../modules/ home/home_binding.dart';
import '../modules/ home/home_view.dart';
import '../modules/signup/signup_controller.dart';
import '../modules/signup/signup_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.signup;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: BindingsBuilder(() {
        Get.put(SignupController());
      }),
    ),
  ];
}
