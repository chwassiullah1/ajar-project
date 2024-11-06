// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/screens/bottom_navigation_bar.dart';
import 'package:ajar/screens/onboarding_screen/onboarding_screen.dart';
import 'package:ajar/services/authentication/auth_servcies.dart';
import 'package:ajar/utils/theme_colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    // Get the access token from SharedPreferences
    String? accessToken = await AuthService.getAccessToken();

    if (accessToken != null) {
      // If access token exists, get user data
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final statusCode = await authProvider.getUserData();

      await Future.delayed(const Duration(milliseconds: 500)); // Adjusted delay

      if (statusCode == 200) {
        // User is logged in, navigate to home screen
        showCustomSnackBar(context, "Welcome Back!", Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreen(),
          ),
        );
      } else {
        // User is not logged in or token refresh failed, navigate to onboarding screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    } else {
      // No access token found, navigate to onboarding screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ajar",
                style: TextStyle(
                  fontSize: 48,
                  color: fMainColor,
                ),
              ),
              Text(
                'Car Rental Services',
                style: TextStyle(
                    fontSize: 24,
                    color: isDarkMode ? Colors.white : Colors.black26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
