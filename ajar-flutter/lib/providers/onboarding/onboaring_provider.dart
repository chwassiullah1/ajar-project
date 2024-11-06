import 'package:ajar/screens/starting_screen/starting_screen.dart';
import 'package:flutter/material.dart';

class OnboardingProvider with ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  List<Map<String, String>> get pages => [
        {
          'title': 'Find Your Ideal Car',
          'description':
              'Browse through our extensive fleet of vehicles. Choose the car that fits your needs and style.',
        },
        {
          'title': 'Easy Booking Process',
          'description':
              'Reserve your car effortlessly with just a few taps. Confirm your booking and get ready for your adventure!',
        },
        {
          'title': 'Hit the Road',
          'description':
              'Enjoy a seamless driving experience. Explore your destination with comfort and confidence.',
        },
      ];

  String getTitle() {
    return pages[currentPage]['title']!;
  }

  String getDescription() {
    return pages[currentPage]['description']!;
  }

  void setCurrentPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void goToNextPage(BuildContext context) {
    if (currentPage < pages.length - 1) {
      currentPage++;
      notifyListeners();
    } else {
      // Navigate to the next screen after onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StartingScreen(),
        ),
      );
    }
  }

  void goToLastPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const StartingScreen(),
      ),
    );
  }
}
