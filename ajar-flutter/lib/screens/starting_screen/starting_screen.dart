import 'package:ajar/common/buttons/custom_elevated_button.dart';
import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/screens/authentication/login_screen/login_screen.dart';
import 'package:ajar/screens/authentication/register_screen/register_screen.dart';
import 'package:flutter/material.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'assets/images/road-image.jpeg',
              fit: BoxFit.cover,
            ),
            // Semi-transparent overlay
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
            // Layout with buttons at the bottom and content centered
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Centered content (Title)
                    Positioned(
                      top: constraints.maxHeight * 0.30, // Center the column
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  'Ajar',
                                  style: TextStyle(
                                    fontSize: size.width * 0.12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Car Rental Service',
                                  style: TextStyle(
                                    fontSize: size.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Buttons at the bottom
                    Positioned(
                      bottom: constraints.maxHeight *
                          0.08, // Slightly above the bottom
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomGradientButton(
                            text: "Sign Up",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            width: size.width * 0.8,
                          ),
                          const SizedBox(height: 15),
                          CustomElevatedButton(
                            text: "Login",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            width: size.width * 0.8,
                            borderRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
