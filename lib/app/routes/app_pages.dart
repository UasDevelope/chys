import 'package:get/get.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pet_ownership/views/pet_ownership_view.dart';
import '../modules/pet_selection/views/pet_selection_view.dart';
import '../modules/pet_profile/views/pet_profile_view.dart';
import '../modules/pet_appearance/views/appearance_view.dart';
import '../modules/pet_identification/views/identification_view.dart';
import '../modules/pet_behavioral/views/behavioral_view.dart';
import '../modules/owner_info/views/owner_info_view.dart';
import '../modules/dog_breeds/views/dog_breeds_view.dart';
import '../modules/city_view/views/city_view.dart';
import '../modules/map/views/map_view.dart';
import '../modules/map/bindings/map_binding.dart';
import '../modules/add_pet/bindings/add_pet_binding.dart';
import '../modules/add_pet/views/add_pet_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_list_view.dart';
import '../modules/chat/views/chat_detail_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/post/bindings/post_binding.dart';
import '../modules/post/views/add_post_view.dart';
import '../modules/podcast/bindings/podcast_binding.dart';
import '../modules/podcast/views/invite_podcast_view.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
    ),
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
    ),
    GetPage(
      name: AppRoutes.appearance,
      page: () => const AppearanceView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.identification,
      page: () => const IdentificationView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ownerInfo,
      page: () => const OwnerInfoView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dogBreeds,
      page: () => const DogBreedsView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.cityView,
      page: () => const CityView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => const MapView(),
      binding: MapBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.behavioral,
      page: () => const BehavioralView(),
      binding: SignupBinding(),
      preventDuplicates: true,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.addPet,
      page: () => const AddPetView(),
      binding: AddPetBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatListView(),
      binding: ChatBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.chatDetail,
      page: () => const ChatDetailView(),
      binding: ChatBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.addPost,
      page: () => const AddPostView(),
      binding: PostBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.invitePodcast,
      page: () => const InvitePodcastView(),
      binding: PodcastBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settingsNotifications,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settingsPrivacy,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settingsSecurity,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settingsLanguage,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settingsHelp,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settingsAbout,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.cupertino,
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
