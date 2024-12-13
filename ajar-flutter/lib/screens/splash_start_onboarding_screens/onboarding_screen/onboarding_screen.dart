import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding/onboaring_provider.dart';
import 'package:ajar/utils/theme_constants.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height and width using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Consumer<OnboardingProvider>(
        builder: (context, onboardingProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Skip Button (aligned to top right)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03, right: screenWidth * 0.05),
                  child: TextButton(
                    onPressed: () {
                      onboardingProvider.goToLastPage(context);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
                
              // Main content (title, description, dots indicator, image)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            onboardingProvider.getTitle(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: fMainColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            onboardingProvider.getDescription(),
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                
                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          onboardingProvider.pages.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  onboardingProvider.currentPage == index
                                      ? fMainColor
                                      : Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      CustomGradientButton(
                        text: "Next",
                        width: 120,
                        onPressed: () {
                          onboardingProvider.goToNextPage(context);
                        },
                        icon: Icons.arrow_forward,
                      )
                    ],
                  ),
                ),
              ),
                
              // Onboarding Image
              Image.asset(
                'assets/images/onboarding-car-image.png',
                fit: BoxFit.contain,
                width: double.infinity,
                height: screenHeight *
                    0.5, // Adjust image size based on screen height
              ),
            ],
          ),
        ),
      );
    });
  }
}
