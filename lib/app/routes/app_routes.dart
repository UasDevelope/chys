abstract class AppRoutes {
  static const initial = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const map = '/map';
  static const settings = '/settings';
  static const notifications = '/notifications';
  static const addPet = '/add-pet';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const pets = '/pets';
  static const petProfile = '/pet-profile';
  static const chat = '/chat';
  static const chatDetail = '/chat-detail';
  static const newChat = '/new-chat';
  static const privacy = '/privacy';
  static const security = '/security';
  static const language = '/language';
  static const helpCenter = '/help-center';
  static const contactUs = '/contact-us';
  static const terms = '/terms';
  static const privacyPolicy = '/privacy-policy';

  // New routes
  static const addPost = '/add-post';
  static const invitePodcast = '/invite-podcast';
  static const homeDetail = '/home-detail';
  static const subscription = '/subscription';
  static const donate = '/donateView';
  static const donateDetail = '/donateDetail';
  static const donateNow = '/donateNow';
  static const adoredPost = '/adoredPost';

  // Pet onboarding routes
  static const petOwnership = '/pet-ownership';
  static const petSelection = '/pet-selection';
  static const appearance = '/appearance';
  static const identification = '/identification';
  static const behavioral = '/behavioral';
  static const ownerInfo = '/owner-info';
  static const dogBreeds = '/dog-breeds';
  static const cityView = '/city-view';

  // Chat related routes
  static const chatList = '/chat-list';
  static const chatSearch = '/chat-search';
  static const chatSettings = '/chat-settings';

  // Profile related routes
  static const profileEdit = '/profile-edit';
  static const profileSettings = '/profile-settings';
  static const followers = '/followers';
  static const following = '/following';

  // Pet related routes
  static const petEdit = '/pet-edit';
  static const petHealth = '/pet-health';
  static const petVaccinations = '/pet-vaccinations';
  static const petMedicalHistory = '/pet-medical-history';
  static const petGallery = '/pet-gallery';

  // Settings related routes
  static const settingsNotifications = '/settings-notifications';
  static const settingsPrivacy = '/settings-privacy';
  static const settingsSecurity = '/settings-security';
  static const settingsLanguage = '/settings-language';
  static const settingsHelp = '/settings-help';
  static const settingsAbout = '/settings-about';

  // Define the signup flow sequence for easy navigation
  static const List<String> signupFlow = [
    signup,
    petOwnership,
    petSelection,
    petProfile,
    appearance,
    identification,
    ownerInfo,
    dogBreeds,
    cityView,
    map,
    behavioral,
    home,
  ];

  // Helper method to get next route in signup flow
  static String? getNextSignupRoute(String currentRoute) {
    final currentIndex = signupFlow.indexOf(currentRoute);
    if (currentIndex < 0 || currentIndex >= signupFlow.length - 1) {
      return null;
    }

    return signupFlow[currentIndex + 1];
  }

  // Helper method to get previous route in signup flow
  static String? getPreviousSignupRoute(String currentRoute) {
    final currentIndex = signupFlow.indexOf(currentRoute);
    if (currentIndex <= 0) {
      return null;
    }

    return signupFlow[currentIndex - 1];
  }
}
