abstract class AppRoutes {
  static const initial = '/';
  static const signup = '/signup';
  static const step1 = '/step1';
  static const step2 = '/step2';
  static const petOwnership = '/pet-ownership';
  static const petSelection = '/pet-selection';
  static const petProfile = '/pet-profile';
  static const appearance = '/appearance';
  // Add more routes as needed

  // Define the signup flow sequence for easy navigation
  static const List<String> signupFlow = [
    signup,
    petOwnership,
    petSelection,
    petProfile,
    appearance,
  ];

  // Helper method to get next route in signup flow
  static String? getNextSignupRoute(String currentRoute) {
    print('DEBUG: Getting next route for: $currentRoute');
    final currentIndex = signupFlow.indexOf(currentRoute);
    print('DEBUG: Current index in flow: $currentIndex');
    if (currentIndex != -1 && currentIndex < signupFlow.length - 1) {
      final nextRoute = signupFlow[currentIndex + 1];
      print('DEBUG: Next route will be: $nextRoute');
      return nextRoute;
    }
    print('DEBUG: No next route found');
    return null;
  }

  // Helper method to get previous route in signup flow
  static String? getPreviousSignupRoute(String currentRoute) {
    print('DEBUG: Getting previous route for: $currentRoute');
    final currentIndex = signupFlow.indexOf(currentRoute);
    print('DEBUG: Current index in flow: $currentIndex');
    if (currentIndex > 0) {
      final prevRoute = signupFlow[currentIndex - 1];
      print('DEBUG: Previous route will be: $prevRoute');
      return prevRoute;
    }
    print('DEBUG: No previous route found');
    return null;
  }
}
