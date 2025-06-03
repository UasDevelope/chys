abstract class AppRoutes {
  static const initial = '/';
  static const signup = '/signup';
  static const step1 = '/step1';
  static const step2 = '/step2';
  static const petOwnership = '/pet-ownership';
  static const petSelection = '/pet-selection';
  static const petProfile = '/pet-profile';
  static const appearance = '/appearance';
  static const identification = '/identification';
  static const ownerInfo = '/owner-info';
  static const dogBreeds = '/dog-breeds';
  static const behavioral = '/behavioral';
  static const home = '/home';
  // Add more routes as needed

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
